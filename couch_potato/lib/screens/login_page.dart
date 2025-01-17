import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInScreen extends StatefulWidget {
  const GoogleSignInScreen({Key? key}) : super(key: key);

  @override
  State<GoogleSignInScreen> createState() => _GoogleSignInScreenState();
}

class _GoogleSignInScreenState extends State<GoogleSignInScreen> {
  ValueNotifier userCredential = ValueNotifier('');

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkIfLoggedIn();
    });
  }

  void checkIfLoggedIn() {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      Navigator.pushReplacementNamed(context, '/home', arguments: currentUser);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: null,
      body: ValueListenableBuilder(
        valueListenable: userCredential,
        builder: (context, value, child) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Card(
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: ElevatedButton(
                  onPressed: () async {
                    userCredential.value = await signInWithGoogle();
                    if (userCredential.value != null) {
                      debugPrint(userCredential.value.user!.email);
                      debugPrint('Current User: ${FirebaseAuth.instance.currentUser}');
                      if (mounted) {
                        Navigator.pushNamed(context, '/home', arguments: {FirebaseAuth.instance.currentUser});
                      }
                    }
                  },
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/google_icon.png',
                      ),
                      const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          'Sign in with google',
                          style: TextStyle(fontSize: 20.0),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

Future<dynamic> signInWithGoogle() async {
  try {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    return await FirebaseAuth.instance.signInWithCredential(credential);
  } on Exception catch (e) {
    // TODO
    debugPrint('exception->$e');
  }
}

Future<bool> signOutFromGoogle() async {
  try {
    await FirebaseAuth.instance.signOut();
    return true;
  } on Exception catch (_) {
    return false;
  }
}
