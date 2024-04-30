import 'package:couch_potato/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class PostFooter extends StatefulWidget {
  final String fullLocation;
  final Function favFunction;
  final Function sharePostFunction;
  final bool isFavorite;
  const PostFooter({
    super.key,
    required this.fullLocation,
    required this.favFunction,
    required this.sharePostFunction,
    required this.isFavorite,
  });

  @override
  State<PostFooter> createState() => _PostFooterState();
}

class _PostFooterState extends State<PostFooter> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Row(
          children: [
            Icon(Icons.location_pin, color: appColor, size: 20),
            Text(
              widget.fullLocation,
              style: const TextStyle(
                color: Color(0xFF555555),
                fontSize: 14,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Transform.translate(
              offset: const Offset(-10, 0),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(widget.isFavorite ? Icons.star : Icons.star_border),
                    color: widget.isFavorite ? const Color(0xFFFFC700) : null,
                    onPressed: () async {
                      await widget.favFunction();
                    },
                  ),
                ],
              ),
            ),
            Transform.translate(
              offset: const Offset(0, -1),
              child: IconButton(
                onPressed: () {
                  widget.sharePostFunction();
                },
                icon: SvgPicture.asset(
                  'assets/share_post_icon.svg',
                  height: 28,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
