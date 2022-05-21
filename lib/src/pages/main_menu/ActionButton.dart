import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String buttonText;
  final Widget icon;

  const ActionButton({
    Key? key,
    this.onPressed,
    required this.buttonText,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _textStyle = TextStyle(
      color: Colors.white,
    );
    return TextButton.icon(
      onPressed: onPressed,
      icon: icon,
      label: Text(
        buttonText,
        style: _textStyle,
      ),
      style: ButtonStyle(
        elevation: MaterialStateProperty.all(4),
        shape: MaterialStateProperty.all(StadiumBorder()),
        backgroundColor: MaterialStateProperty.all(Colors.blue),
      ),
    );
    // return Material(
    //   shape: const CircleBorder(),
    //   clipBehavior: Clip.antiAlias,
    //   color: theme.colorScheme.secondary,
    //   elevation: 4.0,
    //   child: TextButton(
    //     onPressed: onPressed,
    //     child: Text('Clientes'),
    //   ),
    // );
  }
}
