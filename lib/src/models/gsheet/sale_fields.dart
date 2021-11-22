class SaleFields {
  static final String seller = 'Vendedor';
  static final String date = 'Fecha';
  static final String product = 'Productos';
  static final String subTotal = 'Subtotal';
  static final String previousBalance = 'Saldo anterior';
  static final String total = 'Total';
  static final String cashInstallment = 'Entrega en efectivo';
  static final String mpInstallment = 'Entrega MercadoPago';
  static final String discount = 'Descuento';
  static final String newBalance = 'Saldo actual';

  static List<String> getFields() => [
        seller,
        date,
        product,
        subTotal,
        previousBalance,
        total,
        cashInstallment,
        mpInstallment,
        discount,
        newBalance
      ];
}
