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

  void _submitPayment() async {
    if (!_formKey.currentState!.validate()) return;

    String phoneNumber = _phoneController.text.trim();




    // Assuming bookingId is retrieved dynamically
    int bookingId = 123;

    Payment payment = Payment(
      phoneNumber: phoneNumber,
      amount: double.parse(amount),
      bookingId: bookingId,
    );

    final data = await ApiClient().makePayment(payment.toJson());
    print("Processing Payment: $data");

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Payment Processing...')),
    );
  }

  @override
  Widget build(BuildContext context) {
    print("snapshot.destination>ll>>>>>>>>${destination}");
    amount = destination["price"];
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
                onChanged: (phone) {
                  print(phone.completeNumber);

                  return null;
                },
              ),

              const SizedBox(height: 12),

              TextFormField(
                controller: _amountController,
                decoration: InputDecoration(hintText:  amount.toString(),

                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),

                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || double.tryParse(value) == null || double.parse(value) <= 0) {
                    return 'Enter a valid amount';
                  }
                  return null;
                },
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
