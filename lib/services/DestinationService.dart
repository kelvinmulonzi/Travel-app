import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/Destination.dart';

class DestinationService {
  final String baseUrl = 'https://259b-41-220-228-218.ngrok-free.app';

  Future<List<Destination>> getAllDestinations() async {
    final response = await http.get(Uri.parse('$baseUrl/all'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> destinations = data['data'];
      return destinations.map((json) => Destination.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load destinations');
    }
  }

  Future<Destination> getDestinationById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return Destination.fromJson(data['data']);
    } else {
      throw Exception('Failed to load destination');
    }
  }

  Future<Destination> createDestination(Destination destination) async {
    final response = await http.post(
      Uri.parse('$baseUrl/create'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(destination.toJson()),
    );

    if (response.statusCode == 201) {
      final Map<String, dynamic> data = json.decode(response.body);
      return Destination.fromJson(data['data']);
    } else {
      throw Exception('Failed to create destination');
    }
  }
}
