import 'package:flutter/material.dart';
import 'package:second_fire_app/pages/home_page.dart';
import 'package:second_fire_app/services/auth/login_or_register.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const HomePage();
          } else {
            return const LoginOrRegister();
          }
        },
        stream: null,
      ),
    );
  }
}
