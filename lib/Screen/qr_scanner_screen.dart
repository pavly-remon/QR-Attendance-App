import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:qr_attendance/models/googlesheets.dart';
import 'package:qr_attendance/models/member.dart';
import 'package:qr_attendance/redux/actions.dart';
import 'package:qr_attendance/redux/state.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRScreen extends StatefulWidget {
  static const routeName = 'qr_screen';
  @override
  State<StatefulWidget> createState() => _QRScreenState();
}

class _QRScreenState extends State<QRScreen> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: StoreConnector<MemberState, List<Member>>(
        converter: (store) => store.state.members,
        builder: (context, List<Member> statemembers) => Stack(
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(flex: 4, child: _buildQrView(statemembers)),
              ],
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: size.width * 0.7,
                      height: size.height * 0.2,
                      child: Card(
                        elevation: 3,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            result != null
                                ? Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Welcome',
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          _getName(result!.code, statemembers),
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  )
                                : Text(
                                    'Scan a code',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.only(left: 3),
                                    child: InkWell(
                                      splashColor: Colors.white,
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          await controller?.toggleFlash();
                                          setState(() {});
                                        },
                                        style: ElevatedButton.styleFrom(
                                          shape: CircleBorder(),
                                          padding: EdgeInsets.all(15),
                                          primary: Colors.blue,
                                          onPrimary: Colors.white,
                                        ),
                                        child: FutureBuilder(
                                          future: controller?.getFlashStatus(),
                                          builder: (context, snapshot) {
                                            return snapshot.data == true
                                                ? Icon(Icons.flash_on)
                                                : Icon(Icons.flash_off);
                                            // Text('Flash: ${snapshot.data}');
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.all(3),
                                    child: InkWell(
                                      splashColor: Colors.white,
                                      child: ElevatedButton(
                                          onPressed: () async {
                                            await controller?.flipCamera();
                                            setState(() {});
                                          },
                                          style: ElevatedButton.styleFrom(
                                            shape: CircleBorder(),
                                            padding: EdgeInsets.all(15),
                                            primary: Colors.blue,
                                            onPrimary: Colors.white,
                                          ),
                                          child: Icon(Icons.flip_camera_ios)),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildQrView(List<Member> memberList) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: (_) {
        _onQRViewCreated(_, memberList);
      },
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
    );
  }

  void _onQRViewCreated(QRViewController controller, List<Member> memberList) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
        _updateMember(context, memberList, result!.code);
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}

String _getName(String code, List<Member> statemembers) {
  int index = statemembers.indexWhere((element) => element.id == code);
  return statemembers[index].name;
}

void _updateMember(BuildContext context, List<Member> memberList, String code) {
  var headers = UserSheetsApi.headerRow;
  String now = UserSheetsApi.now;
  int index = memberList.indexWhere((element) => element.id == code);
  if (!memberList[index].scanned) {
    memberList[index].scanned = !memberList[index].scanned;
    UserSheetsApi.insertValue('O', headers.length + 1, index + 2).then((value) {
      memberList[index].attendance[now] = "O";
      StoreProvider.of<MemberState>(context)
          .dispatch(UpdateMemberAttendance(memberList[index]));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Done'),
          duration: Duration(seconds: 1),
        ),
      );
    });
  }
}
