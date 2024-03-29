import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class Utils {
  static formatPrice(double price) => '\$ ${price.toStringAsFixed(2)}';
  static formatDate(DateTime date) =>
      DateFormat.yMd('es_ES').add_Hms().format(date);

  static formatDateWithoutHms(DateTime date) =>
      DateFormat.yMd('es_ES').format(date);

  static formatDateWithHms(DateTime date) =>
      DateFormat.Hms('es_ES').format(date);

  static formatDateOnlyHms(DateTime date) =>
      DateFormat('HH:mm', 'es_ES').format(date);

  static formatDateMonth(DateTime date) =>
      DateFormat.MMMM('es_ES').format(date).toUpperCase();

  static String formatCurrency(num price) =>
      '\$${NumberFormat.currency(locale: 'eu', name: '', decimalDigits: 1).format(price)}';
}
