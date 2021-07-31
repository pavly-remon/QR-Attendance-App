import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_attendance/Provider/member.dart';
import 'package:qr_attendance/Screen/qr_scanner_screen.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({Key? key}) : super(key: key);

  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<Domain>(context).fetchData();
    return Scaffold(
        body: Center(
      child: InkWell(
        splashColor: Colors.white,
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).pushNamed(QRScreen.routeName);
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Start',
              style: TextStyle(fontSize: 20),
            ),
          ),
        ),
      ),
    ));
  }
}
