import 'package:animate_do/animate_do.dart';
import 'package:chicken_sales_control/src/services/FirebaseProvider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductPriceList extends StatelessWidget {
  const ProductPriceList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool _isAdmin = ModalRoute.of(context)!.settings.arguments as bool;
    final _fbProvider = Provider.of<FirebaseProvider>(context, listen: false);
    final _poructsCollectionStream =
        _fbProvider.fbProductsCollectionRef.snapshots();

    Widget _bottonAction(IconData icon) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          child: Icon(
            icon,
            size: 30.0,
          ),
          onTap: () {
            Navigator.pushReplacementNamed(context, 'delivery_boy_home_page');
          },
        ),
      );
    }

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: _isAdmin
          ? FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () {
                Navigator.pushReplacementNamed(context, 'new_product_page');
              },
            )
          : null,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: _isAdmin ? Text('Productos') : Text('Lista de precios'),
      ),
      body: Container(
        padding: const EdgeInsets.only(top: 15.0),
        child: ProductsListViewBuilder(
          stream: _poructsCollectionStream,
          isAdmin: _isAdmin,
          fbProvider: _fbProvider,
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        notchMargin: 8.0,
        shape: CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _bottonAction(Icons.home),
          ],
        ),
      ),
    );
  }
}

enum MenuOption { INFO, EDIT, DELETE }

class ProductsListViewBuilder extends StatefulWidget {
  const ProductsListViewBuilder({
    Key? key,
    required bool isAdmin,
    required Stream<QuerySnapshot<Map<String, dynamic>>> stream,
    required FirebaseProvider fbProvider,
  })  : _poructsCollectionStream = stream,
        _isAdmin = isAdmin,
        _fbProvider = fbProvider,
        super(key: key);

  final Stream<QuerySnapshot<Map<String, dynamic>>> _poructsCollectionStream;
  final bool _isAdmin;
  final FirebaseProvider _fbProvider;

  @override
  State<ProductsListViewBuilder> createState() =>
      _ProductsListViewBuilderState();
}

class _ProductsListViewBuilderState extends State<ProductsListViewBuilder> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: widget._poructsCollectionStream,
      // initialData: initialData,
      builder: (BuildContext context,
          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        final docs = snapshot.data!.docs;
        return ListView.builder(
          physics: BouncingScrollPhysics(),
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (BuildContext context, int index) {
            return Column(
              children: [
                ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  minVerticalPadding: 1,
                  leading: CircleAvatar(
                    backgroundColor: Color(0xFFadcbff),
                    radius: 27,
                    child: Text(
                      docs[index].get('initials'),
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  title: Text(
                    docs[index].get('name'),
                    style: TextStyle(fontSize: 18),
                  ),
                  trailing: widget._isAdmin
                      ? Container(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '\$${docs[index].get('price_by_unit').toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.lightGreen,
                                ),
                              ),
                              PopupMenuButton<MenuOption>(
                                onSelected: (value) {
                                  if (value == MenuOption.DELETE) {
                                    showDialog(
                                        barrierDismissible: false,
                                        context: context,
                                        builder: (context) {
                                          return BounceInUp(
                                            duration:
                                                Duration(milliseconds: 200),
                                            child: AlertDialog(
                                              title: Text('Eliminar cliente'),
                                              content: Container(
                                                child: Text(
                                                    '¿Está seguro que desea eliminar el Producto?'),
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context)
                                                        .pop(false);
                                                  },
                                                  child: Text('Cancelar'),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    widget._fbProvider
                                                        .fbProductsCollectionRef
                                                        .doc(docs[index].id)
                                                        .delete();
                                                    Navigator.of(context)
                                                        .pop(false);
                                                  },
                                                  child: Text('Eliminar'),
                                                ),
                                              ],
                                            ),
                                          );
                                        });
                                  }
                                  if (value == MenuOption.EDIT) {
                                    Navigator.pushReplacementNamed(
                                        context, 'new_product_page',
                                        arguments: docs[index].id);
                                  }
                                  if (value == MenuOption.INFO) {
                                    TextStyle cardSubTitleStyle = TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    );
                                    TextStyle cardTextStyle = TextStyle(
                                        fontSize: 16,
                                        overflow: TextOverflow.ellipsis,
                                        color: Colors.black87);
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return BounceInUp(
                                          duration: Duration(milliseconds: 200),
                                          child: AlertDialog(
                                            actionsAlignment:
                                                MainAxisAlignment.center,
                                            title: Center(
                                              child:
                                                  Text(docs[index].get('name')),
                                            ),
                                            content: buildCardCustomerInfo(
                                              cardTextStyle,
                                              cardSubTitleStyle,
                                              docs,
                                              index,
                                            ),
                                            actions: [
                                              TextButton(
                                                style: ButtonStyle(
                                                  fixedSize:
                                                      MaterialStateProperty.all(
                                                          Size(300, 60)),
                                                ),
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .pop(false);
                                                },
                                                child: Container(
                                                    child: Text('OK')),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  }
                                },
                                itemBuilder: (context) {
                                  return <PopupMenuEntry<MenuOption>>[
                                    PopupMenuItem(
                                      child: Text('Info'),
                                      value: MenuOption.INFO,
                                    ),
                                    PopupMenuItem(
                                      child: Text('Editar'),
                                      value: MenuOption.EDIT,
                                    ),
                                    PopupMenuItem(
                                      child: Text('Eliminar'),
                                      value: MenuOption.DELETE,
                                    ),
                                  ];
                                },
                              ),
                            ],
                          ),
                        )
                      : Text(
                          '\$${docs[index].get('price_by_unit').toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.lightGreen,
                          ),
                        ),
                ),
                Divider(),
              ],
            );
          },
        );
      },
    );
  }

  Card buildCardCustomerInfo(
      TextStyle cardTextStyle,
      TextStyle cardSubTitleStyle,
      List<QueryDocumentSnapshot<Map<String, dynamic>>> docs,
      int index) {
    return Card(
      elevation: 8,
      child: Container(
        margin: EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(style: cardTextStyle, children: [
                TextSpan(style: cardSubTitleStyle, text: 'Precio por Kg: '),
                TextSpan(text: '${docs[index].get('price_by_kg')}'),
              ]),
            ),
            Divider(),
            RichText(
              text: TextSpan(style: cardTextStyle, children: [
                TextSpan(style: cardSubTitleStyle, text: 'Precio por unidad: '),
                TextSpan(text: '${docs[index].get('price_by_unit')}'),
              ]),
            ),
            Divider(),
            RichText(
              text: TextSpan(style: cardTextStyle, children: [
                TextSpan(style: cardSubTitleStyle, text: 'Stock: '),
                TextSpan(text: '${docs[index].get('availability_in_deposit')}'),
              ]),
            ),
            // Divider(),
            // RichText(
            //   text: TextSpan(style: cardTextStyle, children: [
            //     TextSpan(style: cardSubTitleStyle, text: 'Saldo: '),
            //     TextSpan(text: '\$${docs[index].balance}'),
            //   ]),
            // ),
          ],
        ),
      ),
    );
  }

  onTapFunction(BuildContext context) {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return BounceInUp(
            duration: Duration(milliseconds: 200),
            child: AlertDialog(
              title: Text('Editar Producto'),
              content: Container(
                child: Form(
                    child: Column(
                  children: [
                    TextFormField(),
                    TextFormField(),
                    TextFormField(),
                    TextFormField(),
                  ],
                )),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text('Cancelar'),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text('Eliminar'),
                ),
              ],
            ),
          );
        });
  }
}
