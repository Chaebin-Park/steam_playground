import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:steamplayground/common/my_custom_scroll_behavior.dart';
import 'package:steamplayground/main_page.dart';

void main() async {
  await dotenv.load();
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    print("START_____________");
    return MaterialApp(
      title: 'Steam Playground',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
        useMaterial3: true,
      ),
      home: MainPage(),
      scrollBehavior: MyCustomScrollBehavior(),
    );
  }
}