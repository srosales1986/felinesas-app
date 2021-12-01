import 'package:intl/intl.dart';

class Utils {
  static formatPrice(double price) => '\$ ${price.toStringAsFixed(2)}';
  static formatDate(DateTime date) =>
      DateFormat.yMd('es_ES').add_Hms().format(date);
  static formatDateWithoutHms(DateTime date) =>
      DateFormat.yMd('es_ES').format(date);
}
