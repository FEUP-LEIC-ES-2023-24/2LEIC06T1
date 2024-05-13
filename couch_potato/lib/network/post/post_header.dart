import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class PostHeader extends StatefulWidget {
  final String name;
  final String footer;
  final dynamic profileImageUrl;

  const PostHeader({
    super.key,
    required this.name,
    required this.footer,
    required this.profileImageUrl,
  });

  @override
  State<PostHeader> createState() => _PostHeaderState();
}

class _PostHeaderState extends State<PostHeader> {
  bool showTooltip = false;

  @override
  Widget build(BuildContext context) {
    bool typeConditionString = widget.profileImageUrl is String;
    bool typeConditionFile = widget.profileImageUrl is File?;
    ImageProvider<Object>? backgroundImage;

    if (typeConditionString) {
      backgroundImage = CachedNetworkImageProvider(
        widget.profileImageUrl,
        errorListener: (e) {
          debugPrint('Failed to load image. $e');
        },
      );
    } else if (typeConditionFile) {
      backgroundImage = FileImage(widget.profileImageUrl);
    } else {
      debugPrint('Failed to load image.');
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //onPressed: () {print('\nn\n post owner pressed');}
      children: [
        Transform.translate(
          offset: const Offset(-5, 0),
          child: Transform.scale(
            scale: 0.8,
            child: CircleAvatar(
              radius: 27.5,
              backgroundImage: backgroundImage,
            ),
          ),
        ),
        const SizedBox(width: 5.0),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(5, 8, 0, 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    widget.name,
                    style: const TextStyle(
                      color: Color(0xFF545454),
                      fontSize: 14,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Text(
                  widget.footer,
                  style: const TextStyle(
                    color: Color(0xFFB6B6B6),
                    fontSize: 14,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
