import 'dart:io';
import 'package:blurhash_ffi/blurhashffi_widget.dart';
import 'package:couch_potato/classes/post.dart';
import 'package:couch_potato/network/database_handler.dart';
import 'package:couch_potato/network/post/post_footer.dart';
import 'package:couch_potato/network/post/post_header.dart';
import 'package:couch_potato/network/redirected_post/logistics_options.dart';
import 'package:couch_potato/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:couch_potato/modules/app_bar.dart';
import 'package:http/http.dart' as http;
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RedirectedPost extends StatefulWidget {
  final String postId;
  const RedirectedPost({
    super.key,
    required this.postId,
  });

  @override
  State<RedirectedPost> createState() => _RedirectedPostState();
}

class _RedirectedPostState extends State<RedirectedPost> {
  bool _isLoading = true;
  double opacity = 0.0;

  bool isFavorite = false;
  Post? post;
  Logistics _logistics = Logistics.user;

  @override
  void initState() {
    fetchIsFavorite();
    fetchPost();
    super.initState();
    Future.delayed(const Duration(milliseconds: 100), () {
      setState(() {
        opacity = 1.0;
      });
    });
  }

  Future<void> fetchPost() async {
    Post fetchedPost = await DatabaseHandler.getSinglePost(widget.postId);
    if (mounted) {
      setState(() {
        post = fetchedPost;
        _isLoading = false;
      });
    }
  }

  Future<void> fetchIsFavorite() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favorites =  prefs.getStringList('favorites') ?? [];

    bool value = favorites.contains(widget.postId);

    if (context.mounted) {
      setState(() {
        isFavorite = value;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(title: 'Post', showBackButton: true),
      body: _isLoading || post == null
          ? Center(
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.7,
                child: LoadingAnimationWidget.waveDots(
                  color: Colors.grey.shade200,
                  size: 100,
                ),
              ),
            )
          : AnimatedOpacity(
              opacity: opacity,
              duration: const Duration(milliseconds: 300),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 27, vertical: 15),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: PostHeader(
                                  name: post!.username,
                                  footer: '${timeDelta(post!.createdAt)} - $location',
                                  profileImageUrl: post!.profileImageUrl,
                                ),
                              ),
                            ],
                          ),
                          if (post!.description.isNotEmpty) const SizedBox(height: 15),
                          if (post!.description.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 0),
                              child: Text(
                                post!.description,
                                style: const TextStyle(
                                  color: Color(0xFF555555),
                                  fontSize: 14,
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          post!.mediaUrl.isNotEmpty ? const SizedBox(height: 20) : const SizedBox(height: 10),
                          if (post!.mediaUrl.isNotEmpty && post!.mediaPlaceholder.isNotEmpty)
                            AspectRatio(
                              aspectRatio: 1 / 1,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: BlurhashFfi(
                                  key: ValueKey(post!.mediaUrl),
                                  hash: post!.mediaPlaceholder,
                                  image: post!.mediaUrl,
                                  imageFit: BoxFit.cover,
                                ),
                              ),
                            ),
                          if (post!.mediaUrl.isNotEmpty) const SizedBox(height: 15),
                          PostFooter(
                            fullLocation: post!.fullLocation,
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
                                var response = await http.get(Uri.parse(post!.mediaUrl));

                                final bytes = response.bodyBytes;
                                final tempDir = await getTemporaryDirectory();
                                final file = File('${tempDir.path}/image.jpg');
                                await file.writeAsBytes(bytes);

                                xFile = XFile(file.path);
                                await Share.shareXFiles([xFile],
                                    text: "${post!.username} posted '${post!.description}'");
                              } catch (e) {
                                debugPrint('Error sharing the post: $e');
                              }
                            },
                          ),
                          const SizedBox(height: 15),
                          SizedBox(
                            height: 100,
                            child: Transform.translate(
                              offset: const Offset(-10, 0),
                              child: LogisticsOptions(radioCallback: (Logistics value) {
                                setState(() {
                                  _logistics = value;
                                });
                              }),
                            ),
                          ),
                          const SizedBox(height: 86),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    child: Container(
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
                          //TODO: Acquire item functions
                        },
                        child: const Text(
                          'Acquire',
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
                  ),
                ],
              ),
            ),
    );
  }
}
