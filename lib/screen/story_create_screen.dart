import 'dart:io';

import 'package:camera/camera.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:story_app_flutter/utils/color_theme.dart';

import '../provider/add_story_image_provider.dart';
import '../provider/add_story_provider.dart';
import '../utils/style_theme.dart';

class StoryCreateScreen extends StatefulWidget {
  final Function() onListStory;
  final Function(List<CameraDescription>) onCamera;

  const StoryCreateScreen({
    super.key,
    required this.onListStory,
    required this.onCamera,
  });

  @override
  State<StoryCreateScreen> createState() => _StoryCreateScreenState();
}

class _StoryCreateScreenState extends State<StoryCreateScreen> {
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
                          onTap: () => widget.onListStory(),
                          child: Icon(
                            Icons.arrow_back_ios_new,
                            color: white,
                            size: ratio * 24,
                          ),
                        ),
                        SizedBox(width: screenSize.width * 0.04),
                        Text(
                          'Create',
                          style: headlineSmall(
                            context,
                            ratio,
                          ),
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: () async {
                        if (formKey.currentState!.validate()) {
                          await _onUpload(descController.text, ratio);
                          widget.onListStory();
                        }
                      },
                      child: context.watch<AddStoryProvider>().isUploading
                          ? const CircularProgressIndicator(color: white)
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
                child: context.watch<AddStoryImageProvider>().imagePath == null
                    ? DottedBorder(
                        borderType: BorderType.RRect,
                        radius: const Radius.circular(12),
                        color: Colors.grey,
                        dashPattern: const [15, 6],
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            color: lightGrey,
                            child: Align(
                              alignment: Alignment.center,
                              child: Icon(
                                Icons.image,
                                size: screenSize.height * 0.2,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      )
                    : _showImage(),
              ),
              SizedBox(height: screenSize.height * 0.04),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Form(
                  key: formKey,
                  child: TextFormField(
                    onChanged: (text) {
                      _onDescription(text);
                    },
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
    final uploadProvider = context.read<AddStoryProvider>();

    final homeProvider = context.read<AddStoryImageProvider>();
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

    if (uploadProvider.addStoryResponse != null) {
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

  _onDescription(String value) {
    final provider = context.read<AddStoryImageProvider>();
    provider.setDescription(value);
  }

  _onGalleryView() async {
    final provider = context.read<AddStoryImageProvider>();

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
    final provider = context.read<AddStoryImageProvider>();

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
    final provider = context.read<AddStoryImageProvider>();

    final isMacOS = defaultTargetPlatform == TargetPlatform.macOS;
    final isLinux = defaultTargetPlatform == TargetPlatform.linux;
    if (isMacOS || isLinux) return;

    final cameras = await availableCameras();

    widget.onCamera(cameras);
    final XFile? resultImageFile =
        await context.read<AddStoryImageProvider>().waitForResult();

    if (resultImageFile != null) {
      provider.setImageFile(resultImageFile);
      provider.setImagePath(resultImageFile.path);
    }
  }

  Widget _showImage() {
    final imagePath = context.read<AddStoryImageProvider>().imagePath;
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
