import 'dart:io';
import 'package:blurhash_ffi/blurhash.dart';
import 'package:couch_potato/classes/post.dart';
import 'package:couch_potato/network/create_post/category_field.dart';
import 'package:couch_potato/network/create_post/location_field.dart';
import 'package:couch_potato/network/database_handler.dart';
import 'package:couch_potato/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:couch_potato/modules/app_bar.dart';
import 'package:couch_potato/network/create_post/description_text_field.dart';
import 'package:couch_potato/network/create_post/media_field.dart';
import 'package:couch_potato/utils/show_pop_up.dart';
import 'package:couch_potato/utils/snackbars.dart';
import 'package:image_cropper/image_cropper.dart';

class CreatePostPage extends StatefulWidget {
  final bool editMode;
  final String postDescription;
  final String postLocation;
  final Category postCategory;
  final int? postId;
  final String? mediaUrl;
  final String? mediaPlaceholder;
  const CreatePostPage({
    super.key,
    this.editMode = false,
    this.postDescription = '',
    this.postLocation = '',
    this.postCategory = Category.furniture,
    this.postId,
    this.mediaUrl,
    this.mediaPlaceholder,
  });

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  bool visibility = true;
  String _description = '';
  String _location = '';
  late Category _category;
  final ImagePicker _picker = ImagePicker();
  XFile? _media;
  late String _profileImageUrl;

  late ImageProvider imageProvider;

  @override
  void initState() {
    super.initState();
    setState(() {
      _description = widget.postDescription;
      _location = widget.postLocation;
      _category = widget.postCategory;
    });
    /* fetchProfileImageUrl(); */ //TODO fetch profile image url
    /* checkFirebaseAuth(); */ //TODO Check Auth on page init
  }

