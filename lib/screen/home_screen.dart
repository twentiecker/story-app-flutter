import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:story_app_flutter/utils/color_theme.dart';

import '../provider/home_provider.dart';
import '../provider/upload_provider.dart';
import '../utils/style_theme.dart';
import 'camera_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final descController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final ratio = screenSize.height / 803.137269;
    return Scaffold(
      backgroundColor: grey,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
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
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(
                            Icons.arrow_back_ios_new,
                            color: white,
                            size: ratio * 24,
                          ),
                        ),
                        SizedBox(width: screenSize.width * 0.04),
                        Text(
                          'Create Stories',
                          style: headlineSmall(
                            context,
                            ratio,
                          ),
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: () {
                        if (formKey.currentState!.validate()) {
                          _onUpload(descController.text, ratio);
                        }
                      },
                      child: context.watch<UploadProvider>().isUploading
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : Row(
                              children: [
                                Text(
                                  'Post',
                                  style: titleSmall(
                                    context,
                                    ratio,
                                  ),
                                ),
                                SizedBox(width: screenSize.width * 0.01),
                                Icon(
                                  Icons.check_rounded,
                                  color: white,
                                  size: ratio * 20,
                                ),
                              ],
                            ),
                    )
                  ],
                ),
              ),
              SizedBox(height: screenSize.height * 0.04),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                height: screenSize.height * 0.45,
                child: context.watch<HomeProvider>().imagePath == null
                    ? Align(
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.image,
                          size: screenSize.height * 0.2,
                          color: Colors.grey,
                        ),
                      )
                    : _showImage(),
              ),
              SizedBox(height: screenSize.height * 0.03),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Form(
                  key: formKey,
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: "Enter your description",
                      hintStyle: titleMedium(
                        context,
                        ratio,
                        Colors.grey,
                        null,
                      ),
                      prefixIcon: Icon(
                        Icons.notes_rounded,
                        color: lightGreen,
                        size: ratio * 24,
                      ),
                      fillColor: lightGrey,
                      filled: true,
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: lightGrey),
                        borderRadius: BorderRadius.circular(13),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: lightGreen),
                        borderRadius: BorderRadius.circular(13),
                      ),
                    ),
                    style: titleMedium(
                      context,
                      ratio,
                      white,
                      null,
                    ),
                    cursorColor: white,
                    maxLines: 8,
                    controller: descController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please input the description.';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              SizedBox(height: screenSize.height * 0.02),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(
                    color: lightGrey,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        onPressed: () => _onGalleryView(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: lightGrey,
                          elevation: 0,
                        ),
                        child: const Icon(
                          Icons.image_outlined,
                          color: lightGreen,
                          size: 35,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () => _onCameraView(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: lightGrey,
                          elevation: 0,
                        ),
                        child: const Icon(
                          Icons.camera_alt_outlined,
                          color: lightGreen,
                          size: 35,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () => _onCustomCameraView(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: lightGrey,
                          elevation: 0,
                        ),
                        child: const Icon(
                          Icons.camera_outlined,
                          color: lightGreen,
                          size: 35,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: screenSize.height * 0.03),
            ],
          ),
        ),
      ),
    );
  }

  _onUpload(String desc, double ratio) async {
    final ScaffoldMessengerState scaffoldMessengerState =
        ScaffoldMessenger.of(context);
    final uploadProvider = context.read<UploadProvider>();

    final homeProvider = context.read<HomeProvider>();
    final imagePath = homeProvider.imagePath;
    final imageFile = homeProvider.imageFile;
    if (imagePath == null || imageFile == null) {
      return scaffoldMessengerState.showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: green,
          content: Text(
            'Please upload the image',
            style: titleMedium(
              context,
              ratio,
              white,
              null,
            ),
          ),
        ),
      );
    }

    final fileName = imageFile.name;
    final bytes = await imageFile.readAsBytes();

    final newBytes = await uploadProvider.compressImage(bytes);
    await uploadProvider.upload(
      newBytes,
      fileName,
      desc,
    );

    if (uploadProvider.uploadResponse != null) {
      homeProvider.setImageFile(null);
      homeProvider.setImagePath(null);
    }

    scaffoldMessengerState.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: green,
        content: Text(
          uploadProvider.message,
          style: titleMedium(
            context,
            ratio,
            white,
            null,
          ),
        ),
      ),
    );
  }

  _onGalleryView() async {
    final provider = context.read<HomeProvider>();

    final isMacOS = defaultTargetPlatform == TargetPlatform.macOS;
    final isLinux = defaultTargetPlatform == TargetPlatform.linux;
    if (isMacOS || isLinux) return;

    final picker = ImagePicker();

    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      provider.setImageFile(pickedFile);
      provider.setImagePath(pickedFile.path);
    }
  }

  _onCameraView() async {
    final provider = context.read<HomeProvider>();

    final isAndroid = defaultTargetPlatform == TargetPlatform.android;
    final isiOS = defaultTargetPlatform == TargetPlatform.iOS;
    final isNotMobile = !(isAndroid || isiOS);
    if (isNotMobile) return;

    final picker = ImagePicker();

    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
    );

    if (pickedFile != null) {
      provider.setImageFile(pickedFile);
      provider.setImagePath(pickedFile.path);
    }
  }

  _onCustomCameraView() async {
    final provider = context.read<HomeProvider>();
    final navigator = Navigator.of(context);

    final isMacOS = defaultTargetPlatform == TargetPlatform.macOS;
    final isLinux = defaultTargetPlatform == TargetPlatform.linux;
    if (isMacOS || isLinux) return;

    final cameras = await availableCameras();

    final XFile? resultImageFile = await navigator.push(
      MaterialPageRoute(
        builder: (context) => CameraScreen(
          cameras: cameras,
        ),
      ),
    );

    if (resultImageFile != null) {
      provider.setImageFile(resultImageFile);
      provider.setImagePath(resultImageFile.path);
    }
  }

  Widget _showImage() {
    final imagePath = context.read<HomeProvider>().imagePath;
    return kIsWeb
        ? Image.network(
            imagePath.toString(),
            fit: BoxFit.contain,
          )
        : Image.file(
            File(imagePath.toString()),
            fit: BoxFit.contain,
          );
  }
}
