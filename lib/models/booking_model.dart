class Booking {
  final int id;
  final int propertyId;
  final int userId;
  final int? hostId;
  final DateTime checkIn;
  final DateTime checkOut;
  final int guests;
  final int numChildren;
  final int numInfants;
  final int numPets;
  final double totalPrice;
  final double serviceFee;
  final double cleaningFee;
  final double propertyPrice;
  final double taxAmount;
  final double discountAmount;
  final String currency;
  final int nights;
  final String status;
  final String? cancellationPolicy;
  final String? messageToHost;
  final String? hostMessage;
  final String? cancellationReason;
  final DateTime? confirmedAt;
  final DateTime? cancelledAt;
  final DateTime? completedAt;
  final DateTime createdAt;
  final String? stripePaymentIntentId;

  Booking({
    required this.id,
    required this.propertyId,
    required this.userId,
    this.hostId,
    required this.checkIn,
    required this.checkOut,
    required this.guests,
    this.numChildren = 0,
    this.numInfants = 0,
    this.numPets = 0,
    required this.totalPrice,
    required this.serviceFee,
    required this.cleaningFee,
    required this.propertyPrice,
    this.taxAmount = 0,
    this.discountAmount = 0,
    this.currency = 'USD',
    required this.nights,
    required this.status,
    this.cancellationPolicy,
    this.messageToHost,
    this.hostMessage,
    this.cancellationReason,
    this.confirmedAt,
    this.cancelledAt,
    this.completedAt,
    required this.createdAt,
    this.stripePaymentIntentId,
  });

  bool get isUpcoming =>
      (status == 'confirmed' || status == 'pending') &&
      checkOut.isAfter(DateTime.now());

  bool get isCompleted => status == 'completed' || (status == 'confirmed' && checkOut.isBefore(DateTime.now()));

  bool get isCancelled => status == 'cancelled' || status == 'declined' || status == 'expired';

  int get daysUntilCheckIn => checkIn.difference(DateTime.now()).inDays;

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'],
      propertyId: json['propertyId'],
      userId: json['userId'],
      hostId: json['hostId'],
      checkIn: DateTime.parse(json['checkIn']),
      checkOut: DateTime.parse(json['checkOut']),
      guests: json['guests'] ?? 1,
      numChildren: json['numChildren'] ?? 0,
      numInfants: json['numInfants'] ?? 0,
      numPets: json['numPets'] ?? 0,
      totalPrice: double.parse((json['totalPrice'] ?? 0).toString()),
      serviceFee: double.parse((json['serviceFee'] ?? 0).toString()),
      cleaningFee: double.parse((json['cleaningFee'] ?? 0).toString()),
      propertyPrice: double.parse((json['propertyPrice'] ?? 0).toString()),
      taxAmount: double.parse((json['taxAmount'] ?? 0).toString()),
      discountAmount: double.parse((json['discountAmount'] ?? 0).toString()),
      currency: json['currency'] ?? 'USD',
      nights: json['nights'] ?? 1,
      status: json['status'] ?? 'pending',
      cancellationPolicy: json['cancellationPolicy'],
      messageToHost: json['messageToHost'],
      hostMessage: json['hostMessage'],
      cancellationReason: json['cancellationReason'],
      confirmedAt: json['confirmedAt'] != null ? DateTime.parse(json['confirmedAt']) : null,
      cancelledAt: json['cancelledAt'] != null ? DateTime.parse(json['cancelledAt']) : null,
      completedAt: json['completedAt'] != null ? DateTime.parse(json['completedAt']) : null,
      createdAt: DateTime.parse(json['createdAt']),
      stripePaymentIntentId: json['stripePaymentIntentId'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'propertyId': propertyId,
        'userId': userId,
        'hostId': hostId,
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
      };
}
