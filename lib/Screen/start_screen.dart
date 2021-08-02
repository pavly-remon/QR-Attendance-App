import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
<<<<<<< HEAD
    Future.delayed(Duration.zero, () {
      fetchData();
    });
=======
    if (_isInit) {
      Provider.of<Domain>(context).fetchData().then((value) {
        setState(() {
          _isReady = true;
          _isInit = false;
          // memberList = Provider.of<Domain>(context, listen: false).members;
        });
      });
    }
>>>>>>> origin/main
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
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
<<<<<<< HEAD
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
=======
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
>>>>>>> origin/main
                        ),
                      ),
                    ),
                  ),
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
