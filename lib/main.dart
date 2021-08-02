import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_attendance/Screen/qr_scanner_screen.dart';
import 'package:qr_attendance/Screen/start_screen.dart';

import 'Provider/member.dart';
import 'Screen/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: Domain()),
      ],
      child: MaterialApp(
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
      ),
    );
  }
}
