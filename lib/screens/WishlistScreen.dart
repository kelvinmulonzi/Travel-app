import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/WishlistService.dart';
import '../utils/api_client.dart';
import 'BookingScreen.dart';

class WishlistScreen extends StatefulWidget {
  @override
  _WishlistScreenState createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  final WishlistService _wishlistService = WishlistService();
  List<dynamic> _wishlistItems = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadWishlistItems();
  }

  Future<void> _loadWishlistItems() async {
    setState(() => _isLoading = true);
    final wishlistIds = await _wishlistService.getWishlistItems();
    final allDestinations = await ApiClient().getProducts();

    setState(() {
      _wishlistItems = allDestinations.where(
              (dest) => wishlistIds.contains(dest['id'].toString())
      ).toList();
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Wishlist'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _wishlistItems.isEmpty
          ? Center(child: Text('Your wishlist is empty'))
          : ListView.builder(
        itemCount: _wishlistItems.length,
        itemBuilder: (context, index) {
          final destination = _wishlistItems[index];
          return ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                destination['imageUrl'],
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
            ),
            title: Text(destination['name']),
            subtitle: Text(destination['location']),
            trailing: Text('\Kes${destination['price']}'),
            onTap: () => Get.to(() => BookingScreen(), arguments: destination),
          );
        },
      ),
    );
  }
}