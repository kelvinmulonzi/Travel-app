import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wanderlust/screens/BookingScreen.dart';

import '../models/Destination.dart';
import '../services/DestinationService.dart';
import '../utils/api_client.dart';
import 'CreateDestinationScreen.dart';
import 'DestinationDetailScreen.dart';

class DestinationsListScreen extends StatefulWidget {
  @override
  _DestinationsListScreenState createState() => _DestinationsListScreenState();
}

class _DestinationsListScreenState extends State<DestinationsListScreen> {
  final DestinationService _destinationService = DestinationService();
  late Future<List<Destination>> _destinations;

  @override
  void initState() {
    super.initState();
    _destinations = _destinationService.getAllDestinations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Travel Destinations'),
      ),
      body: FutureBuilder(
        future: ApiClient().getProducts() ,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final destination = snapshot.data![index];

                return Card(
                  margin: EdgeInsets.all(8),
                  child: ListTile(
                    leading: Image.network(
                      destination["imageUrl"],
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          Icon(Icons.error),
                    ),
                    title: Text( destination["name"]),
                    subtitle: Text( destination["location"]),
                    trailing: Text('\$${ destination["price"]}'),
                    onTap: () {
                      print("snapshot.destination>ll>>>>>>>>${destination}");
Get.to(()=>BookingScreen(),arguments: destination);

                }


                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          return Center(child: CircularProgressIndicator());
        },
      ),

    );
  }
}