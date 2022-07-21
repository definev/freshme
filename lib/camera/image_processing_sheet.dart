import 'dart:io';
import 'dart:ui' as ui;

import 'package:camera/camera.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freshme/camera/fresh_ml_controller.dart';
import 'package:freshme/camera/translator.dart';
import 'package:google_mlkit_object_detection/google_mlkit_object_detection.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final freshMLControllerProvider = Provider<FreshMLController>(
  (ref) => throw UnimplementedError(),
);

class ImageProcessingSheet extends ConsumerWidget {
  const ImageProcessingSheet(
    this.imageFile, {
    Key? key,
  }) : super(key: key);

  final XFile imageFile;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    const shape = SmoothRectangleBorder(
      borderRadius: SmoothBorderRadius.all(
        SmoothRadius(
          cornerRadius: 30,
          cornerSmoothing: 1.0,
        ),
      ),
    );
    final controller = ref.read(freshMLControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Processing'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        icon: const Icon(Icons.check),
        label: const Text('Submit'),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
        child: Card(
          shape: shape,
          child: DecoratedBox(
            decoration: ShapeDecoration(
              shape: shape.copyWith(
                side: const BorderSide(width: 2),
              ),
            ),
            position: DecorationPosition.foreground,
            child: ClipSmoothRect(
              radius: shape.borderRadius,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Image.file(
                      File(imageFile.path),
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.transparent,
                            theme.colorScheme.secondaryContainer,
                          ],
                          stops: const [0.3, 1.0],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: const [
                      Flexible(
                        flex: 5,
                        fit: FlexFit.tight,
                        child: SizedBox(),
                      ),
                      Flexible(
                        flex: 1,
                        child: _ImageProcessingInfo(),
                      ),
                    ],
                  ),
                  Positioned.fill(
                    child: HookBuilder(
                      builder: (context) {
                        final imageResultFuture = useFuture(
                          controller.processImageFromXFile(imageFile),
                        );

                        if (imageResultFuture.data == null) {
                          return const SizedBox();
                        } else {
                          return CustomPaint(
                            painter: _FreshImageDectectorPainter(
                              imageResultFuture.data!,
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ImageProcessingInfo extends StatelessWidget {
  const _ImageProcessingInfo();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Stack(
          children: [
            Text(
              'ĐỒ VẬT LIÊN QUAN',
              style: theme.textTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.w300,
                foreground: Paint()
                  ..color = theme.colorScheme.onSecondaryContainer,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class FreshMLImageResult {
  final List<DetectedObject> objects;
  final Size absoluteSize;
  final InputImageRotation rotation;

  FreshMLImageResult(this.objects, this.absoluteSize, this.rotation);
}

class _FreshImageDectectorPainter extends CustomPainter {
  _FreshImageDectectorPainter(this.result);

  final FreshMLImageResult result;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..color = Colors.lightGreenAccent;

    final Paint background = Paint()..color = const Color(0x99000000);

    final List<DetectedObject> objects = result.objects;

    for (final DetectedObject detectedObject in objects) {
      final ui.ParagraphBuilder builder = ui.ParagraphBuilder(
        ui.ParagraphStyle(
          textAlign: TextAlign.left,
          fontSize: 16,
          textDirection: TextDirection.ltr,
        ),
      );
      builder.pushStyle(
        ui.TextStyle(
          color: Colors.lightGreenAccent,
          background: background,
        ),
      );

      for (final Label label in detectedObject.labels) {
        builder.addText('${label.text} ${label.confidence}\n');
      }

      builder.pop();

      final rect = _getRect(detectedObject, size);

      _paintFrame(canvas, paint, rect: rect);
      _paintText(canvas, paint, rect: rect, builder: builder);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;

  ui.Rect _getRect(
    DetectedObject detectedObject,
    ui.Size size,
  ) {
    final Size absoluteSize = result.absoluteSize;
    final InputImageRotation rotation = result.rotation;

    final left = translateX(
      detectedObject.boundingBox.left,
      rotation,
      size,
      absoluteSize,
    );
    final top = translateY(
      detectedObject.boundingBox.top,
      rotation,
      size,
      absoluteSize,
    );
    final right = translateX(
      detectedObject.boundingBox.right,
      rotation,
      size,
      absoluteSize,
    );
    final bottom = translateY(
      detectedObject.boundingBox.bottom,
      rotation,
      size,
      absoluteSize,
    );

    return Rect.fromLTRB(left, top, right, bottom);
  }

  void _paintFrame(ui.Canvas canvas, ui.Paint paint, {required Rect rect}) {
    canvas.drawRect(rect, paint);
  }

  void _paintText(
    ui.Canvas canvas,
    ui.Paint paint, {
    required ui.Rect rect,
    required ui.ParagraphBuilder builder,
  }) {
    canvas.drawParagraph(
      builder.build()
        ..layout(ui.ParagraphConstraints(
          width: rect.width,
        )),
      Offset(rect.left, rect.top),
    );
  }
}
