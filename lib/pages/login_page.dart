import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mitch/auth/auth_provider.dart';
import 'package:firebase_auth_mitch/components/square_tile.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback showSignUpPage;
  const LoginPage({super.key, required this.showSignUpPage});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // text controller
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future signIn() async {
    //loading indicator
    showDialog(
        context: context,
        builder: (context) {
          return const Center(child: CircularProgressIndicator());
        });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      //remove indicator
      Navigator.of(context).pop();
    } on FirebaseAuthException catch (e) {
      //remove indicator
      Navigator.of(context).pop();
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(e.message.toString()),
            );
          });
    }
  }

// memory management
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.lock,
                  size: 82,
                ),
                const SizedBox(height: 42),

                // // welcome text
                // Text(
                //   "Hello Again!",
                //   style: GoogleFonts.bebasNeue(fontSize: 54),
                // ),
                // const SizedBox(height: 10),

                const Text(
                  "Welcome back, you've been missed",
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 20),

                // email field
                _emailTextField(),
                const SizedBox(height: 10),

                // password field
                _emailTextFieldLoginPage(),
                const SizedBox(height: 8),

                // forgot password link
                _forgotPasswordLinkLoginPage(context),
                const SizedBox(height: 20),

                // sign in button
                _signInButtonLoginPage(),
                const SizedBox(height: 40),

                // or continue with
                _orContinueWith(),
                const SizedBox(height: 40),

                // google apple login
                _authProviderTilesSignIn(),
                const SizedBox(height: 40),

                // register button
                _registerButtonLoginPage()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row _authProviderTilesSignIn() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SquareTile(
            onTap: () => AuthProvider().googleLogin(),
            imagePath: 'lib/images/google.png'),
        const SizedBox(
          width: 20,
        ),
        SquareTile(onTap: () {}, imagePath: 'lib/images/apple.png'),
      ],
    );
  }

  Padding _orContinueWith() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Row(
        children: [
          Expanded(
            child: Divider(
              thickness: 0.5,
              color: Colors.grey[400],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Text(
              'Or Continue With',
              style: TextStyle(color: Colors.grey[400]),
            ),
          ),
          Expanded(
            child: Divider(
              thickness: 0.5,
              color: Colors.grey[400],
            ),
          ),
        ],
      ),
    );
  }

  Row _registerButtonLoginPage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'New User? ',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        GestureDetector(
          onTap: widget.showSignUpPage,
          child: Text(
            'Register now',
            style: TextStyle(
                color: Colors.blueAccent[400], fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }

  Padding _signInButtonLoginPage() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: GestureDetector(
        onTap: signIn,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
              color: Colors.black, borderRadius: BorderRadius.circular(12)),
          child: const Center(
            child: Text(
              'Sign In',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  Padding _forgotPasswordLinkLoginPage(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/forgotPassword');
            },
            child: Text(
              'Forgot Password?',
              style: TextStyle(
                  letterSpacing: 0.4,
                  fontSize: 12,
                  color: Colors.grey[500],
                  fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }

  Padding _emailTextFieldLoginPage() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: TextField(
        controller: _passwordController,
        obscureText: true,

        // styles
        decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.white),
              borderRadius: BorderRadius.circular(16),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.black),
              borderRadius: BorderRadius.circular(2),
            ),
            hintText: 'Password',
            fillColor: Colors.grey[200],
            filled: true),
      ),
    );
  }

  Padding _emailTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: TextField(
        controller: _emailController,

        // styles
        decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.white),
              borderRadius: BorderRadius.circular(16),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.black),
              borderRadius: BorderRadius.circular(2),
            ),
            hintText: 'Email',
            fillColor: Colors.grey[200],
            filled: true),
      ),
    );
  }
}
