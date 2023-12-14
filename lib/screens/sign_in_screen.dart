import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weight_tracker/providers/user_provider.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  String errorMessage = '';
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    Future<void> signInAnonymously(context) async {
      setState(() {
        isLoading = true;
      });

      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.signInAnonymously();
        User? user = userCredential.user;
        if (user != null) {
          Navigator.pushReplacementNamed(context, '/weight-tracker');

          userProvider.updateUser(user);

          setState(() {
            isLoading = false;
            errorMessage = "";
          });
        }
      } catch (e) {
        if (kDebugMode) {
          print("Error signing in anonymously: $e");
        }
        setState(() {
          isLoading = false;
          errorMessage = "There was an error signing in.";
        });
      }
    }

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    child: const Text('Sign In'),
                    onPressed: () => signInAnonymously(context),
                  ),
          ),
        ],
      ),
    );
  }
}
