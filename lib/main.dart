import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_sticky_notes/hive_box.dart';
import 'package:hive_sticky_notes/home_screen.dart';


Future main() async {

  WidgetsFlutterBinding.ensureInitialized();


  await Hive.initFlutter();


  await Hive.openBox(userHiveBox);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
       home: HomeScreen()
       );
  }
}