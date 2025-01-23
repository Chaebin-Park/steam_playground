import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:steamplayground/common/my_custom_scroll_behavior.dart';
import 'package:steamplayground/db/indexdb_service.dart';
import 'package:steamplayground/firebase_options.dart';
import 'package:steamplayground/main_page.dart';

final playerDB = IndexedDBService<Map<String, dynamic>>(
  dbName: 'PlayerDB',
  storeName: 'players',
);

void main() async {
  // await dotenv.load();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Steam Playground',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
        useMaterial3: true,
      ),
      home: const MainPage(),
      scrollBehavior: MyCustomScrollBehavior(),
    );
  }
}