import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_app_flutter/provider/add_story_image_provider.dart';
import 'package:story_app_flutter/utils/color_theme.dart';

import '../utils/style_theme.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({
    super.key,
    required this.cameras,
    required this.onCreateStory,
  });

  final List<CameraDescription> cameras;
  final Function() onCreateStory;

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen>
    with WidgetsBindingObserver {
  bool _isCameraInitialized = false;

  CameraController? controller;

  bool _isBackCameraSelected = true;

  void onNewCameraSelected(CameraDescription cameraDescription) async {
    final previousCameraController = controller;
    final cameraController = CameraController(
      cameraDescription,
      ResolutionPreset.medium,
    );

    await previousCameraController?.dispose();

    try {
      await cameraController.initialize();
    } on CameraException catch (e) {
      if (kDebugMode) {
        print('Error initializing camera: $e');
      }
    }

    if (mounted) {
      setState(() {
        controller = cameraController;
        _isCameraInitialized = controller!.value.isInitialized;
      });
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);

    onNewCameraSelected(widget.cameras.first);

    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    controller?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = controller;

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
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final ratio = screenSize.height / 803.137269;
    return Theme(
      data: ThemeData.dark(),
      child: Scaffold(
        backgroundColor: grey,
        body: SafeArea(
          child: Column(
            children: [
              SizedBox(height: screenSize.height * 0.04),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        InkWell(
                          onTap: () => widget.onCreateStory(),
                          child: Icon(
                            Icons.arrow_back_ios_new,
                            color: white,
                            size: ratio * 24,
                          ),
                        ),
                        SizedBox(width: screenSize.width * 0.04),
                        Text(
                          'Camera',
                          style: headlineSmall(
                            context,
                            ratio,
                          ),
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: () => _onCameraSwitch(),
                      child: Row(
                        children: [
                          Text(
                            'Switch',
                            style: titleSmall(
                              context,
                              ratio,
                            ),
                          ),
                          SizedBox(width: screenSize.width * 0.02),
                          Icon(
                            Icons.cameraswitch_outlined,
                            color: white,
                            size: ratio * 22,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                child: Center(
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      _isCameraInitialized
                          ? Padding(
                              padding: const EdgeInsets.only(bottom: 30),
                              child: CameraPreview(controller!),
                            )
                          : const Center(
                              child: CircularProgressIndicator(color: white),
                            ),
                      _isCameraInitialized ? _actionWidget() : const Text(''),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _actionWidget() {
    return FloatingActionButton(
      backgroundColor: green,
      heroTag: "take-picture",
      tooltip: "Take Picture",
      onPressed: () => _onCameraButtonClick(),
      child: const Icon(
        Icons.camera_outlined,
        size: 35,
        color: white,
      ),
    );
  }

  Future<void> _onCameraButtonClick() async {
    final image = await controller?.takePicture();

    widget.onCreateStory();
    context.read<AddStoryImageProvider>().returnData(image);
  }

  void _onCameraSwitch() {
    if (widget.cameras.length == 1) return;

    setState(() {
      _isCameraInitialized = false;
    });

    onNewCameraSelected(
      widget.cameras[_isBackCameraSelected ? 1 : 0],
    );

    setState(() {
      _isBackCameraSelected = !_isBackCameraSelected;
    });
  }
}
