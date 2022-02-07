import 'dart:io';

import 'package:bet_app_virgo/login/widgets/builder.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../../../models/models.dart';
import '../../../utils/utils.dart';

enum ClaimType { input, qrcode, none }
mixin ClaimPOSTMixin<T extends StatefulWidget> on State<T> {
  bool isLoading = false;
  String err = '';
  void changeState() {
    setState(() {
      isLoading = !isLoading;
    });
  }

  Future<void> onClaim(
    String cashierId,
    String receiptNo, {
    VoidCallback? onFinished,
  }) async {
    assert(receiptNo.isNotEmpty, "Receipt no. not found");
    changeState();
    try {
      final _http = STLHttpClient();
      final response = await _http.post(
        "$adminEndpoint/receipts/claim-prizes/$receiptNo",
        onSerialize: (json) => BetReceipt.fromMap(json),
      );
    } catch (e) {
      err = e.toString();
    } finally {
      changeState();
    }
    onFinished?.call();
  }

  Future<BetReceipt?> fetchReceipt(String receiptNo) {
    return showDialog<BetReceipt>(
      context: context,
      builder: (context) {
        return LoginSuccessBuilder(builder: (user) {
          return LoadingDialog(
            onLoading: () async {
              try {
                final _http = STLHttpClient();

                final betResultById = await _http.get(
                  '$adminEndpoint/receipts/no/$receiptNo',
                  onSerialize: (json) => BetReceipt.fromMap(json),
                  queryParams: {
                    'filter[cashier_id]': user.id,
                  },
                );

                Navigator.pop(context, betResultById);
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

class ClaimPrizeScaffold extends StatefulWidget {
  const ClaimPrizeScaffold({Key? key}) : super(key: key);

  @override
  State<ClaimPrizeScaffold> createState() => _ClaimPrizeScaffoldState();
}

class _ClaimPrizeScaffoldState extends State<ClaimPrizeScaffold> {
  ClaimType _claimType = ClaimType.none;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "CLAIM BY",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _claimType = ClaimType.input;
                  });
                },
                child: Text("INPUT"),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _claimType = ClaimType.qrcode;
                  });
                },
                child: Text("QR CODE"),
              ),
            ],
          ),
        ),
        if (_claimType == ClaimType.qrcode)
          Flexible(
            child: ClaimQRBody(),
          )
        else if (_claimType == ClaimType.input)
          Flexible(child: ClaimInputBody()),
      ],
    );
  }
}

class ClaimQRBody extends StatefulWidget {
  const ClaimQRBody({Key? key}) : super(key: key);

  @override
  _ClaimQRBodyState createState() => _ClaimQRBodyState();
}

class _ClaimQRBodyState extends State<ClaimQRBody>
    with WidgetsBindingObserver, ClaimPOSTMixin {
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
    return Stack(
      fit: StackFit.passthrough,
      children: [
        if (_isGranted)
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
          )
        else
          Text("Camera permission was denied"),
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

          final result = await fetchReceipt(code);
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
            _dialog = false;
          }
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

class _ClaimPrizeButtonState extends State<_ClaimPrizeButton>
    with ClaimPOSTMixin {
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
              onPressed: isLoading
                  ? null
                  : () => onClaim(
                        "${user.id}",
                        widget.receipt.receiptNo ?? '',
                        onFinished: () => Navigator.pop(context),
                      ),
              child: isLoading
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

class ClaimInputBody extends StatefulWidget {
  const ClaimInputBody({Key? key}) : super(key: key);

  @override
  State<ClaimInputBody> createState() => _ClaimInputBodyState();
}

class _ClaimInputBodyState extends State<ClaimInputBody> with ClaimPOSTMixin {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    _controller = TextEditingController();
    _focusNode = FocusNode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Enter Receipt No.",
              ),
              keyboardType: TextInputType.numberWithOptions(),
              controller: _controller,
              focusNode: _focusNode,
              validator: (val) {
                if (val != null) {
                  if (val.isEmpty) {
                    return "Field required";
                  }
                }
                return null;
              },
            ),
          ),
          LoginSuccessBuilder(builder: (user) {
            if (isLoading) {
              return Center(child: CircularProgressIndicator.adaptive());
            }
            return ElevatedButton(
                onPressed: () async {
                  final isValid = _formKey.currentState?.validate() ?? false;
                  if (isValid) {
                    final result = await fetchReceipt(_controller.text);
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

                      _controller.clear();
                      _focusNode.requestFocus();
                    }
                  }
                },
                child: Text("CLAIM"));
          }),
        ],
      ),
    );
  }
}
