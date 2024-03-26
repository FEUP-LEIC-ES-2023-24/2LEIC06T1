import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class PostActions extends StatefulWidget {
  final Function favFunction;
  final Function sharePostFunction;
  final bool isFavorite;
  const PostActions({
    super.key,
    required this.favFunction,
    required this.sharePostFunction,
    required this.isFavorite,
  });

  @override
  State<PostActions> createState() => _PostActionsState();
}

class _PostActionsState extends State<PostActions> {
  @override
  Widget build(BuildContext context) {
    return Row(
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
    );
  }
}
