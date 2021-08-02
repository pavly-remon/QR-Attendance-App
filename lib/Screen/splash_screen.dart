import 'dart:async';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_attendance/Provider/googlesheets.dart';
import 'package:qr_attendance/Screen/start_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation _animation;
  final Connectivity _connectivity = Connectivity();
  bool _isConnected = true;

  @override
  void initState() {
    _checkConnection();
    UserSheetsApi.init();
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 2));
    _animationController.repeat(reverse: true);
    _animation = Tween(begin: 1.0, end: 20.0).animate(_animationController)
      ..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: !_isConnected
          ? AlertDialog(
              title: Text('No Connection'),
              content: Text(
                  'Check your Internet connection before starting this application.'),
              actions: [
                TextButton(
                  onPressed: () {
                    SystemNavigator.pop();
                  },
                  child: Text('Ok'),
                ),
              ],
            )
          : Center(
              child: Container(
                width: size.width * 0.6,
                height: size.width * 0.6,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 15, 10, 5),
                  child: Image.asset(
                    'assets/images/Splash.png',
                  ),
                ),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.yellowAccent,
                          blurRadius: _animation.value,
                          spreadRadius: _animation.value)
                    ]),
              ),
            ),
    );
  }

  Future<void> _checkConnection() async {
    ConnectivityResult result = ConnectivityResult.none;
    try {
      result = await _connectivity.checkConnectivity();
      if (result != ConnectivityResult.none) {
        setState(() {
          _isConnected = true;
          Timer(Duration(seconds: 5), () {
            _animationController.dispose();
            Navigator.of(context).pushReplacementNamed(StartScreen.routeName);
          });
        });
        print('connected');
      } else {
        setState(() {
          _isConnected = false;
        });
      }
    } on PlatformException catch (_) {
      setState(() {
        _isConnected = false;
      });
    }
  }
}
