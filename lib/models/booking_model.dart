class Booking {
  final int id;
  final int propertyId;
  final int userId;
  final DateTime checkIn;
  final DateTime checkOut;
  final int guests;
  final double totalPrice;
  final double serviceFee;
  final double cleaningFee;
  final double propertyPrice;
  final int nights;
  final String status;
  final String? messageToHost;
  final DateTime createdAt;
  final String? stripePaymentIntentId;

  Booking({
    required this.id,
    required this.propertyId,
    required this.userId,
    required this.checkIn,
    required this.checkOut,
    required this.guests,
    required this.totalPrice,
    required this.serviceFee,
    required this.cleaningFee,
    required this.propertyPrice,
    required this.nights,
    required this.status,
    this.messageToHost,
    required this.createdAt,
    this.stripePaymentIntentId,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'],
      propertyId: json['propertyId'],
      userId: json['userId'],
      checkIn: DateTime.parse(json['checkIn']),
      checkOut: DateTime.parse(json['checkOut']),
      guests: json['guests'],
      totalPrice: double.parse(json['totalPrice'].toString()),
      serviceFee: double.parse(json['serviceFee'].toString()),
      cleaningFee: double.parse(json['cleaningFee'].toString()),
      propertyPrice: double.parse(json['propertyPrice'].toString()),
      nights: json['nights'],
      status: json['status'],
      messageToHost: json['messageToHost'],
      createdAt: DateTime.parse(json['createdAt']),
      stripePaymentIntentId: json['stripePaymentIntentId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'propertyId': propertyId,
      'userId': userId,
      'checkIn': checkIn.toIso8601String(),
      'checkOut': checkOut.toIso8601String(),
      'guests': guests,
      'totalPrice': totalPrice,
      'serviceFee': serviceFee,
      'cleaningFee': cleaningFee,
      'propertyPrice': propertyPrice,
      'nights': nights,
      'status': status,
      'messageToHost': messageToHost,
      'createdAt': createdAt.toIso8601String(),
      'stripePaymentIntentId': stripePaymentIntentId,
    };
  }
}
