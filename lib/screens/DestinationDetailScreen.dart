//
// import 'package:flutter/material.dart';
//
// import '../models/Destination.dart';
// class DestinationDetailScreen extends StatelessWidget {
//   final Destination destination;
//
//   const DestinationDetailScreen({Key? key, required this.destination})
//       : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(destination.name),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Image.network(https://drive.google.com/file/d/1-S3-IeGgl1ROn8whiojNZWBM6coAxfx8/view?usp=sharing
//             https://drive.google.com/file/d//view?usp=sharing
//             "https://drive.google.com/uc?export=download&id=1twXO9SdeK17IGzhmxrzfyjBfNk2qHzRVB3Rh0wYu9U0",
//               https://drive.google.com/uc?export=download&id=1eRFq0L5U9fDB7iCfJyyK8YM9Uld1Gino
//               height: 200,
//               width: double.infinity,
//               fit: BoxFit.cover,
//               errorBuilder: (context, error, stackTrace) => Icon(Icons.error),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         destination.location,
//                         style: TextStyle(fontSize: 18, color: Colors.grey[600]),
//                       ),
//                       Row(
//                         children: [
//                           Icon(Icons.star, color: Colors.amber),
//                           Text(destination.rating),
//                         ],
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 16),
//                   Text(
//                     '\$${destination.price}',
//                     style: TextStyle(
//                       fontSize: 24,
//                       fontWeight: FontWeight.bold,
//                       color: Theme.of(context).primaryColor,
//                     ),
//                   ),
//                   SizedBox(height: 16),
//                   Text(
//                     destination.description,
//                     style: TextStyle(fontSize: 16),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }