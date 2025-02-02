import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/Booking.dart';
import '../utils/api_client.dart';
import '../models/Destination.dart';
import 'PaymentScreen.dart';

class BookingScreen extends GetView {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _amountController;
  late TextEditingController _dateController;  // Controller for the date field
  bool _isLoading = false;
  final ApiClient _apiClient = ApiClient();
  var destination = Get.arguments;

  @override
  Widget build(BuildContext context) {
    print("snapshot.BookingScreen>>>>>>>>> ${destination}");
    return Scaffold(
      appBar: AppBar(
        title: Text('Book ${destination["name"]}'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Destination Details Card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.network(
                        destination["imageUrl"],
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Icon(Icons.error),
                      ),
                      Text(
                        destination["name"],
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Location: ${destination["location"]}',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      if (destination["description"] != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          destination["description"]!,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                      Text(
                        'price: ${destination["price"]}',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Date Selection
              TextFormField(
                controller: _dateController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Select Date',
                  hintText: 'Tap to select a date',
                  suffixIcon: Icon(Icons.calendar_today),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onTap: () async {
                  final DateTime? selectedDate = await _selectDate(context);
                  if (selectedDate != null) {
                    _dateController.text =
                    "${selectedDate.toLocal()}".split(' ')[0]; // Format: yyyy-mm-dd
                  }
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a date';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 24),

              ElevatedButton(
                // onPressed: _isLoading ? null : _createBooking,
                onPressed: () {
                  print("snapshot.destination>ll>>>>>>>>${destination}");
                  Get.to(() => PaymentScreen(), arguments: destination);
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: _isLoading
                    ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
                    : const Text(
                  'Proceed To Booking',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<DateTime?> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    return picked;
  }

// Future<void> _createBooking() async {
//   if (!_formKey.currentState!.validate()) return;
//
//   setState(() => _isLoading = true);
//
//   try {
//     final bookingRequest = BookingRequest(
//       destinationId: widget.destination.id!,
//       amount: _amountController.text,
//       location: widget.destination.location,
//     );
//
//     await _apiClient.createBooking(bookingRequest.toJson());
//
//     if (!mounted) return;
//
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('Booking created successfully!')),
//     );
//
//     Navigator.pop(context);
//   } catch (e) {
//     if (!mounted) return;
//
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('Error creating booking: $e')),
//     );
//   } finally {
//     if (mounted) {
//       setState(() => _isLoading = false);
//     }
//   }
// }

// @override
// void dispose() {
//   _amountController.dispose();
//   super.dispose();
// }

}