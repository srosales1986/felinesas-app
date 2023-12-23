import 'package:chicken_sales_control/src/models/gsheet/sale_fields.dart';
import 'package:gsheets/gsheets.dart';

class SalesSheetsApi {
  // static final _spreadsheetId = '1_9w7xm6i7NG5ZXiPqDuWQ_m8POm82Vbpwq-hefWiXdY';
  static String _spreadsheetId = '';
  static set spreadsheetId(String spreadsheetId) =>
      _spreadsheetId = spreadsheetId;

  static Worksheet? _monthSheet;

  static Future init(
      String sheetTitle, Map<String, dynamic> credentials) async {
    final _gsheets = GSheets(credentials);
    try {
      final spreadsheet = await _gsheets.spreadsheet(_spreadsheetId);
      _monthSheet = await _getWorkSheet(spreadsheet, title: sheetTitle);

      final firstRow = SaleFields.getFields();
      _monthSheet!.values.insertRow(1, firstRow);
    } on Exception catch (e) {
      print('Error al iniciar GSheet: $e');
    }
  }

  static newRow(List<String> data) {
    try {
      _monthSheet!.values.appendRow(data);
    } on Exception catch (e) {
      print(e.toString());
    }
  }

  static Future<Worksheet> _getWorkSheet(
    Spreadsheet spreadsheet, {
    required String title,
  }) async {
    try {
      return await spreadsheet.addWorksheet(title);
    } on Exception catch (e) {
      print(e.toString());
      return spreadsheet.worksheetByTitle(title)!;
    }
  }
}
