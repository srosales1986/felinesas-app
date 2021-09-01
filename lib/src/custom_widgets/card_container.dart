import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';

class CardContainer extends StatelessWidget {
  final Widget child;

  const CardContainer({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 50),
      child: ElasticIn(
        child: Container(
          padding: EdgeInsets.all(20),
          width: double.infinity,
          // height: 3,
          decoration: _containerDecoration(),
          child: Center(child: this.child),
        ),
      ),
    );
  }

  BoxDecoration _containerDecoration() => BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              blurRadius: 10,
              color: Colors.black26,
              offset: Offset(5, -5),
            ),
          ]);
}
