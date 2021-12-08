import 'package:chicken_sales_control/src/models/Product_model.dart';
import 'package:chicken_sales_control/src/pages/sale/add_products/AddWeightDialog.dart';
import 'package:chicken_sales_control/src/services/ProductService.dart';
import 'package:chicken_sales_control/src/services/SaleProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    var saleProvider = Provider.of<SaleProvider>(context, listen: true);

    if (!widget.product.isWeighed) {
      return Amount(
        productId: widget.product.id,
        product: widget.product,
      );
    }
    return AddWeightDialog(product: widget.product);
    // return Container(
    //   decoration: BoxDecoration(
    //     color: Colors.grey.shade300,
    //     shape: BoxShape.rectangle,
    //     borderRadius: BorderRadius.circular(30),
    //   ),
    //   child: Row(
    //     mainAxisSize: MainAxisSize.min,
    //     mainAxisAlignment: MainAxisAlignment.center,
    //     children: [
    //       Container(
    //         padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
    //         child: TextField(
    //           onSubmitted: (weight) {
    //             if (_controller.text != '' && _controller.text != '0') {
    //               saleProvider.updateWeighedAmount(
    //                   widget.product, double.parse(weight));
    //             } else {
    //               saleProvider.deleteWeighedProduct(widget.product);
    //             }
    //           },
    //           onTap: () {
    //             if (_controller.text == '0') {
    //               _controller.clear();
    //             }
    //           },
    //           onChanged: (weight) {
    //             if (_controller.text != '' && _controller.text != '0') {
    //               saleProvider.updateWeight(
    //                   widget.product, double.parse(weight));
    //             } else {
    //               saleProvider.deleteWeighedProduct(widget.product);
    //             }
    //           },
    //           controller: _controller,
    //           textAlign: TextAlign.end,
    //           keyboardType: TextInputType.number,
    //           inputFormatters: [
    //             FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?\.?\d{0,2}')),
    //             LengthLimitingTextInputFormatter(11),
    //           ],
    //           decoration: InputDecoration(
    //             constraints: BoxConstraints(maxHeight: 40, maxWidth: 90),
    //             border: InputBorder.none,
    //           ),
    //         ),
    //       ),
    //       Container(
    //         padding: EdgeInsets.symmetric(horizontal: 10),
    //         child: Center(child: Text('Kg')),
    //       )
    //     ],
    //   ),
    // );
  }
}
