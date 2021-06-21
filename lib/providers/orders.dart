import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/models/http_exception.dart';

import '/providers/cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    required this.id,
    required this.amount,
    required this.products,
    required this.dateTime,
  });
}

final url =
    Uri.parse('https://shop-app-8c4b3-default-rtdb.firebaseio.com/orders.json');

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders => [..._orders];

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final dateTime = DateTime.now();
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'amount': total,
          'products': cartProducts
              .map((cart) => {
                    'id': cart.id,
                    'title': cart.title,
                    'quantity': cart.quantity,
                    'price': cart.price,
                  })
              .toList(),
          'dateTime': DateTime.now().toIso8601String(),
        }),
      );
      final newOrderItem = OrderItem(
        id: json.decode(response.body)['name'],
        amount: total,
        products: cartProducts,
        dateTime: dateTime,
      );
      _orders.insert(0, newOrderItem);
      notifyListeners();
    } on HttpException catch (error) {
      throw error;
    }
  }
}
