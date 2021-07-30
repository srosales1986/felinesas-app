import 'package:chicken_sales_control/src/custom_widgets/MainButtonWidget.dart';
import 'package:chicken_sales_control/src/models/Product_model.dart';
import 'package:chicken_sales_control/src/services/ProductsProvider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:provider/provider.dart';

class DeliveryBoyHomePage extends StatelessWidget {
  const DeliveryBoyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DeliveryHomePage();
  }
}

class DeliveryHomePage extends StatelessWidget {
  const DeliveryHomePage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _db = FirebaseFirestore.instance;

    Future<QuerySnapshot<Map<String, dynamic>>> getAllProducts =
        _db.collection('products').get();

    return FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
      future: getAllProducts,
      builder: (context, snapshot) {
        var productsProvider =
            Provider.of<ProductsProvider>(context, listen: false);
        if (snapshot.hasError) {
          return Center(
            child: Text('Error'),
          );
        }
        if (!snapshot.hasData) {
          Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.hasData) {
          // productsProvider.fillProductList(snapshot.data!.docs
          //     .map((e) => Product.fromJson(e.data()))
          //     .toList());

          productsProvider.fillProductList(snapshot.data!.docs
              .map((e) => Product.fromJson(e.data()))
              .toList());
          print(productsProvider.productList.length);
          return DeliveryMenu();
        }
        return Container(
          color: Colors.white,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}

class DeliveryMenu extends StatelessWidget {
  const DeliveryMenu({
    Key? key,
  }) : super(key: key);

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
