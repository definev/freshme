import 'package:camera/camera.dart';
import 'package:dartx/dartx.dart';
import 'package:flextras/flextras.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freshme/camera/controller/fresh_ml_controller.dart';
import 'package:freshme/camera/widgets/image_selector.dart';
import 'package:gap/gap.dart';
import 'package:google_mlkit_object_detection/google_mlkit_object_detection.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final freshMLControllerProvider = Provider<FreshMLController>(
  (ref) => throw UnimplementedError(),
);

class ImageProcessingSheet extends ConsumerStatefulWidget {
  const ImageProcessingSheet(this.imageFile, {super.key});

  final XFile imageFile;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ImageProcessingSheetState();
}

class _ImageProcessingSheetState extends ConsumerState<ImageProcessingSheet> {
  FreshMLImageResult? result;

  late PageController pageController;

  List<Rect> _rects = [];
  List<String> _labels = [];

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: 0);
    final controller = ref.read(freshMLControllerProvider);
    () async {
      await Future.delayed(1.seconds);
      final receivedResult =
          await controller.processImageFromXFile(widget.imageFile);
      result = receivedResult;
      _rects = receivedResult.objects
              .map(
                (e) => Rect.fromLTRB(
                  e.boundingBox.left / receivedResult.absoluteSize.width,
                  e.boundingBox.top / receivedResult.absoluteSize.height,
                  e.boundingBox.right / receivedResult.absoluteSize.width,
                  e.boundingBox.bottom / receivedResult.absoluteSize.height,
                ),
              )
              .toList() ??
          [];
      _labels = result?.objects
              .map(
                (e) => e.labels.isEmpty
                    ? ''
                    : e.labels
                        .reduce((value, element) =>
                            value.confidence > element.confidence
                                ? value
                                : element)
                        .text,
              )
              .toList() ??
          [];
      setState(() {});
    }();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Phân loại ảnh'),
        centerTitle: true,
      ),
      body: result == null
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: AspectRatio(
                aspectRatio:
                    result!.absoluteSize.width / result!.absoluteSize.height,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: PageView.builder(
                        controller: pageController,
                        itemCount: _rects.length,
                        itemBuilder: (context, index) {
                          final rect = _rects[index];
                          final label = _labels[index];

                          return LayoutBuilder(
                            builder: (context, constraints) {
                              final width = constraints.maxWidth;
                              final height = constraints.maxHeight;
                              final topLeft = rect.topLeft;
                              final bottomRight = rect.bottomRight;

                              return Stack(
                                children: [
                                  ImageSelector(
                                    widget.imageFile.path,
                                    initStartOffset: Offset(
                                      topLeft.dx * width,
                                      topLeft.dy * height,
                                    ),
                                    initEndOffset: Offset(
                                      bottomRight.dx * width,
                                      bottomRight.dy * height,
                                    ),
                                    onStartOffsetChanged: (value) {
                                      _rects[index] = Rect.fromPoints(
                                        Offset(
                                          value.dx / width,
                                          value.dy / height,
                                        ),
                                        rect.bottomRight,
                                      );
                                    },
                                    onEndOffsetChanged: (value) {
                                      _rects[index] = Rect.fromPoints(
                                        rect.topLeft,
                                        Offset(
                                          value.dx / width,
                                          value.dy / height,
                                        ),
                                      );
                                    },
                                    key: ValueKey(index),
                                  ),
                                  SizedBox(
                                    height: 56,
                                    width: double.maxFinite,
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.white.withOpacity(0.9),
                                            Colors.white.withOpacity(0.0),
                                          ],
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                        ),
                                      ),
                                      child: Center(child: Text(label)),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: PaddedRow(
                        padding: const EdgeInsets.fromLTRB(12, 0, 12, 16),
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              if (pageController.page == 0) {
                                return;
                              }
                              pageController.previousPage(
                                duration: 200.milliseconds,
                                curve: Curves.decelerate,
                              );
                            },
                            child: Icon(Icons.chevron_left_rounded),
                          ),
                          ElevatedButton(
                            onPressed: () {},
                            child: Text('Loại bỏ'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              if (pageController.page == _rects.length - 1) {
                                return;
                              }

                              pageController.nextPage(
                                duration: 200.milliseconds,
                                curve: Curves.decelerate,
                              );
                            },
                            child: Icon(Icons.chevron_right_rounded),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

class FreshMLImageResult {
  final List<DetectedObject> objects;
  final Size absoluteSize;
  final InputImageRotation rotation;

  FreshMLImageResult(this.objects, this.absoluteSize, this.rotation);
}
