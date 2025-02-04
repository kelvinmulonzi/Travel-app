import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:wanderlust/utils/api_client.dart';
import '../models/Payment.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var destination = Get.arguments;
  late String amount;
  String _phoneNumber = '';

  @override
  void initState() {
    super.initState();
    amount = destination["price"].toString();
    _amountController.text = amount; // Set amount in controller
  }

  void _submitPayment() async {
    if (!_formKey.currentState!.validate()) return;

    // Ensure the phone number starts with 254 and has correct format
    String cleanNumber = _phoneNumber.replaceAll(RegExp(r'[^\d]'), '');
    if (!cleanNumber.startsWith('254')) {
      cleanNumber = '254${cleanNumber.substring(cleanNumber.length - 9)}';
    }

    print("Submitting phone number: $cleanNumber"); // Debug print

    // Assuming bookingId is retrieved dynamically
    int bookingId = 123;

    Payment payment = Payment(
      phoneNumber: cleanNumber, // Using the cleaned and formatted number
      amount: double.parse(amount),
      bookingId: bookingId,
    );

    final data = await ApiClient().makePayment(payment.toJson());
    print("Processing Payment: $data");

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Payment Processing...')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Payment')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Enter Payment Details",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 20),

              IntlPhoneField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                initialCountryCode: 'KE',
                disableLengthCheck: true,
                onChanged: (phone) {
                  _phoneNumber = phone.completeNumber;
                  print("Current phone number: $_phoneNumber"); // Debug print
                },
                validator: (phone) {
                  if (phone == null) return 'Please enter a phone number';

                  String cleanNumber = phone.completeNumber.replaceAll(RegExp(r'[^\d]'), '');

                  if (cleanNumber.length != 12) {
                    return 'Phone number must be 9 digits after 254';
                  }
                  if (!cleanNumber.startsWith('254')) {
                    return 'Phone number must start with 254';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 12),

              TextFormField(
                controller: _amountController,
                decoration: InputDecoration(
                  prefixText: 'KES ', // Add currency prefix
                  labelText: 'Payment Amount',
                  fillColor: Colors.grey[100], // Light background color
                  filled: true,
                  enabled: false, // Disable editing
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
                style: const TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                ),
                readOnly: true, // Ensure the field is read-only
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitPayment,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  child: const Text('Proceed to Pay'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}