import 'package:flutter/material.dart';

class AuthBackground extends StatelessWidget {
  final Widget child;

  const AuthBackground({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      // color: Colors.red,
      width: double.infinity,
      height: double.infinity,
      decoration: _backgroundDecoration(),
      child: Stack(
        children: [
          _secureLogo(size),
          Center(child: child),
        ],
      ),
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

  Container _secureLogo(Size size) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 70, vertical: 70),
      width: double.maxFinite,
      height: size.height * 0.4,
      // color: Colors.red,
      child: Image(
        image: AssetImage('assets/images/secure.png'),
        fit: BoxFit.contain,
      ),
    );
  }
}
