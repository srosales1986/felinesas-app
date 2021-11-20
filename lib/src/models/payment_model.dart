class Payment {
  String customerId;
  String customerName;
  String userId;
  String userName;
  String methodOfPayment;
  DateTime dateCreated;
  num previousBalance;
  num newBalance;
  num paymentAmount;

  Payment({
    required this.customerId,
    required this.customerName,
    required this.dateCreated,
    required this.newBalance,
    required this.previousBalance,
    required this.userId,
    required this.userName,
    required this.paymentAmount,
    required this.methodOfPayment,
  });

  Map<String, dynamic> toJson(Payment payment) {
    return {
      'customer_id': payment.customerId,
      'customer_name': payment.customerName,
      'user_id': payment.userId,
      'user_name': payment.userName,
      'date_created': payment.dateCreated,
      'previous_balance': payment.previousBalance,
      'new_balance': payment.newBalance,
      'payment_amount': payment.paymentAmount,
      'method_of_payment': payment.methodOfPayment,
    };
  }
}
