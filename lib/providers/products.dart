import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/models/http_exception.dart';

import '/models/product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [];
  final String authToken;
  final String userId;

  Products(
    this.authToken,
    this.userId,
  );

  List<Product> get items => [..._items];

  List<Product> get favoriteItems {
    return _items.where((productItem) => productItem.isFavorite).toList();
  }

  Product findById(String? id) {
    return _items.firstWhere((product) => product.id == id);
  }

  Future<void> fetchProducts([bool filterByUser = false]) async {
    final filterString =
        filterByUser ? 'orderBy="userId"&equalTo="$userId"' : '';

    var url = Uri.parse(
        'https://shop-app-8c4b3-default-rtdb.firebaseio.com/products.json?auth=$authToken&$filterString');
    try {
      final response = await http.get(url);

      final extractedResponse =
          json.decode(response.body) as Map<String, dynamic>;

      final List<Product> loadedProducts = [];

      if (extractedResponse.isEmpty) {
        return;
      }
      url = Uri.parse(
          'https://shop-app-8c4b3-default-rtdb.firebaseio.com/userFavorites/$userId.json?auth=$authToken');

      final favoriteResponse = await http.get(url);
      final favoriteResponseData = json.decode(favoriteResponse.body);

      extractedResponse.forEach((productId, productData) {
        loadedProducts.add(
          Product(
            id: productId,
            title: productData['title'],
            description: productData['description'],
            price: productData['price'],
            imageUrl: productData['imageUrl'],
            isFavorite: favoriteResponseData == null
                ? false
                : favoriteResponseData[productId] ?? false,
          ),
        );
      });
      _items = loadedProducts;
      notifyListeners();
    } on HttpException catch (error) {
      throw error;
    }
  }

  Future<void> addProduct(Product product) async {
    final url = Uri.parse(
        'https://shop-app-8c4b3-default-rtdb.firebaseio.com/products.json?auth=$authToken');
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'title': product.title,
            'description': product.description,
            'price': product.price,
            'imageUrl': product.imageUrl,
            'userId': userId,
          },
        ),
      );
      final newProduct = Product(
        id: json.decode(response.body)['name'],
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
      );
      _items.add(newProduct);
      notifyListeners();
    } on HttpException catch (error) {
      throw error;
    }
  }

  Future<void> updateUproduct(String id, Product newUpdatedProduct) async {
    try {
      final productIndex = _items.indexWhere((product) => product.id == id);
      if (productIndex >= 0) {
        final updateUrl = Uri.parse(
            'https://shop-app-8c4b3-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken');
        await http.patch(
          updateUrl,
          body: {
            'title': newUpdatedProduct.title,
            'description': newUpdatedProduct.description,
            'price': newUpdatedProduct.price,
            'imageUrl': newUpdatedProduct.imageUrl,
          },
        );
        _items[productIndex] = newUpdatedProduct;
        notifyListeners();
      }
    } on HttpException catch (error) {
      throw error;
    }
  }

  Future<void> deleteProduct(String id) async {
    try {
      final deleteUrl = Uri.parse(
          'https://shop-app-8c4b3-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken');
      await http.delete(deleteUrl);
      _items.removeWhere((product) => product.id == id);
      notifyListeners();
    } on HttpException catch (error) {
      throw error;
    }
  }
}
