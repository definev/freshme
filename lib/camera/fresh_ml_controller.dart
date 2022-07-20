import 'dart:async';
import 'dart:ui' as ui;

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freshme/camera/translator.dart';
import 'package:google_mlkit_object_detection/google_mlkit_object_detection.dart';

import 'dart:io' as io;
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

Future<String> _getModel(String assetPath) async {
  if (io.Platform.isAndroid) {
    return 'flutter_assets/$assetPath';
  }
  final path = '${(await getApplicationSupportDirectory()).path}/$assetPath';
  await io.Directory(dirname(path)).create(recursive: true);
  final file = io.File(path);
  if (!await file.exists()) {
    final byteData = await rootBundle.load(assetPath);
    await file.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
  }

  return file.path;
}

List<CameraDescription> cameras = [];

class FreshMLController {
  FreshMLController._();

  static Future<FreshMLController> startController(
    CameraDescription desc, {
    required Function(FreshMLController controller) onSuccess,
    required Function(Object e) onError,
  }) async {
    final controller = FreshMLController._();
    controller.cameraController = CameraController(desc, ResolutionPreset.high);

    try {
      await controller.cameraController.initialize();
      await controller._initializeObjectDetector();
      onSuccess(controller);
    } catch (e) {
      onError(e);
    }

    return controller;
  }

  late CameraController cameraController;
  late final ObjectDetector _objectDetector;

  Future<void> _initializeObjectDetector() async {
    const path = 'assets/ml/object_labeler.tflite';
    final modelPath = await _getModel(path);
    final options = LocalObjectDetectorOptions(
      mode: DetectionMode.stream,
      modelPath: modelPath,
      classifyObjects: true,
      multipleObjects: true,
    );
    _objectDetector = ObjectDetector(options: options);
  }

  void toggleFlash(bool value) {
    cameraController.setFlashMode(value ? FlashMode.torch : FlashMode.off);
  }

  void dispose() async {
    await cameraController.stopImageStream();
    await cameraController.dispose();
    await _objectDetector.close();
  }

  void takePicture(WidgetRef ref) async {
    final imageFile = await cameraController.takePicture();
    await cameraController.pausePreview();
    ref.read(capturedImageProvider.notifier).state = imageFile;
  }

  void continueScanning(WidgetRef ref) async {
    ref.read(capturedImageProvider.notifier).state = null;
    await cameraController.resumePreview();
  }

  Future<List<DetectedObject>> processImageFromXFile(XFile file) async {
    final detectedObjects = await _objectDetector.processImage(
      InputImage.fromFilePath(file.path),
    );

    return detectedObjects;
  }
}

class ObjectDetectorPainter extends CustomPainter {
  ObjectDetectorPainter(this._objects, this.rotation, this.absoluteSize);

  final List<DetectedObject> _objects;
  final Size absoluteSize;
  final InputImageRotation rotation;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..color = Colors.lightGreenAccent;

    final Paint background = Paint()..color = const Color(0x99000000);

    for (final DetectedObject detectedObject in _objects) {
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

final capturedImageProvider = StateProvider<XFile?>((ref) => null);
