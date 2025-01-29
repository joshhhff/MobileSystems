import 'package:flutter/material.dart';
import 'package:flutter_app/Scaffolds/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main () async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    // firebase database
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  runApp(const MyApp());
  } catch (e) {
    print(e);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color.fromARGB(255, 15, 15, 15),
      ),
      home: const Login(),
    );
  }
}