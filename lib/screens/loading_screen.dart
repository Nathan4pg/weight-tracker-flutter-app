import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weight_tracker/providers/user_provider.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with WidgetsBindingObserver {
  bool shouldNavigateToSignIn = false;
  bool shouldNavigateToWeightTracker = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    checkCurrentUser();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      Future.microtask(() => checkCurrentUser());
    }
  }

  // this method checks to see if the current user in firebase auth is still
  // authenticated via reload(). If they are still authenticated then provider
  // is updated with the currentUser, firebaseauth instance is updated with
  // currentUser, and the user is navigated to the auth'd area (/weight-tracker)
  // if currentUser is null or an error occurs then user is directed to
  // '/sign-in'
  void checkCurrentUser() async {
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return setState(() {
        shouldNavigateToSignIn = true;
      });
    }

    try {
      await currentUser.reload();
      currentUser = FirebaseAuth.instance.currentUser;

      if (!mounted) return;

      if (currentUser == null) {
        return setState(() {
          shouldNavigateToSignIn = true;
        });
      }

      final userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.updateUser(currentUser);

      return setState(() {
        shouldNavigateToWeightTracker = true;
      });
    } catch (e) {
      setState(() {
        shouldNavigateToSignIn = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (shouldNavigateToSignIn) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, '/sign-in');
      });
    }

    if (shouldNavigateToWeightTracker) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, '/weight-tracker');
      });
    }

    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
