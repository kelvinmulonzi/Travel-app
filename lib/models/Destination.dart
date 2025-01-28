
import 'package:flutter/material.dart';
class Destination {
  final int? id;
  final String name;
  final String location;
  final String description;
  final String imageUrl;
  final String price;
  final String rating;

  Destination({
    this.id,
    required this.name,
    required this.location,
    required this.description,
    required this.imageUrl,
    required this.price,
    required this.rating,
  });

  factory Destination.fromJson(Map<String, dynamic> json) {
    return Destination(
      id: json['id'],
      name: json['name'],
      location: json['location'],
      description: json['description'],
      imageUrl: json['imageUrl'],
      price: json['price'],
      rating: json['rating'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'description': description,
      'imageUrl': imageUrl,
      'price': price,
      'rating': rating,
    };
  }
}