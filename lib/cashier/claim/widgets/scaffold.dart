import 'dart:io';

import 'package:bet_app_virgo/login/widgets/builder.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../../../models/models.dart';
import '../../../utils/utils.dart';

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
  String err = '';
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
        if (err.isNotEmpty)
          Center(
            child: Text(
              "$err",
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
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
      final code = _result?.code;
      if (code != null) {
        try {
          _controller?.pauseCamera();
          // await showDialog(
          //     context: context, builder: (context) => AlertDialog(
          //       title: Text("Prize"),
          //       content: Text("${code}"),

          //     ));
          if (!code.contains("_")) {
            throw "Invalid Format.";
          }
          final result = await showDialog<BetReceipt>(
            context: context,
            builder: (context) {
              return LoginSuccessBuilder(builder: (user) {
                return LoadingDialog(
                  onLoading: () async {
                    try {
                      final _http = STLHttpClient();
                      final data = code.split("_");
                      final id = int.tryParse(data.last);
                      if (id != null) {
                        final betResultById = await _http.get(
                          '$adminEndpoint/receipts/$id',
                          onSerialize: (json) => BetReceipt.fromMap(json),
                          queryParams: {
                            'filter[cashier_id]': user.id,
                          },
                        );

                        Navigator.pop(context, betResultById);
                      } else {
                        throw "Invalid Format";
                      }
                    } catch (e) {
                      debugPrint('$e');
                      showInvalidMessage(e);
                      Navigator.pop(context, null);
                    }
                  },
                );
              });
            },
          );
          if (result != null) {
            if (result.status != 'V') {
              throw "${result.readableStatus}";
            }
            final showWinner = await showDialog<bool>(
                context: context,
                builder: (context) {
                  return _ClaimPrizeButton(
                    receipt: result,
                  );
                });
            _dialog = showWinner ?? false;
          }
          _dialog = false;
        } catch (e) {
          _dialog = false;
          showInvalidMessage(e);
        }
        _controller?.resumeCamera();
      }
    }
  }

  void showInvalidMessage(Object e) {
    setState(() {
      err = "$e";
    });
    Future.delayed(Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          err = "";
        });
      }
    });
  }
}

class _ClaimPrizeButton extends StatefulWidget {
  const _ClaimPrizeButton({required this.receipt, Key? key}) : super(key: key);
  final BetReceipt receipt;
  @override
  State<_ClaimPrizeButton> createState() => _ClaimPrizeButtonState();
}

class _ClaimPrizeButtonState extends State<_ClaimPrizeButton> {
  bool _isLoading = false;
  String err = '';
  void changeState() {
    setState(() {
      _isLoading = !_isLoading;
    });
  }

  void _onClaim(String cashierId) async {
    changeState();
    try {
      final _http = STLHttpClient();
      final response = await _http.post(
        "$adminEndpoint/receipts/claim-prizes/${widget.receipt.receiptNo}",
        onSerialize: (json) => BetReceipt.fromMap(json),
      );
    } catch (e) {
      err = e.toString();
    } finally {
      changeState();
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Claim Prize"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Prize:${widget.receipt.readablePrizesClaimed}"),
          if (err.isNotEmpty)
            Text(
              "$err",
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            )
        ],
      ),
      actions: [
        LoginSuccessBuilder(builder: (user) {
          return SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40))),
              onPressed: _isLoading ? null : () => _onClaim("${user.id}"),
              child: _isLoading
                  ? CircularProgressIndicator.adaptive()
                  : Text("CLAIM"),
            ),
          );
        })
        // TextButton(
        //     onPressed: () => Navigator.pop(context, false),
        //     child: Text("CLOSE"))
      ],
    );
  }
}
