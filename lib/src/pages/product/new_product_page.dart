import 'package:chicken_sales_control/src/models/Product_model.dart';
import 'package:chicken_sales_control/src/pages/product/widgets/IsWighedChip.dart';
import 'package:chicken_sales_control/src/services/FirebaseProvider.dart';
import 'package:chicken_sales_control/src/services/ProductsProvider.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class NewProductPage extends StatelessWidget {
  const NewProductPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String? currentProductId =
        ModalRoute.of(context)!.settings.arguments as String?;

    bool isANewProduct = currentProductId == null;

    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: isANewProduct ? Text('Nuevo producto') : Text('Editar producto'),
      ),
      body: SingleChildScrollView(
        child: Card(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          elevation: 10,
          child: Column(
            children: [
              ElasticIn(
                child: Container(
                  margin: EdgeInsets.only(top: 40),
                  child: Icon(
                    Icons.post_add_rounded,
                    size: 50,
                    color: Colors.blueAccent,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 20),
                child: NewProductForm(
                  currentProductId: currentProductId,
                  isANewProduct: isANewProduct,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NewProductForm extends StatefulWidget {
  final String? currentProductId;
  final bool isANewProduct;
  const NewProductForm({
    Key? key,
    this.currentProductId,
    required this.isANewProduct,
  }) : super(key: key);

  @override
  _NewProductFormState createState() => _NewProductFormState();
}

class _NewProductFormState extends State<NewProductForm> {
  final _initialsTextController = TextEditingController();
  final _nameTextController = TextEditingController();
  final _priceByKgTextController = TextEditingController();
  final _priceByUnitController = TextEditingController();
  final _availabilityController = TextEditingController();
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _initialsTextController.dispose();
    _nameTextController.dispose();
    _priceByKgTextController.dispose();
    _priceByUnitController.dispose();
    _availabilityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final firebaseProvider =
        Provider.of<FirebaseProvider>(context, listen: false);
    final productProvider =
        Provider.of<ProductsProvider>(context, listen: false);
    final TextStyle _textStyle = TextStyle(fontSize: 15);

    // bool _isWeighed = false;

    if (!widget.isANewProduct) {
      Map<String, dynamic>? docRef;
      firebaseProvider.fbProductsCollectionRef
          .doc(widget.currentProductId)
          .get()
          .then((value) {
        docRef = value.data();
        _initialsTextController.text = docRef!['initials'];
        _nameTextController.text = docRef!['name'];
        if (docRef!['is_weighed']) {
          _priceByKgTextController.text = docRef!['price_by_kg'].toString();
          if (productProvider.isWeighed != docRef!['is_weighed']) {
            productProvider.changeIsWeighed();
          }
        } else {
          _priceByKgTextController.text = '';
          if (productProvider.isWeighed != docRef!['is_weighed']) {
            productProvider.changeIsWeighed();
          }
        }

        _priceByUnitController.text = docRef!['price_by_unit'].toString();
        _availabilityController.text =
            docRef!['availability_in_deposit'].toString();
      });
    }

    return Form(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            TextFormField(
              style: _textStyle,
              textAlign: TextAlign.center,
              controller: _nameTextController,
              autocorrect: false,
              decoration: InputDecoration(
                labelText: 'Nombre',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              enableSuggestions: false,
              style: _textStyle,
              controller: _initialsTextController,
              autocorrect: false,
              decoration: InputDecoration(
                labelText: 'Iniciales',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              enableSuggestions: false,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?\.?\d{0,2}')),
              ],
              style: _textStyle,
              controller: _priceByUnitController,
              autocorrect: false,
              decoration: InputDecoration(
                labelText: 'Precio por unidad',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            IsWeighedChip(),
            SizedBox(
              height: 20,
            ),
            PriceByKgTextField(
                textStyle: _textStyle,
                priceByKgTextController: _priceByKgTextController),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              enableSuggestions: false,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
              ],
              style: _textStyle,
              controller: _availabilityController,
              autocorrect: false,
              decoration: InputDecoration(
                labelText: 'Stock',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BounceInLeft(
                  duration: Duration(milliseconds: 200),
                  child: TextButton(
                    style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all(Colors.white),
                      backgroundColor: MaterialStateProperty.all(Colors.red),
                      padding: MaterialStateProperty.all(
                        EdgeInsets.symmetric(horizontal: 40),
                      ),
                    ),
                    onPressed: () {
                      // if (productProvider.isWeighed) {
                      //   productProvider.isWeighed = _isWeighed;
                      // }
                      Navigator.pushReplacementNamed(
                          context, 'products_price_list_page',
                          arguments: true);
                    },
                    child: Text(
                      'Cancelar',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                BounceInRight(
                  duration: Duration(milliseconds: 200),
                  child: TextButton(
                    style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all(Colors.white),
                      backgroundColor: MaterialStateProperty.all(Colors.green),
                      padding: MaterialStateProperty.all(
                        EdgeInsets.symmetric(horizontal: 40),
                      ),
                    ),
                    onPressed: () {
                      Product newProduct = Product(
                        id: '',
                        initials:
                            _initialsTextController.text.trim().toUpperCase(),
                        name: _nameTextController.text.trim(),
                        priceByKg: _priceByKgTextController.text != ''
                            ? double.parse(_priceByKgTextController.text.trim())
                            : 0,
                        priceByUnit:
                            double.parse(_priceByUnitController.text.trim()),
                        availabilityInDeposit:
                            double.parse(_availabilityController.text.trim()),
                        isWeighed: productProvider.isWeighed,
                      );
                      if (widget.isANewProduct) {
                        firebaseProvider.fbProductsCollectionRef
                            .doc()
                            .set(newProduct.toMap(newProduct));
                      } else {
                        firebaseProvider.fbProductsCollectionRef
                            .doc(widget.currentProductId)
                            .update(newProduct.toMap(newProduct));
                      }

                      Navigator.pushReplacementNamed(
                          context, 'products_price_list_page',
                          arguments: true);
                    },
                    child: Text(
                      'Guardar',
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class PriceByKgTextField extends StatelessWidget {
  const PriceByKgTextField({
    Key? key,
    required TextStyle textStyle,
    required TextEditingController priceByKgTextController,
  })  : _textStyle = textStyle,
        _priceByKgTextController = priceByKgTextController,
        super(key: key);

  final TextStyle _textStyle;
  final TextEditingController _priceByKgTextController;

  @override
  Widget build(BuildContext context) {
    final productProvider =
        Provider.of<ProductsProvider>(context, listen: true);
    return Visibility(
      visible: productProvider.isWeighed,
      child: TextFormField(
        enableSuggestions: false,
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?\.?\d{0,2}')),
        ],
        style: _textStyle,
        controller: _priceByKgTextController,
        autocorrect: false,
        decoration: InputDecoration(
          enabled: productProvider.isWeighed,
          isCollapsed: !productProvider.isWeighed,
          labelText: 'Precio por kg.',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }
}
