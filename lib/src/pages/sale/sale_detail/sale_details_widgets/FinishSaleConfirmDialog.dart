import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FinishSaleConfirmDialog extends StatelessWidget {
  final String title;
  final String contentText;
  final String? navigateTo;
  final Function yesFunction;
  final Function? noFunction;
  const FinishSaleConfirmDialog({
    Key? key,
    required this.title,
    required this.contentText,
    this.navigateTo,
    required this.yesFunction,
    this.noFunction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Container(
        child: Text(contentText),
      ),
      actions: [
        TextButton(
          onPressed: () {
            if (noFunction != null) {
              noFunction!();
            }
            Navigator.of(context).pop(false);
          },
          child: Text('No'),
        ),
        TextButton(
          onPressed: () {
            HapticFeedback.heavyImpact();
            Navigator.of(context).pop(false);
            yesFunction();
            if (navigateTo != null) {
              Navigator.pushReplacementNamed(context, navigateTo!);
            }
          },
          child: Text('Si'),
        ),
      ],
    );
  }
}
