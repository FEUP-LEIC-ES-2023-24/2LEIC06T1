import 'dart:io';
import 'package:blurhash_ffi/blurhashffi_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';

class MediaField extends StatefulWidget {
  final XFile? media;
  final Function getImageFromGallery;
  final Function getImageFromCamera;
  final String? imageUrl;
  final String? mediaPlaceholder;
  final bool noMedia;
  const MediaField({
    super.key,
    required this.media,
    required this.getImageFromGallery,
    required this.getImageFromCamera,
    this.imageUrl,
    this.mediaPlaceholder,
    this.noMedia = false,
  });

  @override
  State<MediaField> createState() => _MediaFieldState();
}

class _MediaFieldState extends State<MediaField> {
  final EdgeInsetsGeometry _contentPadding = const EdgeInsets.symmetric(horizontal: 40, vertical: 0);
  double opacity = 0.0;
  bool showPlaceholder = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 100), () {
      setState(() {
        opacity = 1.0;
      });
    });
  }

  static const TextStyle postTextStyle = TextStyle(
    fontSize: 15,
    color: Color(0xFF545454),
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.w500,
  );

  @override
  Widget build(BuildContext context) {
    return widget.imageUrl != '' && widget.imageUrl != null
        ? AspectRatio(
            aspectRatio: 1 / 1,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: BlurhashFfi(
                key: ValueKey(widget.imageUrl),
                hash: widget.mediaPlaceholder!,
                image: widget.imageUrl,
                imageFit: BoxFit.cover,
              ),
            ),
          )
        : AspectRatio(
            aspectRatio: 1 / 1,
            child: Container(
              height: MediaQuery.of(context).size.width,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                border: Border.all(
                  color: const Color(0xFFDFDFDF),
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: widget.noMedia
                  ? const Center(
                      child: Text(
                        'No Media',
                        style: TextStyle(
                          color: Color(0xFF979797),
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Montserrat',
                        ),
                      ),
                    )
                  : widget.media == null
                      ? IconButton(
                          highlightColor: Colors.transparent,
                          onPressed: () {
                            showModalBottomSheet(
                              showDragHandle: true,
                              isScrollControlled: true,
                              context: context,
                              builder: (BuildContext context) {
                                return Padding(
                                  padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                                  child: BottomSheet(
                                    onClosing: () {},
                                    builder: (context) {
                                      return Wrap(
                                        children: <Widget>[
                                          ListTile(
                                            contentPadding: _contentPadding,
                                            leading: const Icon(Icons.photo_library),
                                            title: const Text('Select from Gallery', style: postTextStyle),
                                            onTap: () {
                                              widget.getImageFromGallery();
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          ListTile(
                                            contentPadding: _contentPadding,
                                            leading: const Icon(Icons.photo_camera),
                                            title: const Text(
                                              'Take a Photo',
                                              style: postTextStyle,
                                            ),
                                            onTap: () {
                                              widget.getImageFromCamera();
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                );
                              },
                            );
                          },
                          icon: SvgPicture.asset(
                            'assets/add_image_icon.svg',
                            // ignore: deprecated_member_use
                            color: const Color(0xFFDFDFDF),
                            height: 40,
                          ),
                        )
                      : AspectRatio(
                          aspectRatio: 1 / 1,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              File(widget.media!.path),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
            ),
          );
  }
}
