import 'dart:io';

import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../../../utils/nil.dart';

class ClaimQRScaffold extends StatefulWidget {
  const ClaimQRScaffold({Key? key}) : super(key: key);

  @override
  _ClaimQRScaffoldState createState() => _ClaimQRScaffoldState();
}

class _ClaimQRScaffoldState extends State<ClaimQRScaffold>
    with WidgetsBindingObserver {
  final GlobalKey _qrKey = GlobalKey();
  Barcode? _result;
  QRViewController? _controller;
  bool _dialog = false;
  bool _isGranted = true;

  @override
  void initState() {
    WidgetsBinding.instance?.addObserver(this);
    super.initState();
  }

  @override
  void reassemble() {
    resumeCamera();
    super.reassemble();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    resumeCamera();
    super.didChangeAppLifecycleState(state);
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void resumeCamera() {
    if (Platform.isAndroid) {
      _controller?.pauseCamera();
    } else if (Platform.isIOS) {
      _controller?.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    if (!_isGranted) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Permission was denied"),
          ElevatedButton(onPressed: () {}, child: Text("Retry")),
        ],
      );
    }
    return Stack(
      fit: StackFit.passthrough,
      children: [
        QRView(
          key: _qrKey,
          onQRViewCreated: _onQrViewCreated,
          overlay: QrScannerOverlayShape(
            borderLength: 50,
            borderRadius: 16,
            borderColor: Colors.yellow,
          ),
          onPermissionSet: (controller, permission) {
            setState(() {
              _isGranted = permission;
            });
          },
        ),
        Positioned(
          bottom: 10,
          right: size.width / 3,
          child: FutureBuilder<SystemFeatures>(
            future: _controller?.getSystemFeatures(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final data = snapshot.data;
                final hasFlash = data?.hasFlash ?? false;
                if (hasFlash)
                  return FloatingActionButton.extended(
                    onPressed: () async {
                      await _controller?.toggleFlash();
                    },
                    icon: Icon(Icons.flashlight_on),
                    label: Text("Flash"),
                  );
              }
              return notNil;
            },
          ),
        ),
      ],
    );
  }

  void _onQrViewCreated(QRViewController controller) {
    _controller = controller
      ..scannedDataStream.asyncMap((event) => event).listen((event) {
        setState(() {
          _result = event;
          _dialog = true;
          _showResult();
        });
      });
    _isGranted = controller.hasPermissions;
  }

  void _showResult() async {
    if (_dialog) {
      _dialog = await showDialog<bool>(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("Result"),
                content: Text("${_result?.code}"),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: Text("CLOSE"))
                ],
              );
            },
          ) ??
          false;
    }
  }
}
