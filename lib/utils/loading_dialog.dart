import 'package:flutter/material.dart';

class LoadingDialog extends StatefulWidget {
  final VoidCallback? onLoading;
  const LoadingDialog({
    Key? key,
    this.onLoading,
  }) : super(key: key);

  @override
  _HeroLoadingDialogState createState() => _HeroLoadingDialogState();
}

class _HeroLoadingDialogState extends State<LoadingDialog> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (mounted) {
        widget.onLoading?.call();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: const Dialog(
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Center(
          child: CircularProgressIndicator.adaptive(),
        ),
      ),
    );
  }
}
