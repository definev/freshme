import 'package:camera/camera.dart';
import 'package:dartx/dartx.dart';
import 'package:flextras/flextras.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freshme/camera/controller/fresh_ml_controller.dart';
import 'package:freshme/camera/widgets/image_selector.dart';
import 'package:freshme/camera/widgets/self_classification_sheet.dart';
import 'package:gap/gap.dart';
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
  List<bool> _selectedList = [];

  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: 0);
    initializeMLResult();
  }

  void initializeMLResult() async {
    final controller = ref.read(freshMLControllerProvider);
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
        .toList();
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
    _selectedList = List.generate(
      _rects.length,
      (index) => true,
    );

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
                        physics: const NeverScrollableScrollPhysics(),
                        controller: pageController,
                        itemCount: _rects.length,
                        itemBuilder: (context, index) {
                          final rect = _rects[index];
                          final label = _labels[index];
                          final selected = _selectedList[index];

                          return _MLResultPreview(
                            imagePath: widget.imageFile.path,
                            rect: rect,
                            label: label,
                            selected: selected,
                            onRectChanged: (value) => _rects[index] = value,
                          );
                        },
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (currentPage == _rects.length - 1)
                            FloatingActionButton.extended(
                              onPressed: () {},
                              icon: const Icon(Icons.check),
                              label: const Text('Xác nhận'),
                            ),
                          PaddedRow(
                            padding: const EdgeInsets.fromLTRB(12, 16, 12, 16),
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton(
                                onPressed: () async {
                                  if (pageController.page == 0) return;
                                  currentPage =
                                      (pageController.page! - 1).toInt();
                                  pageController.previousPage(
                                    duration: 200.milliseconds,
                                    curve: Curves.decelerate,
                                  );
                                  await Future.delayed(200.milliseconds);
                                  if (mounted) setState(() {});
                                },
                                child: const Icon(Icons.chevron_left_rounded),
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  _selectedList[currentPage]
                                      ? ElevatedButton(
                                          key: ValueKey(
                                              'select_button : $currentPage'),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                theme.colorScheme.error,
                                          ),
                                          onPressed: () {
                                            _selectedList[currentPage] =
                                                !_selectedList[currentPage];
                                            setState(() {});
                                          },
                                          child: Text(
                                            'Loại bỏ',
                                            style: theme.textTheme.bodyMedium!
                                                .copyWith(
                                                    color: theme
                                                        .colorScheme.onError),
                                          ),
                                        )
                                      : ElevatedButton(
                                          key: ValueKey(
                                              'select_button : $currentPage'),
                                          onPressed: () {
                                            _selectedList[currentPage] =
                                                !_selectedList[currentPage];
                                            setState(() {});
                                          },
                                          child: const Text('Xác nhận'),
                                        ),
                                  if (currentPage == _rects.length - 1) ...[
                                    const Gap(12),
                                    ElevatedButton(
                                      onPressed: () async {
                                        final res =
                                            await SelfClassificationSheet.show(
                                          context,
                                          imagePath: widget.imageFile.path,
                                          aspectRatio:
                                              result!.absoluteSize.width /
                                                  result!.absoluteSize.height,
                                        );

                                        if (res != null) {
                                          _rects.add(res.rect);
                                          _labels.add(res.label);
                                          _selectedList.add(true);
                                          setState(() {});
                                        }
                                      },
                                      child: const Icon(Icons.add),
                                    ),
                                  ],
                                ],
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  if (pageController.page ==
                                      _rects.length - 1) {
                                    return;
                                  }

                                  currentPage =
                                      (pageController.page! + 1).toInt();
                                  pageController.nextPage(
                                    duration: 200.milliseconds,
                                    curve: Curves.decelerate,
                                  );
                                  await Future.delayed(200.milliseconds);
                                  if (mounted) setState(() {});
                                },
                                child: const Icon(Icons.chevron_right_rounded),
                              ),
                            ],
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

class _MLResultPreview extends StatelessWidget {
  const _MLResultPreview({
    super.key,
    required this.rect,
    required this.label,
    required this.imagePath,
    required this.selected,
    required this.onRectChanged,
  });

  final Rect rect;
  final String label;
  final String imagePath;
  final bool selected;
  final ValueChanged<Rect> onRectChanged;

  @override
  Widget build(BuildContext context) {
    final topLeft = rect.topLeft;
    final bottomRight = rect.bottomRight;
    final theme = Theme.of(context);

    return Stack(
      children: [
        ImageSelector(
          imagePath,
          initStartOffset: topLeft,
          initEndOffset: bottomRight,
          onStartOffsetChanged: (value) => Rect.fromPoints(
            value,
            rect.bottomRight,
          ),
          onEndOffsetChanged: (value) => Rect.fromPoints(
            rect.topLeft,
            value,
          ),
        ),
        SizedBox(
          height: 56,
          width: double.maxFinite,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white,
                  Colors.white.withOpacity(0.3),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Center(
              child: Text(
                label.isBlank ? 'Không rõ' : label,
                style: theme.textTheme.bodyLarge,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
