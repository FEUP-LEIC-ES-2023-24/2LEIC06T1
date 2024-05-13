import 'package:blurhash_ffi/blurhashffi_widget.dart';
import 'package:couch_potato/classes/post.dart';
import 'package:couch_potato/modules/app_bar.dart';
import 'package:couch_potato/modules/page_fault_screen.dart';
import 'package:couch_potato/network/database_handler.dart';
import 'package:couch_potato/network/post/social_post.dart';
import 'package:couch_potato/network/redirected_post/redirected_post.dart';
import 'package:couch_potato/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class AcquiredItems extends StatefulWidget {
  const AcquiredItems({super.key});

  @override
  AcquiredItemsState createState() => AcquiredItemsState();
}

class AcquiredItemsState extends State<AcquiredItems> with TickerProviderStateMixin {
  List<Post> posts = [];

  late ScrollController scrollController;

  late AnimationController _animationController;

  bool hasConnection = true;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );

    setHasConnection();

    scrollController = ScrollController();
    setUpScrollController(scrollController);

    fetchPosts();
  }

  void setUpScrollController(ScrollController controller) {
    controller.addListener(() {
      if (controller.position.userScrollDirection == ScrollDirection.forward) {
        _animationController.reverse();
      } else if (controller.position.userScrollDirection == ScrollDirection.reverse) {
        _animationController.forward();
      }
    });
  }

  void setHasConnection() async {
    bool connection = await hasInternetConnection();
    setState(() {
      hasConnection = connection;
    });
  }

  Future<void> fetchPosts() async {
    List<Post> newPosts = await DatabaseHandler.fetchUserPosts(true);

    setState(() {
      posts = newPosts;
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(
        title: 'Acquired Items',
        showBackButton: true,
      ),
      resizeToAvoidBottomInset: false,
      body: RefreshIndicator(
        color: appColor,
        onRefresh: () async {
          try {
            setState(() {
              _isLoading = true;
            });

            await DatabaseHandler.fetchAndSaveFavorites();

            await Future.wait([fetchPosts()]).timeout(const Duration(seconds: 5));
            setState(() {
              _isLoading = false;
              hasConnection = true;
            });
          } catch (e) {
            setState(() {
              hasConnection = false;
            });
            return;
          }
          debugPrint('refreshed');
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          controller: scrollController,
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: !hasConnection
                ? const PageFaultScreen(
                    imagePath: 'assets/no_connection.png',
                    title: 'No connection',
                    description: "Please check your internet connection and refresh the page",
                  )
                : _isLoading
                    ? Center(
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.7,
                          child: LoadingAnimationWidget.waveDots(
                            color: Colors.grey.shade200,
                            size: 100,
                          ),
                        ),
                      )
                    : posts.isEmpty
                        ? const PageFaultScreen(
                            imagePath: 'assets/no_posts_image.png',
                            title: 'No Posts',
                            description: 'Seems like there are currently no potatoes',
                          )
                        : buildPostList(posts),
          ),
        ),
      ),
    );
  }

  ListView buildPostList(List<Post> posts) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: posts.length,
      itemBuilder: (context, index) {
        Post post = posts[index];

        TextStyle textStyle = const TextStyle(
          color: Color(0xFF555555),
          fontSize: 14,
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w500,
        );

        Widget postWidget = Card(
          child: GestureDetector(
            onTap: () {
              String userId = FirebaseAuth.instance.currentUser!.uid;
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => RedirectedPost(
                    postId: post.postId,
                    currentUserPost: post.userId == userId,
                    donorId: post.userId,
                    acquiredItem: true,
                  ),
                ),
              );
            },
            child: ListTile(
              backgroundColor: Colors.transparent,
              leading: SizedBox(
                height: 72,
                width: 72,
                child: BlurhashFfi(
                  key: ValueKey(post.mediaUrl),
                  hash: post.mediaPlaceholder,
                  image: post.mediaUrl,
                  imageFit: BoxFit.cover,
                ),
              ),
              title: Text(post.category, style: textStyle.copyWith(fontWeight: FontWeight.bold, fontSize: 16)),
              subtitle: Text(post.description, style: textStyle),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                size: 23,
                color: Color(0xFF777777),
              ),
            ),
          ),
        );

        return postWidget;
      },
    );
  }
}
