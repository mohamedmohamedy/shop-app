import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final double price;
  bool isFavourite;

  Product({
    @required this.id,
    @required this.description,
    @required this.imageUrl,
    @required this.price,
    @required this.title,
    this.isFavourite = false,
  });

  void _setFavValue(bool newValue) {
    isFavourite = newValue;
    notifyListeners();
  }

  Future<void> toggleFavouriteStatus(String Token, String userId) async {
    final oldstatus = isFavourite;
    isFavourite = !isFavourite;
    notifyListeners();

    final url = Uri.parse(
        'https://shopapp-c7855-default-rtdb.firebaseio.com/UserFavourites/$userId/$id.json?auth=$Token');
    try {
      final response = await http.put(
        url,
        body: json.encode(isFavourite),
      );
      if (response.statusCode >= 400) {
        _setFavValue(oldstatus);
      }
    } catch (error) {
      _setFavValue(oldstatus);
    }
  }
}
