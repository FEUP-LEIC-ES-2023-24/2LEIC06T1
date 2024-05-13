import 'package:couch_potato/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class PostInfo extends StatefulWidget {
  final String category;
  final bool acquiredItem;
  const PostInfo({
    super.key,
    required this.category,
    this.acquiredItem = false,
  });

  @override
  State<PostInfo> createState() => _PostInfoState();
}

class _PostInfoState extends State<PostInfo> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Icon(Icons.category, color: appColor, size: 20),
            const SizedBox(width: 5),
            Text(
              widget.category,
              style: const TextStyle(
                color: Color(0xFF555555),
                fontSize: 14,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        SizedBox(height: widget.acquiredItem ? 60 : 30),
        widget.acquiredItem
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'We hope you enjoy and make',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 25,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'good use of this item!',
                    style: TextStyle(
                      color: appColor,
                      fontSize: 27,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              )
            : Row(
                children: [
                  SvgPicture.asset(
                    'assets/hint_icon.svg',
                    colorFilter: const ColorFilter.mode(Color(0xFFACACAC), BlendMode.srcIn),
                    height: 19,
                  ),
                  const SizedBox(width: 15),
                  const Expanded(
                    child: Text(
                      "Closing this post will hide it from the social network. Close this post if you have agreed the logistics through Couch Potato's message system.",
                      style: TextStyle(
                        color: Color(0xFF555555),
                        fontSize: 14,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
      ],
    );
  }
}
