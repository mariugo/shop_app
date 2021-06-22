import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/models/http_exception.dart';

import '/models/product.dart';

class Products with ChangeNotifier {
  //URL FOR POST PRODUCTS
  final url = Uri.parse(
      'https://shop-app-8c4b3-default-rtdb.firebaseio.com/products.json');

  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  List<Product> get items => [..._items];

  List<Product> get favoriteItems {
    return _items.where((productItem) => productItem.isFavorite).toList();
  }

  Product findById(String? id) {
    return _items.firstWhere((product) => product.id == id);
  }

  Future<void> fetchProducts() async {
    try {
      final response = await http.get(url);

      final extractedResponse =
          json.decode(response.body) as Map<String, dynamic>;

      final List<Product> loadedProducts = [];

      if (extractedResponse.isEmpty) {
        return;
      }

      extractedResponse.forEach((productId, productData) {
        loadedProducts.add(
          Product(
            id: productId,
            title: productData['title'],
            description: productData['description'],
            price: productData['price'],
            imageUrl: productData['imageUrl'],
            isFavorite: productData['isFavorite'],
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
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'title': product.title,
            'description': product.description,
            'price': product.price,
            'imageUrl': product.imageUrl,
            'isFavorite': product.isFavorite,
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
            'https://shop-app-8c4b3-default-rtdb.firebaseio.com/products/$id.json');
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
          'https://shop-app-8c4b3-default-rtdb.firebaseio.com/products/$id.json');
      await http.delete(deleteUrl);
      _items.removeWhere((product) => product.id == id);
      notifyListeners();
    } on HttpException catch (error) {
      throw error;
    }
  }
}
