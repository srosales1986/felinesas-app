import 'package:chicken_sales_control/src/custom_widgets/MainButtonWidget.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';

class DeliveryBoyHomePage extends StatelessWidget {
  const DeliveryBoyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: ZoomIn(child: Text('HOME')),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElasticInDown(
                    child: MainButtonWidget(
                      width: 150,
                      height: 150,
                      cardText: 'Nueva venta',
                      route: 'sales_page',
                      icon: Icons.receipt,
                    ),
                  ),
                  ElasticInDown(
                    child: MainButtonWidget(
                      width: 150,
                      height: 150,
                      cardText: 'Lista de precios',
                      route: 'price_list_page',
                      icon: Icons.request_quote,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElasticInUp(
                    child: MainButtonWidget(
                        width: 150,
                        height: 150,
                        cardText: 'Carga',
                        route: 'load_page',
                        icon: Icons.local_shipping),
                  ),
                  ElasticInUp(
                    child: MainButtonWidget(
                        width: 150,
                        height: 150,
                        cardText: 'Descarga',
                        route: 'unload_truck_page',
                        icon: Icons.assignment_return),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
