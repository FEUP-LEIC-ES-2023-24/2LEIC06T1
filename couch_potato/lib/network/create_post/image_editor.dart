import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

class ImageEditorPage extends StatefulWidget {
  final XFile imageFile;

  const ImageEditorPage({super.key, required this.imageFile});

  @override
  ImageEditorPageState createState() => ImageEditorPageState();
}

class ImageEditorPageState extends State<ImageEditorPage> {
  late ImageProvider imageProvider;

  @override
  void initState() {
    super.initState();
    imageProvider = FileImage(File(widget.imageFile.path));
  }

  Future<void> cropImage() async {
    final croppedFile = await ImageCropper().cropImage(sourcePath: widget.imageFile.path, uiSettings: [
      AndroidUiSettings(
        toolbarTitle: 'Crop Image',
        toolbarColor: Colors.black,
        toolbarWidgetColor: Colors.white,
        activeControlsWidgetColor: Colors.black,
        backgroundColor: Colors.black,
        cropFrameColor: Colors.white,
        cropGridColor: Colors.white,
        lockAspectRatio: true,
        initAspectRatio: CropAspectRatioPreset.square,
      ),
    ]);

    if (croppedFile != null) {
      setState(() {
        imageProvider = FileImage(File(croppedFile.path));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Edit Image'),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Image(image: imageProvider),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await cropImage();
          // Return the edited image when done
          if (context.mounted) {
            Navigator.pop(context, imageProvider);
          }
        },
        child: const Icon(Icons.crop),
      ),
    );
  }
}
