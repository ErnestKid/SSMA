import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ssma_app/homepage.dart';
import 'package:ssma_app/pb.dart';
import 'package:ssma_app/signuplogin.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          body: Center(
              child: StreamBuilder(
                  stream: pb.authStore.onChange,
                  builder: (context, snapshot) {
                    debugPrint(snapshot.data.toString());
                    if (pb.authStore.isValid) {
                      debugPrint('Data: ${snapshot.data}');
                      return const HomePage();
                    } else {
                      debugPrint('Data: ${snapshot.data}');
                      debugPrint('No data');
                      return const RegisterLoginToggle();
                    }
                  })),
        ),
      ),
    );
  }
}
