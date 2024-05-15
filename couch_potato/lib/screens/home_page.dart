import 'package:couch_potato/classes/post.dart';
import 'package:couch_potato/modules/page_fault_screen.dart';
import 'package:couch_potato/network/create_post/create_post_page.dart';
import 'package:couch_potato/network/database_handler.dart';
import 'package:couch_potato/network/post/social_post.dart';
import 'package:couch_potato/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

final GlobalKey<HomePageState> homePageKey = GlobalKey<HomePageState>();

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

  String _category = 'Uncategorized';

  final List<String> categoryList = [
    'Uncategorized',
    'Furniture',
    'Electronics',
    'Clothing',
    'Books',
    'Other',
  ];

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
    List<Post> newPosts = await DatabaseHandler.getPosts();
    newPosts.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    setState(() {
      posts = newPosts;
      _isLoading = false;
    });
  }

  Future<void> fetchCategorizedPosts(String category) async {
    List<Post> newPosts = await DatabaseHandler.fetchCategorizedPosts(category);

    setState(() {
      posts = newPosts.reversed.toList();
      _isLoading = false;
    });
  }

  Future<void> refreshPage({String? category}) async {
    try {
      setState(() {
        _isLoading = true;
      });

      await DatabaseHandler.fetchAndSaveFavorites();

      if (category == null || category == 'Uncategorized') {
        await Future.wait([fetchPosts()]).timeout(const Duration(seconds: 5));
      } else if (category != 'Uncategorized') {
        await Future.wait([fetchCategorizedPosts(category)]).timeout(const Duration(seconds: 5));
      }

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
                      if (await hasInternetConnection() && mounted) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const CreatePostPage()),
                        );
                      }
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
          await refreshPage(category: _category);
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
                    : Column(
                        children: [
                          categorySearch(),
                          posts.isEmpty
                              ? const PageFaultScreen(
                                  imagePath: 'assets/no_posts_image.png',
                                  title: 'No Posts',
                                  description: 'Seems like there are currently no potatoes',
                                )
                              : buildPostList(posts),
                        ],
                      ),
          ),
        ),
      ),
    );
  }

  Widget categorySearch() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color(0xFFDFDFDF),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonFormField(
        padding: const EdgeInsets.only(right: 15),
        style: const TextStyle(
          color: Color(0xFF555555),
          fontSize: 14,
          fontWeight: FontWeight.w500,
          fontFamily: 'Montserrat',
        ),
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.search, color: appColor, size: 25),
          hintText: 'Category',
          hintStyle: const TextStyle(
            color: Color(0xFFBEBEBE),
            fontSize: 13,
            fontWeight: FontWeight.w500,
            fontFamily: 'Montserrat',
          ),
          border: InputBorder.none,
        ),
        iconEnabledColor: appColor,
        iconDisabledColor: appColor,
        value: _category,
        items: categoryList.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (value) async {
          setState(() {
            _category = value ?? 'Uncategorized';
          });
          await refreshPage(category: value);
        },
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
            parrentWidget: 'homePage',
          ),
        );

        return postWidget;
      },
    );
  }
}
