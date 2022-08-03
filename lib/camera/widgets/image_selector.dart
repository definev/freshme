import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ImageSelector extends StatelessWidget {
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
    return LayoutBuilder(
      builder: (context, constraints) {
        return HookBuilder(
          builder: (context) {
            final startOffsetHook = useState<Offset>(
              Offset(
                (initStartOffset?.dx ?? 0) * constraints.maxWidth,
                (initStartOffset?.dy ?? 0) * constraints.maxHeight,
              ),
            );
            final endOffsetHook = useState<Offset?>(
              Offset(
                (initEndOffset?.dx ?? 0) * constraints.maxWidth,
                (initEndOffset?.dy ?? 0) * constraints.maxHeight,
              ),
            );

            final endOffset = endOffsetHook.value;

            void onPanStart(DragStartDetails details) {
              startOffsetHook.value = details.localPosition;
              onStartOffsetChanged?.call(
                Offset(
                  startOffsetHook.value.dx / constraints.maxWidth,
                  startOffsetHook.value.dy / constraints.maxHeight,
                ),
              );
            }

            void onPanUpdate(DragUpdateDetails details) {
              endOffsetHook.value = details.localPosition;
              onEndOffsetChanged?.call(
                Offset(
                  endOffsetHook.value!.dx / constraints.maxWidth,
                  endOffsetHook.value!.dy / constraints.maxHeight,
                ),
              );
            }

            return GestureDetector(
              onPanStart: onPanStart,
              onPanUpdate: onPanUpdate,
              child: Stack(
                children: [
                  Center(child: Image.file(File(imagePath))),
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
                                  onStartOffsetChanged
                                      ?.call(startOffsetHook.value);
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
                                  onEndOffsetChanged
                                      ?.call(endOffsetHook.value!);
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
          },
        );
      },
    );
  }
}
