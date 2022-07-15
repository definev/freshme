import 'package:camera/camera.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:freshme/camera/fresh_ml_controller.dart';
import 'package:freshme/fresh_widget/fresh_dotted_button.dart';
import 'package:freshme/fresh_widget/fresh_chip.dart';
import 'package:freshme/home/home_screen.dart';
import 'package:google_mlkit_object_detection/google_mlkit_object_detection.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> with WidgetsBindingObserver {
  void onNewCameraSelected(CameraDescription description) {}

  FreshMLController? controller;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = controller?.cameraController;

    // App state changed before we got the chance to initialize.
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      onNewCameraSelected(cameraController.description);
    }
  }

  @override
  void initState() {
    super.initState();
    () async {
      if (cameras.isEmpty) return;
      controller = await FreshMLController.startController(
        cameras[0],
        onSuccess: (controller) {
          if (!mounted) {
            return;
          }
          controller.startStreamImage();
          setState(() {});
        },
        onError: (e) {
          if (e is CameraException) {
            switch (e.code) {
              case 'CameraAccessDenied':
                break;
              default:
                break;
            }
          }
        },
      );
    }();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ColoredBox(
        color: Colors.blue,
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: [
              Positioned.fill(
                child: controller == null
                    ? const SizedBox()
                    : Center(
                        child: CameraPreview(
                          controller!.cameraController,
                        ),
                      ),
              ),
              Positioned.fill(
                child: StreamBuilder<List<DetectedObject>?>(
                  stream: controller?.objectStream,
                  builder: (context, snapshot) {
                    final data = snapshot.data;
                    if (data == null || data.isEmpty) {
                      return const SizedBox();
                    }

                    return CustomPaint(
                      painter: ObjectDetectorPainter(
                        data,
                        controller?.imageRotation ??
                            InputImageRotation.rotation0deg,
                        controller?.imageDimension ?? const Size(0, 0),
                      ),
                    );
                  },
                ),
              ),
              SafeArea(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            height: 56,
                            width: 56,
                            child: FreshDottedButton(
                              onPressed: () => Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const HomeScreen(),
                                ),
                              ),
                              child:
                                  const Icon(CommunityMaterialIcons.arrow_left),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(32, 0, 16, 0),
              child: FreshChip(
                height: 56,
                onPressed: () {},
                color: Theme.of(context).colorScheme.secondary,
                child: const Text('Chụp đồ của bạn'),
              ),
            ),
          ),
          FloatingActionButton(
            onPressed: () {},
            shape: const RoundedRectangleBorder(
              side: BorderSide(
                color: Colors.black,
                width: 2,
              ),
            ),
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Theme.of(context).colorScheme.onPrimary,
            child: const Icon(CommunityMaterialIcons.camera),
          ),
        ],
      ),
      backgroundColor: Colors.black,
      bottomSheet: DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.1,
        snap: true,
        maxChildSize: 0.7,
        minChildSize: 0.1,
        snapSizes: const [0.5, 0.7],
        builder: (context, scrollController) => DecoratedBox(
          decoration: const BoxDecoration(color: Colors.white),
          child: ListView.builder(
            controller: scrollController,
            itemBuilder: (context, index) => SizedBox(
              height: 0.3 * MediaQuery.of(context).size.height,
              child: const Center(child: Text('Chụp đồ của bạn')),
            ),
          ),
        ),
      ),
    );
  }
}
