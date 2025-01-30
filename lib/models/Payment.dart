// lib/models/PaymentRequest.dart

class Payment {
  final String phoneNumber;
  final double amount;
  final int bookingId;

  Payment({
    required this.phoneNumber,
    required this.amount,
    required this.bookingId,
  });

  Map<String, dynamic> toJson() {
    return {
      'phoneNumber': phoneNumber,
      'amount': amount,
      'bookingId': bookingId,
    };
  }
}