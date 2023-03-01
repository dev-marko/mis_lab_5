import 'package:flutter/material.dart';
import 'package:mis_lab_4/screens/authentication_screen.dart';
import 'package:mis_lab_4/screens/exams_screen.dart';
import 'package:provider/provider.dart';

import 'package:mis_lab_4/providers/authentication_provider.dart';

/// ### Laboratory Exercise 4 ###
/// Author: Marko Spasenovski
/// Index number: 191128
/// Subject: Mobile Informatic Systems
/// Mentor: Petre Lameski pHd.

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: '191128 Exams',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSwatch(
              primarySwatch: Colors.deepOrange,
              accentColor: Colors.black,
            ),
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.deepOrange,
              iconTheme: IconThemeData(
                color: Colors.black,
              ),
              actionsIconTheme: IconThemeData(
                color: Colors.black,
              ),
            ),
          ),
          home: auth.isAuthenticated
              ? const ExamsScreen()
              : const AuthenticationScreen(),
          routes: {
            ExamsScreen.routeName: (ctx) => const ExamsScreen(),
          },
        ),
      ),
    );
  }
}
