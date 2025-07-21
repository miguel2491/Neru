import 'package:flutter/material.dart';
import 'package:neru/screens/login/check_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp()); // Eliminada la inicialización de Firebase
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // @override
  // void initState() {
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NERU',
      debugShowCheckedModeBanner: true,
      theme: ThemeData(
        primaryColor: Color(0xFF494859),
        fontFamily: 'Monserrat',
      ),
      home: CheckAuthScreen(),
    );
  }
}
