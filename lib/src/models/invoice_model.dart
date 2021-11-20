class Invoice {
  final InvoiceInfo info;
  final List<InvoiceItem> items;

  const Invoice({
    required this.info,
    required this.items,
  });
}

class InvoiceInfo {
  final DateTime date;
  final String customerName;
  final String sellerName;
  final num subtotal;
  final num beforeBalance;
  final num finalBalance;
  final num total;
  final num cashIstallment;
  final num mpInstallment;
  final num discount;

  const InvoiceInfo({
    required this.date,
    required this.customerName,
    required this.sellerName,
    required this.subtotal,
    required this.beforeBalance,
    required this.finalBalance,
    required this.total,
    required this.cashIstallment,
    required this.mpInstallment,
    required this.discount,
  });
}

class InvoiceItem {
  final String productName;
  final num quantity;
  final num unitPrice;
  final num total;

  const InvoiceItem({
    required this.productName,
    required this.quantity,
    required this.unitPrice,
    required this.total,
  });
}
