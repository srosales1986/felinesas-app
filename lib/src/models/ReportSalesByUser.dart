import 'dart:convert';

class ReportSalesByUser {
  String customerName;
  Map<String, dynamic> salesReport;

  ReportSalesByUser({
    required this.customerName,
    required this.salesReport,
  });

  Map<String, dynamic> toMap() {
    return {
      'customerName': customerName,
      'salesReport': salesReport,
    };
  }

  factory ReportSalesByUser.fromMap(Map<String, dynamic> map) {
    return ReportSalesByUser(
      customerName: map['customerName'] ?? '',
      salesReport: Map<String, dynamic>.from(map['salesReport']),
    );
  }

  String toJson() => json.encode(toMap());

  factory ReportSalesByUser.fromJson(String source) =>
      ReportSalesByUser.fromMap(json.decode(source));
}
