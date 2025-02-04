
class BookingRequest {
  final int destinationId;
  final String amount;
  final String location;
  final String date;


  BookingRequest({
    required this.destinationId,
    required this.amount,
    required this.location,
    required this.date,
  });

  Map<String, dynamic> toJson() {
    return {
      'destinationId': destinationId,
      'amount': amount,
      'location': location,
      'date': date,
    };
  }
}

class Booking {
  final int id;
  final int destinationId;
  final String amount;
  final String location;
  final String status;

  Booking({
    required this.id,
    required this.destinationId,
    required this.amount,
    required this.location,
    required this.status,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'],
      destinationId: json['destinationId'],
      amount: json['amount'],
      location: json['location'],
      status: json['status'],
    );
  }
}