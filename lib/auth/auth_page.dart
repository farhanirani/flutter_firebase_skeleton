import 'package:firebase_auth_mitch/pages/login_page.dart';
import 'package:firebase_auth_mitch/pages/signup_page.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  // initially show the login page
  bool showLoginPage = true;

  void toggleScreens() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return LoginPage(showSignUpPage: toggleScreens);
    } else {
      return SignUpPage(showLoginPage: toggleScreens);
    }
  }
}
