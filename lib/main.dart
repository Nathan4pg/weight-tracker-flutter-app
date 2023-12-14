import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weight_tracker/screens/loading_screen.dart';
import 'package:weight_tracker/screens/logging_screen.dart';
import 'package:weight_tracker/screens/sign_in_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:weight_tracker/providers/user_provider.dart';
import 'package:weight_tracker/providers/weight_entry_provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => UserProvider()),
      ChangeNotifierProvider(create: (context) => WeightEntryProvider()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routes: {
        '/': (context) => const MyHomePage(title: 'Home'),
        '/sign-in': (context) => const SignInScreen(),
        '/weight-tracker': (context) => const LoggingScreen(),
      },
      initialRoute: '/',
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: const Center(
        child: LoadingScreen(),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
