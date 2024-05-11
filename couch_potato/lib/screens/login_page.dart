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
                    }
                    if (mounted) {
                      Navigator.pushNamed(context, '/home');
                    }
                  },
                  child: Row(
                    children: [
                      IconButton(
                        iconSize: 40,
                        icon: Image.asset(
                          'assets/google_icon.png',
                        ),
                        onPressed: () async {
                          userCredential.value = await signInWithGoogle();
                          if (userCredential.value != null) {
                            debugPrint(userCredential.value.user!.email);
                          }
                        },
                      ),
                      const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          'Sign in with google',
                          style: TextStyle(fontSize: 20.0),
                        ),
                      )
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
  /* try { */
  GoogleSignInAccount? googleUser;

  while (googleUser == null) {
    googleUser = await GoogleSignIn(
            scopes: ['email', 'profile', 'openid'],
            serverClientId: '558481956553-717gvml0ql1ats1564u6m4rs7s9bu7ss.apps.googleusercontent.com')
        .signIn();
  }

  GoogleSignInAuthentication? googleAuth;

  while (googleAuth == null) {
    googleAuth = await googleUser.authentication;
  }

  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  );

  return await FirebaseAuth.instance.signInWithCredential(credential);
  /* } catch (e) {
    // TODO
    debugPrint('exception->$e');
  } */
}

Future<bool> signOutFromGoogle() async {
  try {
    await FirebaseAuth.instance.signOut();
    return true;
  } on Exception catch (_) {
    return false;
  }
}