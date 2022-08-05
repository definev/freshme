import 'package:camera/camera.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freshme/camera/controller/fresh_ml_controller.dart';
import 'package:freshme/camera/widgets/scan_me.dart';
import 'package:freshme/_internal/presentation/fresh_dotted_button.dart';
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

  void _initController() async {
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
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = controller?.cameraController;

    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    }
  }

  @override
  void initState() {
    super.initState();
    _initController();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final md = MediaQuery.of(context);

    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: false,
      body: SizedBox(
        height: md.size.height,
        width: md.size.width,
        child: Stack(
          children: [
            Positioned.fill(
              child: controller == null
                  ? const SizedBox()
                  : () {
                      final cameraRatio =
                          controller!.cameraController.value.aspectRatio > 1
                              ? 1 /
                                  controller!.cameraController.value.aspectRatio
                              : controller!.cameraController.value.aspectRatio;

                      return SafeArea(
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: AspectRatio(
                            aspectRatio: cameraRatio,
                            child: CameraPreview(controller!.cameraController),
                          ),
                        ),
                      );
                    }(),
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
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {},
                            icon: const Icon(
                              CommunityMaterialIcons.image,
                              size: 20,
                            ),
                            label: const Text(
                              'Gallery',
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        const Gap(12),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(80, 80),
                          ),
                          onPressed: () =>
                              controller?.takePicture(context, this),
                          child: const Icon(Icons.camera),
                        ),
                        const Gap(12),
                        Expanded(
                          child: HookBuilder(
                            builder: (context) {
                              final flashToggle = useState(false);

                              return ElevatedButton.icon(
                                onPressed: () {
                                  flashToggle.value = !flashToggle.value;
                                  controller?.toggleFlash(flashToggle.value);
                                },
                                icon: Icon(
                                  flashToggle.value
                                      ? CommunityMaterialIcons.flash
                                      : CommunityMaterialIcons.flash_off,
                                  size: 20,
                                ),
                                label: flashToggle.value
                                    ? const Text('On')
                                    : const Text('Off'),
                              );
                            },
                          ),
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
