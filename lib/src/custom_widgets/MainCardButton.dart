import 'package:flutter/material.dart';

class MainCardButton extends StatelessWidget {
  final String cardText, route;
  final IconData icon;
  final bool? isAdmin;

  const MainCardButton({
    Key? key,
    required this.cardText,
    required this.route,
    required this.icon,
    this.isAdmin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, route, arguments: isAdmin);
        },
        child: SizedBox(
          height: 130,
          width: 110,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 40,
                color: Colors.blue,
              ),
              Divider(
                thickness: 0.5,
                indent: 30,
                endIndent: 30,
              ),
              SizedBox(height: 10),
              Text(cardText),
            ],
          ),
        ),
      ),
    );
  }
}
