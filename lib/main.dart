import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:qr_attendance/Screen/qr_scanner_screen.dart';
import 'package:qr_attendance/Screen/start_screen.dart';
import 'package:qr_attendance/redux/reducer.dart';
import 'package:qr_attendance/redux/state.dart';
import 'Screen/splash_screen.dart';
import 'package:redux/redux.dart';

import 'models/googlesheets.dart';
import 'models/member.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<Member> _members = [];
  final Connectivity _connectivity = Connectivity();
  bool _isConnected = true;

  void _fetchData() async {
    UserSheetsApi.init().then((value) {
      Future.delayed(Duration.zero, () async {
        await UserSheetsApi.getAll().then((values) {
          setState(() {
            _members = values;
          });
        });
      });
    });
  }

  @override
  void initState() {
    _checkConnection();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    setState(() {
      _fetchData();
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final Store<MemberState> _store = Store<MemberState>(
      updateMemberReducer,
      initialState: MemberState(members: _members),
    );
    print('2');
    print(_members);
    return !_isConnected
        ? AlertDialog(
            title: Text(
              'No Internet connection!',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Text(
              'Check your Internet connection before starting this application.',
              style: TextStyle(
                color: Colors.grey[700],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  SystemNavigator.pop();
                  exit(0);
                },
                child: Text('Ok'),
              ),
            ],
          )
        : StoreProvider(
            store: _store,
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

  Future<void> _checkConnection() async {
    ConnectivityResult result = ConnectivityResult.none;
    try {
      result = await _connectivity.checkConnectivity();
      if (result != ConnectivityResult.none) {
        setState(() {
          _isConnected = true;
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
