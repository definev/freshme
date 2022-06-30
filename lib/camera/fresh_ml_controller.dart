import 'dart:async';
import 'dart:ui' as ui;

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
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
    controller.cameraController = CameraController(
      desc,
      ResolutionPreset.veryHigh,
    );

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

  void dispose() async {
    await cameraController.stopImageStream();
    await cameraController.dispose();
    _objectStreamController.close();
    await _objectDetector.close();
  }

  InputImage _convertImage(CameraImage cameraImage) {
    final WriteBuffer allBytes = WriteBuffer();
    for (final Plane plane in cameraImage.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();

    final Size imageSize =
        Size(cameraImage.width.toDouble(), cameraImage.height.toDouble());

    final InputImageRotation imageRotation =
        InputImageRotationValue.fromRawValue(
      cameraController.description.sensorOrientation,
    )!;

    final InputImageFormat inputImageFormat =
        InputImageFormatValue.fromRawValue(cameraImage.format.raw)!;

    final planeData = cameraImage.planes.map(
      (Plane plane) {
        return InputImagePlaneMetadata(
          bytesPerRow: plane.bytesPerRow,
          height: plane.height,
          width: plane.width,
        );
      },
    ).toList();

    final inputImageData = InputImageData(
      size: imageSize,
      imageRotation: imageRotation,
      inputImageFormat: inputImageFormat,
      planeData: planeData,
    );

    final inputImage =
        InputImage.fromBytes(bytes: bytes, inputImageData: inputImageData);

    return inputImage;
  }

  final _objectStreamController =
      StreamController<List<DetectedObject>>.broadcast();
  Stream<List<DetectedObject>> get objectStream =>
      _objectStreamController.stream;

  InputImageRotation? imageRotation;
  Size? imageDimension;

  void startStreamImage() {
    List<DetectedObject> objects = [];
    cameraController.startImageStream(
      (image) async {
        final convertedImage = _convertImage(image);
        imageRotation ??= convertedImage.inputImageData!.imageRotation;
        imageDimension ??= convertedImage.inputImageData!.size;

        objects = await _objectDetector.processImage(convertedImage);

        _objectStreamController.sink.add(objects);
      },
    );
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

      canvas.drawRect(
        Rect.fromLTRB(left, top, right, bottom),
        paint,
      );

      canvas.drawParagraph(
        builder.build()
          ..layout(ui.ParagraphConstraints(
            width: right - left,
          )),
        Offset(left, top),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
