import 'package:dynamic_color/dynamic_color.dart';
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
  static final _defaultLightColorScheme =
      ColorScheme.fromSeed(seedColor: Colors.blue);
  static final _defaultDarkColorScheme = ColorScheme.fromSeed(
      seedColor: Colors.blue, brightness: Brightness.dark);
  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(builder: (lightColorScheme, darkColorScheme) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'SSMA',
        darkTheme: ThemeData(
          colorScheme: darkColorScheme ?? _defaultDarkColorScheme,
          useMaterial3: true,
        ),
        theme: ThemeData(
            colorScheme: lightColorScheme ?? _defaultLightColorScheme,
            useMaterial3: true),
        home: SafeArea(
          child: Scaffold(
            body: Center(
                child: StreamBuilder(
                    stream: pb.authStore.onChange,
                    builder: (context, snapshot) {
                      if (pb.authStore.isValid) {
                        return const HomePage();
                      } 
                    else {
                        return const RegisterLoginToggle();
                      }
                    })),
          ),
        ),
      );
    });
  }
}
