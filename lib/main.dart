import 'package:flutter/material.dart';
import 'package:mis_lab_4/screens/splash_screen.dart';
import 'package:mis_lab_4/services/notification_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'package:mis_lab_4/providers/exams_provider.dart';
import 'package:mis_lab_4/providers/authentication_provider.dart';
import 'package:mis_lab_4/screens/authentication_screen.dart';
import 'package:mis_lab_4/screens/exams_screen.dart';
import 'package:mis_lab_4/screens/calendar_screen.dart';

/// ### Laboratory Exercise 4 ###
/// Author: Marko Spasenovski
/// Index number: 191128
/// Subject: Mobile Informatic Systems
/// Mentor: Petre Lameski pHd.

void main() async {
  await dotenv.load();
  WidgetsFlutterBinding.ensureInitialized();
  await Permission.notification.isDenied.then((value) {
    if (value) {
      Permission.notification.request();
    }
  });
  await NotificationService().init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
        ChangeNotifierProxyProvider<Auth, ExamsProvider>(
          create: (_) => ExamsProvider(),
          update: (ctx, auth, previousExams) => ExamsProvider(
            auth.token,
            auth.userId,
            previousExams == null ? [] : previousExams.exams,
          ),
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
              ? const CalendarScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, authResultSnapshot) =>
                      authResultSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? const SplashScreen()
                          : const AuthenticationScreen(),
                ),
          routes: {
            ExamsScreen.routeName: (ctx) => const ExamsScreen(),
            CalendarScreen.routeName: (ctx) => const CalendarScreen(),
            AuthenticationScreen.routeName: (ctx) =>
                const AuthenticationScreen()
          },
        ),
      ),
    );
  }
}
