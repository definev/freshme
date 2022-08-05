import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:freshme/camera/widgets/image_selector.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class SelfClassificationResult {
  final String label;
  final Rect rect;

  SelfClassificationResult(this.label, this.rect);
}

class SelfClassificationSheet extends HookWidget {
  const SelfClassificationSheet({
    super.key,
    required this.imagePath,
    required this.aspectRatio,
  });

  final String imagePath;
  final double aspectRatio;

  static Future<SelfClassificationResult?> show(
    BuildContext context, {
    required String imagePath,
    required double aspectRatio,
  }) async {
    final result =
        await showCupertinoModalBottomSheet<SelfClassificationResult?>(
      context: context,
      builder: (context) => SelfClassificationSheet(
        imagePath: imagePath,
        aspectRatio: aspectRatio,
      ),
    );
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final labelHook = useState<String>('');
    final rectHook = useState<Rect?>(null);

    return Scaffold(
      extendBody: true,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Tự phân loại'),
        actions: [
          IconButton(
            padding: EdgeInsets.zero,
            onPressed: () {
              final rect = rectHook.value;
              if (rect == null || rect.topLeft == rect.bottomRight) return;

              Navigator.pop(
                context,
                SelfClassificationResult(labelHook.value, rect),
              );
            },
            icon: const SizedBox(
              width: 56,
              child: Icon(Icons.check),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: TextField(
                decoration: const InputDecoration(hintText: 'Nhập tên'),
                onChanged: (value) => labelHook.value = value,
              ),
            ),
            Expanded(
              child: AspectRatio(
                aspectRatio: aspectRatio,
                child: ImageSelector(
                  imagePath,
                  onStartOffsetChanged: (value) //
                      =>
                      rectHook.value = Rect.fromPoints(
                    value,
                    rectHook.value?.bottomRight ?? value,
                  ),
                  onEndOffsetChanged: (value) //
                      =>
                      rectHook.value = Rect.fromPoints(
                    rectHook.value?.topLeft ?? value,
                    value,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
