import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class WishlistService {
  static const String _storageKey = 'wishlist_items';

  Future<List<String>> getWishlistItems() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_storageKey) ?? [];
  }

  Future<void> toggleWishlistItem(String destinationId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> wishlist = await getWishlistItems();

    if (wishlist.contains(destinationId)) {
      wishlist.remove(destinationId);
    } else {
      wishlist.add(destinationId);
    }

    await prefs.setStringList(_storageKey, wishlist);
  }

  Future<bool> isInWishlist(String destinationId) async {
    final wishlist = await getWishlistItems();
    return wishlist.contains(destinationId);
  }
}