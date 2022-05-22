import 'package:flutter/material.dart';

class InitBackground extends StatelessWidget {
  final Widget child;

  const InitBackground({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: _backgroundDecoration(),
      child: Center(child: child),
    );
  }

  BoxDecoration _backgroundDecoration() {
    return BoxDecoration(
        gradient: LinearGradient(
      colors: [
        Colors.blue.shade900,
        Colors.grey.shade300,
      ],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      tileMode: TileMode.repeated,
    ));
  }
}
