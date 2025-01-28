// // lib/screens/create_destination_screen.dart
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:typed_data';
//
// import '../services/DestinationService.dart';
//
// class CreateDestinationScreen extends StatefulWidget {
//   @override
//   _CreateDestinationScreenState createState() => _CreateDestinationScreenState();
// }
//
// class _CreateDestinationScreenState extends State<CreateDestinationScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _destinationService = DestinationService();
//   final ImagePicker _picker = ImagePicker();
//
//   Uint8List? _imageBytes;
//   bool _isLoading = false;
//
//   // Form fields
//   String name = '';
//   String location = '';
//   String description = '';
//   String price = '';
//   String rating = '0.0';
//
//   Future<void> _pickImage() async {
//     try {
//       final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
//       if (image != null) {
//         final bytes = await image.readAsBytes();
//         setState(() {
//           _imageBytes = bytes;
//         });
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to pick image: ${e.toString()}')),
//       );
//     }
//   }
//
//   Future<void> _submitForm() async {
//     if (_formKey.currentState!.validate()) {
//       if (_imageBytes == null) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Please select an image')),
//         );
//         return;
//       }
//
//       _formKey.currentState!.save();
//       setState(() => _isLoading = true);
//
//       try {
//         final destination = Destination(
//           name: name,
//           location: location,
//           description: description,
//           price: price,
//           rating: rating,
//           imageUrl: '', // This will be set by the service
//         );
//
//         await _destinationService.createDestinationWithImage(
//           destination,
//           _imageBytes!,
//         );
//
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Destination created successfully!')),
//         );
//         Navigator.pop(context);
//       } catch (e) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Failed to create destination: ${e.toString()}')),
//         );
//       } finally {
//         setState(() => _isLoading = false);
//       }
//     }
//   }
//
// // ... rest of the build method remains the same as befor
// }