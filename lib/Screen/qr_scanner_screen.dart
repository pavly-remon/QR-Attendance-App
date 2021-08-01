import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_attendance/Provider/googlesheets.dart';
import 'package:qr_attendance/Provider/member.dart';
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

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
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
    final member = Provider.of<Domain>(context);
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(flex: 4, child: _buildQrView(context)),
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
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Welcome',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        '${member.getName(result!.code)}',
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
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.center,
                          //   crossAxisAlignment: CrossAxisAlignment.center,
                          //   children: <Widget>[
                          //     Container(
                          //       margin: EdgeInsets.all(8),
                          //       child: ElevatedButton(
                          //         onPressed: () async {
                          //           await controller?.pauseCamera();
                          //         },
                          //         child: Text('pause', style: TextStyle(fontSize: 20)),
                          //       ),
                          //     ),
                          //     Container(
                          //       margin: EdgeInsets.all(8),
                          //       child: ElevatedButton(
                          //         onPressed: () async {
                          //           await controller?.resumeCamera();
                          //         },
                          //         child: Text('resume', style: TextStyle(fontSize: 20)),
                          //       ),
                          //     )
                          //   ],
                          // ),
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
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    final member = Provider.of<Domain>(context, listen: false);
    var index;
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
        print(member.getMembers());
        if (member.getName(result!.code) != 'Unknown') {
          if (member.isScanned(result!.code)) {
            member.updateData(result!.code);
            index = member
                .getMembers()
                .where((element) => result!.code == element.id);
            UserSheetsApi.update(
                    id: result!.code,
                    member: member.getMembers()[index].toJson())
                .then((value) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Done'),
                duration: Duration(seconds: 1),
              ));
            });
          }
          if (member.isScanned(result!.code)) {
            member.updateData(result!.code);
            index = member
                .getMembers()
                .where((element) => result!.code == element.id);
            UserSheetsApi.update(
                    id: result!.code,
                    member: member.getMembers()[index].toJson())
                .then((value) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Done'),
                duration: Duration(seconds: 1),
              ));
            });
          }
        }
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
