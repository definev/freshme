import 'dart:async';
import 'dart:ui' as ui;

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freshme/camera/fresh_modal_bottom_sheet.dart';
import 'package:freshme/camera/image_processing_sheet.dart';
import 'package:freshme/camera/translator.dart';
import 'package:freshme/donation/dependencies.dart';
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
    controller.cameraController = CameraController(desc, ResolutionPreset.max);

    try {
      await controller.cameraController.initialize();
      controller.cameraController.setFlashMode(FlashMode.off);
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
    cameraController.dispose();
    _objectDetector.close();
  }

  void takePicture(BuildContext context, ConsumerState state) async {
    final sm = ScaffoldMessenger.of(context);
    sm.showMaterialBanner(
      const MaterialBanner(
        content: Text('Đang xử lí ảnh ...'),
        actions: [SizedBox()],
      ),
    );
    final imageFile = await cameraController.takePicture();
    sm.clearMaterialBanners();
    await cameraController.pausePreview();
    final mounted = state.mounted;
    if (!mounted) return;
    await showFreshModalBottomSheet(
      context,
      onClosing: continueScanning,
      child: WillPopScope(
        onWillPop: () async {
          continueScanning();
          return true;
        },
        child: ProviderScope(
          overrides: [
            freshMLControllerProvider.overrideWithValue(this),
          ],
          child: ImageProcessingSheet(imageFile),
        ),
      ),
    );
  }

  void continueScanning() async {
    await cameraController.resumePreview();
  }

  Future<FreshMLImageResult> processImageFromXFile(XFile file) async {
    final inputImage = InputImage.fromFilePath(file.path);
    final detectedObjects = await _objectDetector.processImage(inputImage);
    final image = await decodeImageFromList(await file.readAsBytes());
    return FreshMLImageResult(
      detectedObjects,
      Size(image.width.toDouble(), image.height.toDouble()),
      InputImageRotation.rotation0deg,
    );
  }
}
