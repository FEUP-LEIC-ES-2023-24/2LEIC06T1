import 'package:couch_potato/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ClosePostInfo extends StatefulWidget {
  final String category;
  const ClosePostInfo({
    super.key,
    required this.category,
  });

  @override
  State<ClosePostInfo> createState() => _ClosePostInfoState();
}

class _ClosePostInfoState extends State<ClosePostInfo> {
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
        const SizedBox(height: 30),
        Row(
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
