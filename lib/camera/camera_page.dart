import 'dart:io';
import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freshme/camera/fresh_ml_controller.dart';
import 'package:freshme/camera/fresh_modal_bottom_sheet.dart';
import 'package:freshme/camera/scan_me.dart';
import 'package:freshme/fresh_widget/fresh_dotted_button.dart';
import 'package:freshme/home/home_screen.dart';
import 'package:gap/gap.dart';

class CameraPage extends ConsumerStatefulWidget {
  const CameraPage({super.key});

  @override
  ConsumerState<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends ConsumerState<CameraPage>
    with WidgetsBindingObserver {
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
      backgroundColor: const Color(0xFF444442),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            Positioned.fill(
              child: controller == null
                  ? const SizedBox()
                  : CameraPreview(controller!.cameraController),
            ),
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.only(top: 56),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const SafeArea(child: ScanMe()),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Gap(32),
                        IgnorePointer(
                          child: Opacity(
                            opacity: 0,
                            child: HookBuilder(
                              builder: (context) {
                                return ElevatedButton(
                                  onPressed: () {},
                                  child: Row(
                                    children: const [
                                      Icon(
                                        CommunityMaterialIcons.flash_off,
                                        size: 20,
                                      ),
                                      Gap(8),
                                      Text('Off'),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        Builder(
                          builder: (context) {
                            return ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size(80, 80),
                              ),
                              onPressed: () {
                                controller?.takePicture(context, this);
                              },
                              child: const Icon(Icons.camera),
                            );
                          },
                        ),
                        HookBuilder(
                          builder: (context) {
                            final flashToggle = useState(false);

                            return ElevatedButton(
                              onPressed: () {
                                flashToggle.value = !flashToggle.value;
                                controller?.toggleFlash(flashToggle.value);
                              },
                              child: Row(
                                children: [
                                  Icon(
                                    flashToggle.value
                                        ? CommunityMaterialIcons.flash
                                        : CommunityMaterialIcons.flash_off,
                                    size: 20,
                                  ),
                                  const Gap(8),
                                  flashToggle.value
                                      ? const Text('On')
                                      : const Text('Off'),
                                ],
                              ),
                            );
                          },
                        ),
                        const Gap(32),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  height: 56,
                  width: 56,
                  child: FreshDottedButton(
                    onPressed: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const HomeScreen(),
                      ),
                    ),
                    child: const Icon(CommunityMaterialIcons.arrow_left),
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