  Future getImageFromGallery() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    if (image != null) {
      final croppedFile = await cropImage(image.path);
      if (croppedFile != null && context.mounted) {
        setState(() {
          _media = XFile(croppedFile.path);
        });
      }
    }
  }

  Future getImageFromCamera() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.camera,
    );
    if (image != null) {
      final croppedFile = await cropImage(image.path);
      if (croppedFile != null && context.mounted) {
        setState(() {
          _media = XFile(croppedFile.path);
        });
      }
    }
  }

  Future<File?> cropImage(String imagePath) async {
    final CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: imagePath,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        compressQuality: 60,
        maxHeight: 1024,
        maxWidth: 1024,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor: Colors.black,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: true,
            backgroundColor: Colors.black,
            cropFrameColor: Colors.white,
            cropGridColor: Colors.white,
            activeControlsWidgetColor: Colors.black,
          ),
        ]);

    if (croppedFile != null) {
      final File croppedImageFile = File(croppedFile.path);

      // Printing the file size
      final fileSize = await croppedImageFile.length();
      debugPrint("Cropped File Size: $fileSize bytes");

      return croppedImageFile;
    }

    return null;
  }

  void descriptionOnSubmitted(String description) {
    setState(() {
      _description = description;
    });
  }

  void locationOnSubmitted(String location) {
    setState(() {
      _location = location;
    });
  }

  void categoryOnSubmitted(Category category) {
    setState(() {
      _category = category;
    });
  }

  Future<String?> generateBlurHash() async {
    final imageProvider = FileImage(File(_media!.path));
    await Future.delayed(const Duration(seconds: 1));
    return await BlurhashFFI.encode(imageProvider, componentX: 3, componentY: 3);
  }

  Future<void> publishPost() async {
    if (_media != null) {
      showLoadingSheet(context, true);
    } else {
      showLoadingSheet(context, false);
    }

    String? blurHash;
    if (_media != null) {
      blurHash = await generateBlurHash();
    }
    if (widget.mediaPlaceholder != null) {
      blurHash = widget.mediaPlaceholder;
    }
    if (mounted) {
      // Remove trailing newline characters
      String cleanedDescription = _description.trimRight();
      String category = _category.toString().split('.').last;
      category = category[0].toUpperCase() + category.substring(1);

      Post post = Post(
        postId: '',
        username: 'username',
        createdAt: DateTime.now().toString(),
        profileImageUrl: _profileImageUrl,
        description: cleanedDescription,
        mediaUrl: _media != null ? _media!.path : widget.mediaUrl!, //TODO send to firebase storage and fetch url
        mediaPlaceholder: blurHash!,
        fullLocation: _location,
        category: category,
      );

      try {
        await DatabaseHandler.publishPost(post);
        if (mounted) {
          Navigator.pop(context);
          Navigator.pop(context);
        }
      } catch (e, stack) {
        if (mounted && e is ShowableError) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            ErrorSnackbar(errorText: e.toString(), context: context),
          );
        } else if (mounted) {
          debugPrint('Error moderating text: $e');
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            ErrorSnackbar(errorText: "An error occurred, please try later", context: context),
          );
        }
        return;
      }
    }
  }

  void editPost() async {
    String cleanedDescription = _description.trimRight();

    /* databaseHandler.editPost(); */ //TODO edit post logic
  }

  @override
  Widget build(BuildContext context) {
    /* void popUpYesMethod() {
      HapticFeedback.selectionClick();
      debugPrint('Deleting post');
      /* databaseHandler.deletePost(widget.postId!); */ //TODO delete post
      Navigator.of(context).pop();
      Navigator.of(context).pop();
    }

    void popUpNoMethod() {
      debugPrint('User rejected post deletion modal');
      Navigator.of(context).pop();
    }

    const String popUpText = 'Are you sure you want to delete this post?'; */

    return Scaffold(
      appBar: const MyAppBar(showBackButton: true),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      widget.editMode ? 'Edit Post' : 'New Post',
                      style: const TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                        color: Color(0xFF2F2F2F),
                      ),
                    ),
                  ),
                  widget.mediaUrl == null ? const SizedBox(height: 10) : const SizedBox(height: 20),
                  /* Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (widget.editMode)
                        TextButton(
                          onPressed: () {
                            showPopUp(context, const Color(0xFFFF6868), popUpYesMethod, popUpNoMethod, popUpText);
                          },
                          child: const Text(
                            'Delete Post',
                            style: TextStyle(
                              color: Color(0xFFFF6868),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Montserrat',
                            ),
                          ),
                        ),
                    ],
                  ), */
                  widget.mediaUrl == null ? const SizedBox(height: 5) : const SizedBox(height: 15),
                  const Text(
                    'Description',
                    style: TextStyle(
                      color: Color(0xFF979797),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Montserrat',
                    ),
                  ),
                  widget.editMode
                      ? DescriptionTextField(
                          onSubmitted: descriptionOnSubmitted,
                          defaultText: widget.postDescription,
                        )
                      : DescriptionTextField(
                          onSubmitted: descriptionOnSubmitted,
                        ),
                  widget.mediaUrl == null ? const SizedBox(height: 15) : const SizedBox(height: 35),
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      MediaField(
                        media: _media,
                        getImageFromGallery: getImageFromGallery,
                        getImageFromCamera: getImageFromCamera,
                        imageUrl: widget.mediaUrl,
                        mediaPlaceholder: widget.mediaPlaceholder,
                        noMedia:
                            (widget.editMode && widget.mediaUrl == null || widget.editMode && widget.mediaUrl == ''),
                      ),
                      if (_media != null)
                        Positioned(
                          top: -15,
                          right: -15,
                          child: IconButton.filled(
                            color: Colors.white,
                            disabledColor: Colors.white,
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(Colors.white),
                            ),
                            onPressed: () {
                              setState(() {
                                _media = null;
                              });
                            },
                            icon: SvgPicture.asset(
                              "assets/delete_icon.svg",
                              // ignore: deprecated_member_use
                              color: const Color(0xFFFF6868),
                              height: 22,
                            ),
                          ),
                        ),
                    ],
                  ),
                  widget.mediaUrl == null ? const SizedBox(height: 10) : const SizedBox(height: 30),
                  widget.editMode
                      ? LocationField(
                          onSubmitted: locationOnSubmitted,
                          defaultText: widget.postLocation,
                        )
                      : LocationField(
                          onSubmitted: locationOnSubmitted,
                        ),
                  widget.editMode
                      ? CategoryField(
                          onSubmitted: categoryOnSubmitted,
                          defaultCategory: widget.postCategory,
                        )
                      : CategoryField(
                          onSubmitted: categoryOnSubmitted,
                        ),
                ],
              ),
            ),
          ),
          Container(
            height: 86,
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.white,
                  blurRadius: 10,
                  spreadRadius: 0.2,
                  offset: Offset(0, -12),
                ),
              ],
            ),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.zero,
                backgroundColor: appColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13),
                ),
                elevation: 3,
              ),
              onPressed: () async {
                HapticFeedback.selectionClick();
                if (_media == null && _description.isEmpty && widget.mediaUrl == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    ErrorSnackbar(errorText: 'Add text or an image to your post', context: context),
                  );
                  return;
                }
                if (widget.editMode) {
                  editPost();
                } else {
                  await publishPost();
                }
              },
              child: const Text(
                'Publish',
                style: TextStyle(
                  color: Color(0xFFFFFFFF),
                  fontSize: 22,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.28,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
