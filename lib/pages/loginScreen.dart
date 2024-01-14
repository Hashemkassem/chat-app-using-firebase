// ignore_for_file: file_names, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:second_fire_app/components/my_botton.dart';
import 'package:second_fire_app/components/my_txt_field.dart';
import 'package:second_fire_app/services/auth/auth_services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../components/imagebotton.dart';

class LoginPage extends StatefulWidget {
  final void Function()? onTap;
  const LoginPage({super.key, this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailcontroller = TextEditingController();

  final passwordcontroller = TextEditingController();

  void signIn() async {
    showDialog(
        // jaajak
        context: context,
        builder: (context) {
          return const Center(child: CircularProgressIndicator());
        });

    //   try {
    //     await FirebaseAuth.instance.signInWithEmailAndPassword(
    //         email: emailcontroller.text, password: passwordcontroller.text);
    //   } on FirebaseAuthException catch (e) {
    //     if (e.code == 'user-not-found') {
    //       wrongMessage('incorrect email');
    //     } else if (e.code == 'wrong-password') {
    //       wrongMessage('incorrect password');
    //     }
    //     Navigator.pop(context);
    //     wrongMessage(e.code);
    //   }
    // }

    // void wrongMessage(String text) {
    //   showDialog(
    //       context: context,
    //       builder: (context) {
    //         return AlertDialog(
    //           backgroundColor: Colors.black.withOpacity(0.8),
    //           title: Center(
    //               child: Text(
    //             text,
    //             style: const TextStyle(color: Colors.white),
    //           )),
    //         );
    //       });
    final authservices = Provider.of<AuthServices>(context, listen: false);
    try {
      await authservices.signinwithEmailandPassword(
          emailcontroller.text, passwordcontroller.text);
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );
      Navigator.pop(context);
    }
  }

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
          child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 50,
                ),
                const Icon(
                  Icons.message_rounded,
                  size: 80,
                  color: Color(0xFF630436),
                ),
                const SizedBox(
                  height: 50,
                ),
                const Text(
                  'Welcome Back you\'ve been missed!',
                  style: TextStyle(fontSize: 16, color: Color(0xFF630436)),
                ),
                const SizedBox(
                  height: 50,
                ),
                MyTextField(
                    hinttext: 'Email',
                    obscureText: false,
                    controller: emailcontroller),
                const SizedBox(
                  height: 10,
                ),
                MyTextField(
                    hinttext: 'Password',
                    obscureText: true,
                    controller: passwordcontroller),
                const SizedBox(
                  height: 10,
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'forgetten Password?',
                      style: TextStyle(color: Color(0xFF630436)),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                MyBotton(onTap: signIn, text: 'Sign In'),
                const SizedBox(
                  height: 25,
                ),
                const Row(
                  children: [
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      'or continue with',
                      style: TextStyle(color: Color(0xFF630436)),
                    ),
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.grey,
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 25,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        signInWithGoogle();
                      },
                      child: const ImageBotton(
                        imagePath: 'images/2.png',
                      ),
                    ),
                    SizedBox(width: MediaQuery.of(context).size.height * 0.08),
                    const ImageBotton(
                      imagePath: 'images/1.png',
                    )
                  ],
                ),
                const SizedBox(
                  height: 25,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Not a member?'),
                    const SizedBox(
                      width: 5,
                    ),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        'Register Now',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF630436)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      )),
    );
  }
}
