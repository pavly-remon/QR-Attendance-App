import 'package:flutter/cupertino.dart';
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
  bool _isReady = false;
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<Domain>(context).fetchData().then((value) {
      setState(() {
        _isReady = true;
      });
    });
    return Scaffold(
        drawer: Drawer(),
        appBar: AppBar(
          elevation: 3,
          centerTitle: true,
          title: Text(
            'Nour El Allam',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Center(
          child: !_isReady
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    Container(
                      height: 5,
                    ),
                    Text('Loading...'),
                  ],
                )
              : InkWell(
                  splashColor: Colors.white,
                  child: CupertinoButton(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    onPressed: () {
                      Navigator.of(context).pushNamed(QRScreen.routeName);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Container(
                        height: 20,
                        width: 60,
                        child: Center(
                          child: Text(
                            'Start',
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
        ));
  }
}
