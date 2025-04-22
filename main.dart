import 'package:flutter/material.dart';
import 'firstpage.dart';
import 'sign.dart';
import 'animals.dart';
import 'new.dart';
import 'navbarpage.dart';
import 'dash.dart';
import 'not.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initNotifications(); 
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Swine_Health',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: PigsPage(),
    );
  }
}
