import 'package:flutter/material.dart';
import 'package:qr_scanner/screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:qr_scanner/custom_icons_icons.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRViewExample extends StatefulWidget {
  @override
  _QRViewExampleState createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  QRViewController controller;
  String result = '';
  bool flashOn = false;
  bool isPaused = false;

  @override
  Widget build(BuildContext context) {
    Screen.init(context);
    return Scaffold(
        body: SafeArea(
            child: Stack(children: <Widget>[
      Column(
        children: <Widget>[
          Expanded(
            child:
                /*Container(
                         color: Colors.black54,
                      child:
                      null /*Icon(CustomIcons.flip_camera,color: Colors.blueGrey,)*/,
                      )*/
                QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
        ],
      ),
      Column(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
        Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              SizedBox(
                height: Screen.heightBlock * 8.5,
                child: FlatButton(
                  onPressed: () => controller.flipCamera(),
                  child: Icon(
                    CustomIcons.flip_camera,
                    color: Colors.black,
                    size: Screen.widthBlock * 6.4,
                  ),
                  shape: CircleBorder(),
                  color: Colors.white,
                ),
              ),
              SizedBox(
                width: Screen.widthBlock * 1.5,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 0),
                child: SizedBox(
                  height: Screen.heightBlock * 10.5,
                  child: FlatButton(
                    onPressed: isPaused
                        ? () {
                            controller.resumeCamera();
                            setState(() {
                              isPaused = false;
                            });
                          }
                        : () {
                            controller.pauseCamera();
                            setState(() {
                              isPaused = true;
                            });
                          },
                    child: Row(
                      children: <Widget>[
                        SizedBox(
                          width: isPaused ? Screen.widthBlock * 1 : 0,
                        ),
                        Icon(
                          isPaused ? CustomIcons.resume : CustomIcons.pause,
                          color: Colors.black,
                          size: Screen.widthBlock * 6.5,
                        ),
                      ],
                    ),
                    shape: CircleBorder(),
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(
                width: Screen.widthBlock * 1.5,
              ),
              SizedBox(
                  height: Screen.heightBlock * 8.5,
                  child: FlatButton(
                    onPressed: () {
                      controller.toggleFlash();
                      setState(() {
                        flashOn = !flashOn;
                      });
                    },
                    shape: CircleBorder(),
                    color: Colors.white,
                    child: Align(
                      alignment: flashOn
                          ? FractionalOffset(0.0, 0.55)
                          : FractionalOffset(0.1, 0.55),
                      child: Icon(
                        flashOn ? CustomIcons.flash_off : CustomIcons.flash_on,
                        color: Colors.black,
                        size: Screen.widthBlock * 6.1,
                      ),
                    ),
                  ))
            ])
      ])
    ])));
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      print('*Data is:' + scanData);
      //print(_isNumericInt(scanData).toString()+'**');
      if (_isNumericInt(scanData)) {
        controller.pauseCamera();
        isPaused = true;
        result = scanData;
        _launchURL();
      }
    });
  }

  _launchURL() async {
    String url = "tel:*101*" + result + Uri.encodeComponent('#');
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  bool _isNumericInt(String str) {
    if (str == null || str == '') {
      return false;
    }
    return int.tryParse(str) != null;
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
