import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MainButtonWidget extends StatefulWidget {
  final double width;
  final double height;
  final String cardText, route;
  final IconData icon;
  final bool? isAdmin;

  MainButtonWidget({
    required this.width,
    required this.height,
    required this.cardText,
    required this.route,
    required this.icon,
    this.isAdmin,
  });

  @override
  _MainButtonWidgetState createState() =>
      _MainButtonWidgetState(width: width, height: height);
}

class _MainButtonWidgetState extends State<MainButtonWidget> {
  _MainButtonWidgetState({required this.width, required this.height});
  double height = 0;
  double width = 0;
  String cardText = '';
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            blurRadius: 5,
            color: Colors.black26,
            offset: Offset(2, 2),
          ),
        ],
      ),
      margin: EdgeInsets.all(10),
      width: width,
      height: height,
      alignment: Alignment.center,
      child: ElevatedButton(
        style: ButtonStyle(
          padding: MaterialStateProperty.all(EdgeInsets.symmetric(vertical: 1)),
          enableFeedback: true,
          animationDuration: Duration(milliseconds: 400),
          // elevation: MaterialStateProperty.all(5),
          backgroundColor:
              MaterialStateColor.resolveWith((states) => Colors.white),
          foregroundColor:
              MaterialStateColor.resolveWith((states) => Colors.white),
          overlayColor:
              MaterialStateColor.resolveWith((states) => Colors.blue.shade200),
          // shadowColor: MaterialStateProperty.all(Colors.white),
        ),
        onPressed: () {
          HapticFeedback.selectionClick();
          Navigator.pushNamed(context, widget.route, arguments: widget.isAdmin);
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blue,
                // color: Color(0XFF4893b5),
                // gradient: LinearGradient(
                //   colors: [Color(0XFF4893b5), Colors.white],
                //   begin: Alignment.bottomRight,
                //   end: Alignment.topLeft,
                // ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black38,
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: Icon(
                widget.icon,
                size: 30,
                color: Colors.white,
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Divider(
              indent: 20,
              endIndent: 20,
              height: 14,
            ),
            Container(
              margin: EdgeInsets.only(top: 6),
              child: Text(
                widget.cardText,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 18,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
