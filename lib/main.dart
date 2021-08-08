import 'package:flutter/material.dart';
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

  void _fetchData() async {
    Future.delayed(Duration.zero, () async {
      await UserSheetsApi.getAll().then((values) {
        _members = values;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    final Store<MemberState> _store = Store<MemberState>(
      updateMemberReducer,
      initialState: MemberState(members: _members),
    );
    return StoreProvider(
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
}
