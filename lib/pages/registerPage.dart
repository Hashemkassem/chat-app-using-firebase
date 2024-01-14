// ignore_for_file: use_build_context_synchronously, file_names

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:second_fire_app/components/imagebotton.dart';

import '../components/my_botton.dart';
import '../components/my_txt_field.dart';
import '../services/auth/auth_services.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;
  const RegisterPage({super.key, this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailcontroller = TextEditingController();

  final passwordcontroller = TextEditingController();

  final confirmpasswordcontroller = TextEditingController();

  void signUp() async {
    if (passwordcontroller.text != confirmpasswordcontroller.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'password do not match',
          ),
        ),
      );
      Navigator.pop(context);
      return;
    }
    final authservices = Provider.of<AuthServices>(context, listen: false);
    try {
      await authservices.SignUpWithEmailAndPassword(
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

  void wrongMessage(String text) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.black.withOpacity(0.8),
            title: Center(
                child: Text(
              text,
              style: const TextStyle(color: Color(0xFF630436)),
            )),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  'Let\'s create an account for you!',
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
                MyTextField(
                    hinttext: 'Confirm Password',
                    obscureText: true,
                    controller: confirmpasswordcontroller),
                const SizedBox(
                  height: 25,
                ),
                MyBotton(onTap: signUp, text: 'Sign Up'),
                const SizedBox(
                  height: 25,
                ),
                const Row(
                  children: [
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      'or continue with',
                      style: TextStyle(color: Color(0xFF630436)),
                    ),
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.black,
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
                    const ImageBotton(
                      imagePath: 'images/2.png',
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
                    const Text('Already a member?'),
                    const SizedBox(
                      width: 5,
                    ),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        'Login Now',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF630436)),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 25,
                ),
              ],
            ),
          ),
        ),
      )),
    );
  }
}
