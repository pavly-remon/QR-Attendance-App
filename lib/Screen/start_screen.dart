import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:qr_attendance/Provider/googlesheets.dart';
import 'package:qr_attendance/Provider/member.dart';
import 'package:qr_attendance/Screen/qr_scanner_screen.dart';

class StartScreen extends StatefulWidget {
  static const routeName = 'start_screen';
  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  bool _isReady = false;
  List<Member> memberList = [];
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    Future.delayed(Duration.zero, () {
      fetchData();
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
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
        child: !_isReady
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  Container(
                    height: 5,
                  ),
                  Text('Loading Data')
                ],
              )
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: _dateWidget(),
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
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
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

  fetchData() async {
    await Provider.of<Domain>(context, listen: false).fetchData();
    setState(() {
      _isReady = true;
    });
  }
}

List<Widget> _dateWidget() {
  List<String> now =
      DateFormat("dd MM yyyy").format(DateTime.now()).split(' ').toList();
  return now
      .map((e) => Card(
            elevation: 3,
            child: Container(
              height: 100,
              width: e.length > 2 ? 150 : 100,
              child: Center(
                child: Text(
                  e,
                  style: TextStyle(
                    fontFamily: 'digital',
                    fontSize: 60,
                    color: Colors.blueAccent,
                  ),
                ),
              ),
            ),
          ))
      .toList();
}
