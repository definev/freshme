import 'dart:io';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:freshme/camera/image_processing_sheet.dart';
import 'package:freshme/camera/translator.dart';
import 'package:google_mlkit_object_detection/google_mlkit_object_detection.dart';

class ImageSelector extends HookWidget {
  const ImageSelector(
    this.imagePath, {
    super.key,
    this.initStartOffset,
    this.initEndOffset,
    this.onStartOffsetChanged,
    this.onEndOffsetChanged,
  });

  final String imagePath;
  final Offset? initStartOffset;
  final Offset? initEndOffset;
  final ValueChanged<Offset>? onStartOffsetChanged;
  final ValueChanged<Offset>? onEndOffsetChanged;

  @override
  Widget build(BuildContext context) {
    final startOffsetHook = useState<Offset>(initStartOffset ?? Offset.zero);
    final endOffsetHook = useState<Offset?>(initEndOffset);

    void onPanStart(DragStartDetails details) {
      startOffsetHook.value = details.localPosition;
      onStartOffsetChanged?.call(startOffsetHook.value);
    }

    void onPanUpdate(DragUpdateDetails details) {
      endOffsetHook.value = details.localPosition;
      onEndOffsetChanged?.call(endOffsetHook.value!);
    }

    void onPanEnd(DragEndDetails details) {}

    final endOffset = endOffsetHook.value;

    return GestureDetector(
      onPanStart: onPanStart,
      onPanUpdate: onPanUpdate,
      onPanEnd: onPanEnd,
      child: Stack(
        children: [
          Image.file(
            File(imagePath),
            fit: BoxFit.cover,
            width: double.maxFinite,
          ),
          if (endOffset != null)
            () {
              final trueStartOffset = Offset(
                min(startOffsetHook.value.dx, endOffset.dx),
                min(startOffsetHook.value.dy, endOffset.dy),
              );
              final rectSize = Size(
                (endOffset.dx - startOffsetHook.value.dx).abs(),
                (endOffset.dy - startOffsetHook.value.dy).abs(),
              );

              return Positioned.fromRect(
                rect: trueStartOffset & rectSize,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: ColoredBox(
                        color: Colors.white.withOpacity(0.15),
                      ),
                    ),
                    Positioned.fromRect(
                      rect: Rect.fromLTWH(
                        trueStartOffset.dx - startOffsetHook.value.dx,
                        trueStartOffset.dy - startOffsetHook.value.dy,
                        24,
                        24,
                      ),
                      child: GestureDetector(
                        onPanUpdate: (details) {
                          startOffsetHook.value =
                              startOffsetHook.value + details.delta;
                          onStartOffsetChanged?.call(startOffsetHook.value);
                        },
                        child: const ColoredBox(color: Colors.white),
                      ),
                    ),
                    Positioned.fromRect(
                      rect: Rect.fromLTWH(
                        trueStartOffset.dx -
                            startOffsetHook.value.dx +
                            rectSize.width -
                            24,
                        trueStartOffset.dy -
                            startOffsetHook.value.dy +
                            rectSize.height -
                            24,
                        24,
                        24,
                      ),
                      child: GestureDetector(
                        onPanUpdate: (details) {
                          endOffsetHook.value =
                              endOffsetHook.value! + details.delta;
                          onEndOffsetChanged?.call(endOffsetHook.value!);
                        },
                        child: const ColoredBox(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              );
            }(),
        ],
      ),
    );
  }
}

class _FreshImageDectectorPainter extends CustomPainter {
  _FreshImageDectectorPainter(this.result);

  final FreshMLImageResult result;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = Colors.black;

    final List<DetectedObject> objects = result.objects;

    for (final DetectedObject detectedObject in objects) {
      final rect = _getRect(detectedObject, size);

      _paintFrame(canvas, paint, rect: rect);
      _paintText(
        canvas,
        paint,
        rect: rect,
        text: detectedObject.labels
            .reduce(
              (value, element) =>
                  value.confidence > element.confidence ? value : element,
            )
            .text,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;

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
    rect = Rect.fromPoints(
      rect.topLeft.translate(-5, -10),
      rect.bottomRight.translate(5, 10),
    );
    final innerPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          Colors.cyan.withOpacity(0.4),
          Colors.red.withOpacity(0.4),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(rect);
    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(20));
    canvas.drawRRect(rrect, innerPaint);
    canvas.drawRRect(rrect, paint);
  }

  void _paintText(
    ui.Canvas canvas,
    ui.Paint paint, {
    required ui.Rect rect,
    required String text,
  }) {
    final ui.ParagraphBuilder builder = ui.ParagraphBuilder(
      ui.ParagraphStyle(
        textAlign: TextAlign.center,
        fontSize: 16,
      ),
    )
      ..pushStyle(
        ui.TextStyle(
          color: Colors.white70,
          fontFamily: 'BeVietnamPro',
        ),
      )
      ..addText(text)
      ..pop();

    canvas.drawParagraph(
      builder.build() //
        ..layout(ui.ParagraphConstraints(width: rect.width)),
      rect.bottomLeft.translate(0, -32),
    );
  }
}
