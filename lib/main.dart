import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:steamplayground/common/my_custom_scroll_behavior.dart';
import 'package:steamplayground/main_page.dart';

void main() async {
  await dotenv.load(fileName: 'assets/.env');
  final String apiKey = dotenv.env['API_KEY']!;
  runApp(MyApp(apiKey: apiKey,));
}

class MyApp extends StatelessWidget {
  final String apiKey;
  const MyApp({super.key, required this.apiKey});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Steam Playground',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
        useMaterial3: true,
      ),
      home: MainPage(apiKey: apiKey),
      scrollBehavior: MyCustomScrollBehavior(),
    );
  }
}