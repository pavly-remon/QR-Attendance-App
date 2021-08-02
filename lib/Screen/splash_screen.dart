import 'dart:async';

import 'package:flutter/material.dart';
import 'package:qr_attendance/Screen/start_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;

  late Animation _animation;

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 2));
    _animationController.repeat(reverse: true);
    _animation = Tween(begin: 1.0, end: 20.0).animate(_animationController)
      ..addListener(() {
        setState(() {});
      });
    Timer(Duration(seconds: 5), () {
      _animationController.dispose();
      Navigator.of(context).pushReplacementNamed(StartScreen.routeName);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Container(
          width: size.width * 0.6,
          height: size.width * 0.6,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 15, 10, 5),
            child: Image.asset(
              'assets/Splash.png',
            ),
          ),
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color.fromARGB(255, 27, 28, 30),
              boxShadow: [
                BoxShadow(
                    color: Color.fromARGB(130, 237, 125, 58),
                    blurRadius: _animation.value,
                    spreadRadius: _animation.value)
              ]),
        ),
      ),
    );
  }
}
