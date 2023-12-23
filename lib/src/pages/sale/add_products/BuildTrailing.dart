import 'package:chicken_sales_control/src/models/Product_model.dart';
import 'package:chicken_sales_control/src/pages/sale/add_products/AddWeightDialog.dart';
import 'package:chicken_sales_control/src/services/ProductService.dart';
import 'package:flutter/material.dart';

class BuildTrailing extends StatefulWidget {
  final Product product;

  BuildTrailing({Key? key, required this.product}) : super(key: key);

  @override
  _BuildTrailingState createState() => _BuildTrailingState();
}

class _BuildTrailingState extends State<BuildTrailing> {
  late TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController(text: '0');
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.product.isWeighed) {
      return Amount(
        productId: widget.product.id,
        product: widget.product,
      );
    }
    return AddWeightDialog(product: widget.product);
  }
}
