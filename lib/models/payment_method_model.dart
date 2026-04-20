class PaymentMethod {
  final String id;
  final String brand;
  final String last4;
  final int expMonth;
  final int expYear;
  final bool isDefault;

  PaymentMethod({
    required this.id,
    required this.brand,
    required this.last4,
    required this.expMonth,
    required this.expYear,
    this.isDefault = false,
  });

  factory PaymentMethod.fromStripeJson(Map<String, dynamic> json) {
    final card = json['card'];
    return PaymentMethod(
      id: json['id'],
      brand: card['brand'],
      last4: card['last4'],
      expMonth: card['exp_month'],
      expYear: card['exp_year'],
    );
  }
}
