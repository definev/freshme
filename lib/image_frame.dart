import 'dart:math';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ImageFrame extends HookWidget {
  const ImageFrame({Key? key}) : super(key: key);

  static const _angle = [
    -1.0,
    -0.8,
    -0.3,
    0.4,
    0.7,
    1.0,
  ];

  @override
  Widget build(BuildContext context) {
    final random = useMemoized(() => Random());
    final rotateVibrant = useState(random.nextInt(_angle.length));

    return Center(
      child: SizedBox(
        height: 200,
        width: 300,
        child: Stack(
          children: [
            Positioned.fill(
              child: Transform.rotate(
                angle: _angle[rotateVibrant.value] * 0.15,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    border: Border.all(width: 2),
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: DottedBorder(
                strokeWidth: 2,
                borderType: BorderType.RRect,
                dashPattern: [3, 3, 1],
                strokeCap: StrokeCap.round,
                radius: Radius.circular(2),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(2),
                    border: Border.all(
                      width: 8,
                      style: BorderStyle.none,
                    ),
                  ),
                  child: Placeholder(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
