import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_attendance/cubit/member_cubit.dart';
import 'package:qr_attendance/models/member.dart';
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
    final _blocProvider = BlocProvider.of<MemberCubit>(context);
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          _buildQrView(context),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 25,
              ),
              IconButton(
                onPressed: () {
                  controller!.pauseCamera();
                  dispose();
                  Navigator.of(context).pop();
                },
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
              ),
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
                    height: size.height * 0.25,
                    child: Card(
                      elevation: 3,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          result != null
                              ? BlocConsumer<MemberCubit, MemberState>(
                                  listener: (context, state) {
                                  int index = state.members.indexWhere(
                                      (element) => element.id == result!.code);
                                  if (index != -1 &&
                                      state.members[index].scanned) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Done'),
                                        duration: Duration(seconds: 1),
                                      ),
                                    );
                                  }
                                }, builder: (context, state) {
                                  _blocProvider.read(result!.code!);
                                  int index = state.members.indexWhere(
                                      (element) => element.id == result!.code);
                                  if (index == -1) {
                                    return Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: CircularProgressIndicator(),
                                      ),
                                    );
                                  }
                                  return Text(
                                    _getName(result!.code!, state.members),
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  );
                                })
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
          ),
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
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
        _onQRViewCreated(_, context);
      },
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
    );
  }

  void _onQRViewCreated(QRViewController controller, BuildContext context) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}

String _getName(String code, List<Member> stateMembers) {
  int index = stateMembers.indexWhere((element) => element.id == code);
  return stateMembers[index].name;
}
