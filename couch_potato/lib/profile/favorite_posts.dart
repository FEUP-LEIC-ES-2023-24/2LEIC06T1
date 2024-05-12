import 'package:couch_potato/classes/post.dart';
import 'package:couch_potato/modules/app_bar.dart';
import 'package:couch_potato/modules/page_fault_screen.dart';
import 'package:couch_potato/network/database_handler.dart';
import 'package:couch_potato/network/post/social_post.dart';
import 'package:couch_potato/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class FavoritePosts extends StatefulWidget {
  const FavoritePosts({super.key});

  @override
  FavoritePostsState createState() => FavoritePostsState();
}

class FavoritePostsState extends State<FavoritePosts> with TickerProviderStateMixin {
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
    List<Post> newPosts = await DatabaseHandler.fetchFavoritePosts();

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
        title: 'Favorites',
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

        Widget postWidget = Padding(
          padding: const EdgeInsets.symmetric(vertical: 7),
          child: SocialPost(
            key: ValueKey(post.postId),
            postId: post.postId,
            name: post.username,
            timestamp: timeDelta(post.createdAt),
            profileImageUrl: post.profileImageUrl,
            text: post.description,
            imageUrl: post.mediaUrl,
            mediaPlaceholder: post.mediaPlaceholder,
            fullLocation: post.fullLocation,
            category: post.category,
            userId: post.userId,
          ),
        );

        return postWidget;
      },
    );
  }
}
