import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wisy/firebase_options.dart';
import 'package:wisy/pages/camera/camera_page.dart';
import 'package:wisy/pages/home/home.dart';
import 'package:wisy/pages/wrapper.dart';
import 'package:wisy/shared/globals.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: snackbarKey,
      home: const Wrapper(),
      routes: {
        '/home': (context) => const Home(),
        '/camera': (context) => const CameraPage(),
      },
    );
  }
}
