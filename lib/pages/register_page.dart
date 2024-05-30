import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_media_app/components/text_field.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPage();
}

class _RegisterPage extends State<RegisterPage> {
  //Text editing controller
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  final confirmPsswordTextController = TextEditingController();

  void signUp() async {
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(
          color: Colors.blue,
        ),
      ),
    );

    if (passwordTextController.text != confirmPsswordTextController.text) {
      Navigator.pop(context);
      displayMessage('Passwords do not match!');
      return;
    }

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailTextController.text,
        password: passwordTextController.text,
      );
      if (context.mounted) Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      displayMessage(e.code);
    }
  }

  void displayMessage(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //Logo
                const Icon(
                  Icons.lock,
                  size: 100,
                ),
                const SizedBox(
                  height: 50,
                ),
                //Welcome Back Message
                Text(
                  'Lets Create an account for you',
                  style: TextStyle(color: Colors.grey[700]),
                ),

                const SizedBox(
                  height: 25,
                ),
                //Email textField
                MyTextField(
                  controller: emailTextController,
                  obscureText: false,
                  hintText: 'Email',
                ),
                const SizedBox(
                  height: 10,
                ),
                //Password TextField
                MyTextField(
                  controller: passwordTextController,
                  obscureText: true,
                  hintText: 'Password',
                ),
                const SizedBox(
                  height: 10,
                ),
                MyTextField(
                  controller: confirmPsswordTextController,
                  obscureText: true,
                  hintText: 'Confirm Password',
                ),
                const SizedBox(
                  height: 10,
                ),
                const SizedBox(
                  height: 25,
                ),
                //Sign in button
                TextButton(
                  onPressed: signUp,
                  child: Container(
                    padding: const EdgeInsets.all(23),
                    margin: const EdgeInsets.only(left: 13, right: 13),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(
                      child: Text(
                        'Sign Up',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                //Go to register page
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account?',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(width: 5),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        'Login now',
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
