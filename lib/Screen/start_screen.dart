import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qr_attendance/models/googlesheets.dart';
import 'package:qr_attendance/Screen/qr_scanner_screen.dart';

class StartScreen extends StatelessWidget {
  static const routeName = 'start_screen';
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      // drawer: Drawer(),
      appBar: AppBar(
        elevation: 3,
        centerTitle: true,
        title: Text(
          'نور العالم',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: _dateWidget(size),
              ),
              Container(
                height: 15,
              ),
              InkWell(
                splashColor: Colors.white,
                child: CupertinoButton(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  onPressed: () {
                    UserSheetsApi.updateHeaders();
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
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _dateWidget(Size size) {
    List<String> now =
        DateFormat("dd MM yyyy").format(DateTime.now()).split(' ').toList();
    return now
        .map((e) => Card(
              elevation: 3,
              child: Container(
                height: size.height * 0.1,
                width: e.length > 2 ? size.width * 0.3 : size.width * 0.2,
                child: Center(
                  child: Text(
                    e,
                    style: TextStyle(
                      color: Colors.blueAccent,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ))
        .toList();
  }
}
