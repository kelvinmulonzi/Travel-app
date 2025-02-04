import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/Booking.dart';
import '../utils/api_client.dart';
import '../models/Destination.dart';
import 'PaymentScreen.dart';

class BookingScreen extends StatefulWidget {
  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _amountController;
  late TextEditingController _dateController;  // Controller for the date field
  bool _isLoading = false;
  final ApiClient _apiClient = ApiClient();
  var destination = Get.arguments;



  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController();
    _dateController = TextEditingController();  // Initialize the date controller
  }

  @override
  void dispose() {
    //_amountController.dispose();
    _dateController.dispose();  // Dispose the date controller
    super.dispose();
  }
 void createBooking() async {

    setState(() {
      _isLoading = true;
    });

    try {
      final booking = BookingRequest(
        destinationId: destination["id"],
        amount: destination["price"],
        location: destination["location"],
        date: _dateController.text,
      );
      print("Booking>>>>>>>>> ${booking.toJson()}");
      await _apiClient.createBooking(booking.toJson());
    } catch (e) {
      print('Error creating booking: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
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
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                      child: Image.network(
                        destination["imageUrl"],
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Icon(Icons.error),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                          const SizedBox(height: 8),
                          Text(
                            'Price: ${destination["price"]}',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ],
                      ),
                    ),
                  ],
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
                  //print("snapshot.destination>ll>>>>>>>>${destination}");
                  createBooking();
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
}