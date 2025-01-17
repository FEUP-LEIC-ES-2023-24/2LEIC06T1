import 'dart:io';
import 'package:couch_potato/modules/card_widget.dart';
import 'package:couch_potato/network/database_handler.dart';
import 'package:couch_potato/network/post/post_footer.dart';
import 'package:couch_potato/network/post/post_header.dart';
import 'package:couch_potato/network/redirected_post/redirected_post.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:blurhash_ffi/blurhash_ffi.dart';
import 'package:share_plus/share_plus.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SocialPost extends StatefulWidget {
  final String profileImageUrl;
  final String name;
  final String timestamp;
  final String text;
  final String mediaPlaceholder;
  final String imageUrl;
  final String postId;
  final String fullLocation;
  final String category;
  final String userId;
  final bool closedPosts;
  final String parrentWidget;
  const SocialPost({
    super.key,
    required this.profileImageUrl,
    required this.name,
    required this.timestamp,
    required this.text,
    required this.mediaPlaceholder,
    required this.imageUrl,
    required this.postId,
    required this.fullLocation,
    required this.category,
    required this.userId,
    this.closedPosts = false,
    required this.parrentWidget,
  });

  @override
  State<SocialPost> createState() => _SocialPostState();
}

class _SocialPostState extends State<SocialPost> with SingleTickerProviderStateMixin {
  late TransformationController _transformationController;
  late AnimationController _controllerReset;
  Animation<Matrix4>? _animationReset;

  double opacity = 0.0;
  bool showPlaceholder = true;

  bool isFavorite = false;

  @override
  void initState() {
    if (!mounted) return;
    fetchIsFavorite();
    super.initState();
    /*  if (widget.imageUrl != null) generateAndPrintBlurHash(); */
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        setState(() {
          opacity = 1.0;
        });
      }
    });
    _transformationController = TransformationController();
    _controllerReset = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
  }

  Future<void> fetchIsFavorite() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favorites = prefs.getStringList('favorites') ?? [];

    bool value = favorites.contains(widget.postId);

    if (context.mounted) {
      setState(() {
        isFavorite = value;
      });
    }
  }

  @override
  void didUpdateWidget(covariant SocialPost oldWidget) {
    fetchIsFavorite();
    super.didUpdateWidget(oldWidget);
  }

  void _onInteractionStart(ScaleStartDetails details) {
    if (_controllerReset.status == AnimationStatus.forward) {
      _animateResetStop();
    }
  }

  void _onInteractionEnd(ScaleEndDetails details) {
    _animateResetInitialize();
  }

  void _animateResetInitialize() {
    _controllerReset.reset();
    _animationReset = Matrix4Tween(
      begin: _transformationController.value,
      end: Matrix4.identity(),
    ).animate(
      CurvedAnimation(
        parent: _controllerReset,
        curve: Curves.easeOut,
      ),
    );
    _controllerReset.forward();
    _animationReset!.addListener(_onAnimateReset);
  }

  void _onAnimateReset() {
    if (_controllerReset.isAnimating) {
      _transformationController.value = _animationReset!.value;
    }
  }

  void _animateResetStop() {
    _controllerReset.stop();
    _animationReset?.removeListener(_onAnimateReset);
    _animationReset = null;
    _controllerReset.reset();
  }

  @override
  void dispose() {
    _controllerReset.dispose();
    _transformationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String postHeaderFooter = widget.timestamp;

    return AnimatedOpacity(
      opacity: opacity,
      duration: const Duration(milliseconds: 300),
      child: GestureDetector(
        onTap: () {
          if (!widget.closedPosts) {
            String userId = FirebaseAuth.instance.currentUser!.uid;
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => RedirectedPost(
                  postId: widget.postId,
                  currentUserPost: widget.userId == userId,
                  donorId: widget.userId,
                  parrentWidget: widget.parrentWidget,
                ),
              ),
            );
          }
        },
        child: CardWidget(
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: PostHeader(
                      name: widget.name,
                      footer: postHeaderFooter,
                      profileImageUrl: widget.profileImageUrl,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                child: Text(
                  widget.text,
                  style: const TextStyle(
                    color: Color(0xFF555555),
                    fontSize: 14,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              AspectRatio(
                aspectRatio: 1 / 1,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: InteractiveViewer(
                    transformationController: _transformationController,
                    boundaryMargin: const EdgeInsets.all(20.0),
                    minScale: 1,
                    maxScale: 1.5,
                    constrained: true,
                    onInteractionStart: _onInteractionStart,
                    onInteractionEnd: _onInteractionEnd,
                    child: BlurhashFfi(
                      key: ValueKey(widget.imageUrl),
                      hash: widget.mediaPlaceholder,
                      image: widget.imageUrl,
                      imageFit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 5),
              PostFooter(
                fullLocation: widget.fullLocation,
                isFavorite: isFavorite,
                favFunction: () async {
                  setState(() {
                    isFavorite = !isFavorite;
                  });

                  await DatabaseHandler.addFavorite(widget.postId, !isFavorite);
                },
                sharePostFunction: () async {
                  try {
                    XFile? xFile;
                    var response = await http.get(Uri.parse(widget.imageUrl));

                    final bytes = response.bodyBytes;
                    final tempDir = await getTemporaryDirectory();
                    final file = File('${tempDir.path}/image.jpg');
                    await file.writeAsBytes(bytes);

                    xFile = XFile(file.path);
                    await Share.shareXFiles([xFile], text: "${widget.name} posted '${widget.text}'");
                  } catch (e) {
                    debugPrint('Error sharing the post: $e');
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
