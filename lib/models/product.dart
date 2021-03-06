import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import '/models/http_exception.dart';

class Product with ChangeNotifier {
  final String? id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false,
  });

  void _setFavoritesValue(bool newValue) {
    isFavorite = newValue;
    notifyListeners();
  }

  Future<void> toggleFavorite(String authToken, String userId) async {
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    final url = Uri.parse(
        'https://shop-app-8c4b3-default-rtdb.firebaseio.com/userFavorites/$userId/$id.json?auth=$authToken');
    try {
      final response = await http.put(
        url,
        body: json.encode(
          {
            isFavorite,
          },
        ),
      );
      if (response.statusCode >= 400) {
        _setFavoritesValue(oldStatus);
      }
    } on HttpException catch (_) {
      _setFavoritesValue(oldStatus);
    }
  }
}
