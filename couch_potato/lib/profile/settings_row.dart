import 'package:auto_size_text/auto_size_text.dart';
import 'package:couch_potato/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SettingsRow extends StatefulWidget {
  final String iconPath;
  final double iconSize;
  final String text;
  final Widget action;
  final Offset translateOffset;
  final VoidCallback onTap;
  final EdgeInsets padding;
  final double? constrainedHeight;
  final double transformScale;
  const SettingsRow({
    super.key,
    required this.iconPath,
    this.iconSize = 23,
    required this.text,
    this.action = const Icon(
      Icons.arrow_forward_ios,
      size: 20,
      color: Color(0xFF777777),
    ),
    this.translateOffset = const Offset(0, 0),
    required this.onTap,
    required this.padding,
    this.constrainedHeight,
    this.transformScale = 1.0,
  });

  @override
  State<SettingsRow> createState() => _SettingsRowState();
}

class _SettingsRowState extends State<SettingsRow> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: widget.constrainedHeight != null
          ? SizedBox(
              height: widget.constrainedHeight,
              child: settingsRowBuilder(),
            )
          : settingsRowBuilder(),
    );
  }

  Widget iconBuilder() {
    if (widget.iconPath == 'visibility_off_outlined') {
      return Icon(
        Icons.visibility_off_outlined,
        color: appColor,
        size: widget.iconSize,
      );
    } else if (widget.iconPath == 'open_in_browser') {
      return Icon(
        Icons.open_in_browser,
        color: appColor,
        size: widget.iconSize,
      );
    } else if (widget.iconPath == 'subtitles_off') {
      return Icon(
        Icons.subtitles_off_outlined,
        color: appColor,
        size: widget.iconSize,
      );
    } else if (widget.iconPath == 'star') {
      return Icon(
        Icons.star_border,
        color: appColor,
        size: widget.iconSize,
      );
    } else {
      return SvgPicture.asset(
        widget.iconPath,
        // ignore: deprecated_member_use
        color: appColor,
        height: widget.iconSize,
      );
    }
  }

  Widget settingsRowBuilder() {
    return Padding(
      padding: widget.padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Transform.scale(
            scale: widget.transformScale,
            child: Transform.translate(
              offset: widget.translateOffset,
              child: SizedBox(
                width: 25,
                child: iconBuilder(),
              ),
            ),
          ),
          const SizedBox(width: 25),
          Expanded(
            child: AutoSizeText(
              widget.text,
              style: const TextStyle(
                color: Color(0xFF535353),
                fontSize: 15,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w500,
                letterSpacing: 1.28,
              ),
              textAlign: TextAlign.left,
              minFontSize: 10, // minimum font size
              maxLines: 1, // maximum number of lines
              overflow: TextOverflow.ellipsis, // how overflowed text should be handled
            ),
          ),
          widget.action,
        ],
      ),
    );
  }
}
