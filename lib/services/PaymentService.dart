// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import '../models/Payment.dart';
// import '../models/PaymentResponse.dart';
//
// class PaymentService {
//   static const String baseUrl = 'http://192.168.254.95:8080';
//
//   // Process payment
//   Future<PaymentResponse> makePayment({
//     required String phoneNumber,
//     required double amount,
//     required int bookingId,
//   }) async {
//     try {
//       final payment = Payment(
//         phoneNumber: phoneNumber,
//         amount: amount,
//         bookingId: bookingId,
//       );
//
//       final response = await http.post(
//         Uri.parse('$baseUrl/api/payments/initiate'),
//         headers: {
//           'Content-Type': 'application/json',
//         },
//         body: jsonEncode(payment.toJson()),
//       );
//
//       if (response.statusCode == 200) {
//         return PaymentResponse.fromJson(jsonDecode(response.body));
//       } else {
//         throw Exception('Payment processing failed: ${response.body}');
//       }
//     } catch (e) {
//       throw Exception('Error processing payment: $e');
//     }
//   }
// }