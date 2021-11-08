import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:qr_attendance/cubit/member_cubit.dart';
import 'package:qr_attendance/utils/googlesheets.dart';
import 'package:qr_attendance/Screen/qr_scanner_screen.dart';

class StartScreen extends StatefulWidget {
  static const routeName = 'start_screen';

  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  bool _isConnected = true;
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final _appBar = AppBar(
      elevation: 3,
      centerTitle: true,
      title: Text(
        'نور العالم',
        style: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
    return _isConnected
        ? Scaffold(
            appBar: _appBar,
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => BlocProvider.value(
                                value: MemberCubit(),
                                child: QRScreen(),
                              ),
                            ),
                          );
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
          )
        : _connectionFailed(context);
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

  Widget _connectionFailed(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Connection failed!',
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Text(
        'Check your Internet connection and click Retry.',
        style: TextStyle(
          color: Colors.grey[700],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            _isConnected = true;
            Navigator.of(context).popAndPushNamed(StartScreen.routeName);
          },
          child: Text('Retry'),
        ),
      ],
    );
  }
}
