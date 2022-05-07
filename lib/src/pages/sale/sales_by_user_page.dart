import 'package:chicken_sales_control/src/models/User_model.dart';
import 'package:chicken_sales_control/src/pages/sale/sales_by_user_list_builder.dart';
// import 'package:chicken_sales_control/src/pages/sale/sales_data_fetch.dart';
// import 'package:chicken_sales_control/src/pages/sale/sales_repository.dart';
import 'package:chicken_sales_control/src/util/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/ReportProvider.dart';

class SalesByUserPage extends StatefulWidget {
  const SalesByUserPage({Key? key}) : super(key: key);

  @override
  State<SalesByUserPage> createState() => _SalesByUserPageState();
}

class _SalesByUserPageState extends State<SalesByUserPage> {
  @override
  Widget build(BuildContext context) {
    UserModel _currentUser =
        ModalRoute.of(context)!.settings.arguments as UserModel;
    final reportProvider = Provider.of<ReportProvider>(context, listen: true);
    final String _selectedDateString =
        Utils.formatDateWithoutHms(reportProvider.selectedDate);
    final TextStyle _titleFontSize = TextStyle(fontSize: 14);
    // SalesRepository salesRepository = SalesDataFetch();

    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        centerTitle: true,
        title: Column(
          children: [
            Text(_selectedDateString, style: _titleFontSize),
            Text('Ventas de ${_currentUser.userName}', style: _titleFontSize),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () async {
              DateTime? newDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime.utc(DateTime.now().year, 1, 1),
                lastDate: DateTime.now(),
                locale: Locale('es', 'ES'),
              );
              if (newDate == null) return;
              setState(() {
                print(newDate.toString());
                reportProvider.setSelectedDate(newDate);
              });
            },
            icon: Icon(Icons.filter_alt_sharp),
          ),
        ],
      ),
      body: SalesByUserListBuilder(
          currentUser: _currentUser, selectedDate: reportProvider.selectedDate),
    );
  }
}
