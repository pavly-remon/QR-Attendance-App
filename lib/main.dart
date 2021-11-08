import 'package:flutter/material.dart';
import 'package:qr_attendance/Screen/qr_scanner_screen.dart';
import 'package:qr_attendance/Screen/start_screen.dart';
import 'package:qr_attendance/models/members_repo.dart';
import 'Screen/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Widget build(BuildContext context) {
    MemberRepository();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(),
      routes: {
        QRScreen.routeName: (ctx) => QRScreen(),
        StartScreen.routeName: (ctx) => StartScreen(),
      },
    );
  }
}
