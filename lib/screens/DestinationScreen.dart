import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wanderlust/screens/BookingScreen.dart';

import '../models/Destination.dart';
import '../services/DestinationService.dart';
import '../services/WishlistService.dart';
import '../utils/api_client.dart';

class DestinationsListScreen extends StatefulWidget {
  @override
  _DestinationsListScreenState createState() => _DestinationsListScreenState();
}

class _DestinationsListScreenState extends State<DestinationsListScreen> {
  final DestinationService _destinationService = DestinationService();
  final TextEditingController _searchController = TextEditingController();
  late Future<List<Destination>> _destinations;
  List<dynamic> _allDestinations = [];
  List<dynamic> _filteredDestinations = [];
  final WishlistService _wishlistService = WishlistService();
  Map<String, bool> _wishlistStatus = {};

  @override
  void initState() {
    super.initState();
    _loadDestinations();
    _searchController.addListener(_filterDestinations);
    // Initialize wishlist status for all destinations
    _loadDestinations().then((_) {
      for (var destination in _allDestinations) {
        _updateWishlistStatus(destination['id'].toString());
      }
    });
  }

  Future<void> _updateWishlistStatus(String destinationId) async {
    final isInWishlist = await _wishlistService.isInWishlist(destinationId);
    setState(() {
      _wishlistStatus[destinationId] = isInWishlist;
    });
  }

  Future<void> _loadDestinations() async {
    var destinations = await ApiClient().getProducts();
    setState(() {
      _allDestinations = destinations;
      _filteredDestinations = destinations;
    });
  }

  void _filterDestinations() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _filteredDestinations = _allDestinations
          .where((destination) =>
      destination["name"].toLowerCase().contains(query) ||
          destination["location"].toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Travel Destinations'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Search destinations...",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
          Expanded(
            child: _filteredDestinations.isEmpty
                ? Center(child: Text('No destinations found.'))
                : LayoutBuilder(
              builder: (context, constraints) {
                int crossAxisCount = constraints.maxWidth > 600 ? 4 : 2;

                return GridView.builder(
                  padding: EdgeInsets.all(8),
                  itemCount: _filteredDestinations.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 0.75,
                  ),
                  itemBuilder: (context, index) {
                    final destination = _filteredDestinations[index];

                    return GestureDetector(
                      onTap: () {
                        Get.to(() => BookingScreen(), arguments: destination);
                      },
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Stack(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                                    child: Image.network(
                                      destination["imageUrl"],
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) =>
                                          Icon(Icons.error, size: 48),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        destination["name"],
                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                      ),
                                      SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Icon(Icons.location_on, color: Colors.grey[600], size: 16),
                                          const SizedBox(width: 4),
                                          Text(
                                            destination["location"],
                                            style: Theme.of(context).textTheme.bodyLarge,
                                          ),
                                        ],
                                      ),
                                      Text(
                                        destination["description"],
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(color: Colors.grey[600]),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        '\Kes${destination["price"]}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.green),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            // Wishlist button overlay
                            Positioned(
                              top: 8,
                              right: 8,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.8),
                                  shape: BoxShape.circle,
                                ),
                                child: IconButton(
                                  icon: Icon(
                                    _wishlistStatus[destination['id'].toString()] ?? false
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: Colors.red,
                                  ),
                                  onPressed: () async {
                                    final prefs = await SharedPreferences.getInstance();
                                    List<String> wishlist = prefs.getStringList('wishlist_items') ?? [];

                                    setState(() {
                                      if (wishlist.contains(destination['id'].toString())) {
                                        wishlist.remove(destination['id'].toString());
                                      } else {
                                        wishlist.add(destination['id'].toString());
                                      }
                                    });

                                    await prefs.setStringList('wishlist_items', wishlist);
                                    _updateWishlistStatus(destination['id'].toString());

                                    // Show feedback to user
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          wishlist.contains(destination['id'].toString())
                                              ? 'Added to wishlist'
                                              : 'Removed from wishlist',
                                        ),
                                        duration: Duration(seconds: 1),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}