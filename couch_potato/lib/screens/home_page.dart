import 'package:couch_potato/classes/post.dart';
import 'package:couch_potato/modules/page_fault_screen.dart';
import 'package:couch_potato/network/datatbase_handler.dart';
import 'package:couch_potato/network/social_post.dart';
import 'package:couch_potato/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> with TickerProviderStateMixin {
  List<Post> posts = [];

  late ScrollController scrollController;

  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;
  late Animation<double> _translateAnimation;

  bool hasConnection = true;
  bool _isLoading = true;
  bool _isFetchingMorePosts = false;
  bool _noMorePosts = false;

  int offset = 0;
  int numberOfPosts = 5;

  static const TextStyle tabTextStyle = TextStyle(
    fontFamily: "Montserrat",
    fontWeight: FontWeight.w500,
    fontSize: 15,
  );

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );

    setHasConnection();

    _opacityAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(_animationController);
    _translateAnimation = Tween<double>(begin: 0.0, end: 20.0).animate(_animationController);
    scrollController = ScrollController();
    setUpScrollController(scrollController);

    fetchPosts();
  }

  void _scrollListener() {
    if (_isFetchingMorePosts || _noMorePosts) return;
    if (scrollController.position.pixels + 50 >= scrollController.position.maxScrollExtent) {
      fetchPosts();
    }
  }

  void setUpScrollController(ScrollController controller) {
    controller.addListener(() {
      if (controller.position.userScrollDirection == ScrollDirection.forward) {
        _animationController.reverse();
      } else if (controller.position.userScrollDirection == ScrollDirection.reverse) {
        _animationController.forward();
      }
    });
    scrollController.addListener(_scrollListener);
  }

  void setHasConnection() async {
    bool connection = await hasInternetConnection();
    setState(() {
      hasConnection = connection;
    });
  }

  Future<void> fetchPosts() async {
    setState(() {
      _isLoading = true;
    });
    List<Post> newPosts = await DatabaseHandler.getPosts(1);
    setState(() {
      posts = newPosts;
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    scrollController.removeListener(_scrollListener);
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Opacity(
              opacity: _opacityAnimation.value,
              child: Transform.translate(
                offset: Offset(0, _translateAnimation.value),
                child: Transform.scale(
                  scale: 0.9,
                  child: FloatingActionButton(
                    onPressed: () async {
                      /* if (await hasInternetConnection() && mounted) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CreatePostPage(),
                            ),
                          );
                        } */
                      HapticFeedback.selectionClick();
                    },
                    foregroundColor: Colors.white,
                    backgroundColor: appColor,
                    shape: const CircleBorder(),
                    child: const Icon(Icons.add, size: 35),
                  ),
                ),
              ),
            );
          }),
      resizeToAvoidBottomInset: false,
      body: RefreshIndicator(
        color: appColor,
        onRefresh: () async {
          try {
            setState(() {
              _isLoading = true;
              offset = 0;
              _noMorePosts = false;
            });

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
                        : Column(
                            children: [
                              buildPostList(posts),
                              _isFetchingMorePosts
                                  ? SizedBox(
                                      height: 60,
                                      child: LoadingAnimationWidget.waveDots(
                                        color: Colors.grey.shade200,
                                        size: 70,
                                      ),
                                    )
                                  : _noMorePosts
                                      ? const SizedBox(
                                          height: 60,
                                          child: Center(
                                            child: Text(
                                              "There are no more posts available",
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.normal,
                                                color: Color(0xFF858B92),
                                                fontFamily: 'Montserrat',
                                              ),
                                            ),
                                          ),
                                        )
                                      : const SizedBox(
                                          height: 60,
                                        )
                            ],
                          ),
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
          ),
        );

        return postWidget;
      },
    );
  }
}
