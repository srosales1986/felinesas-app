import 'package:flutter/material.dart';

class PdfView extends StatelessWidget {
  const PdfView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text('Comprobante'),
      ),
      body: Container(
        child: Center(
          child: Text('Aca va el PDF'),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () {
                Navigator.pushReplacementNamed(
                    context, 'delivery_boy_home_page');
              },
              icon: Icon(Icons.home),
            ),
          ],
        ),
      ),
    );
  }
}
