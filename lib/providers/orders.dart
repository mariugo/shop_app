import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '/models/http_exception.dart';
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

class Orders with ChangeNotifier {
  final String authToken;
  List<OrderItem> _orders = [];

  Orders(this.authToken);

  List<OrderItem> get orders => [..._orders];

  Future<void> fetchOrders() async {
    try {
      final url = Uri.parse(
          'https://shop-app-8c4b3-default-rtdb.firebaseio.com/orders.json?auth=$authToken');
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;

      final List<OrderItem> loadedOrders = [];
      if (extractedData.isEmpty) {
        return;
      }
      extractedData.forEach((orderId, orderData) {
        loadedOrders.add(
          OrderItem(
            id: orderId,
            amount: orderData['amount'],
            dateTime: DateTime.parse(orderData['dateTime']),
            products: (orderData['products'] as List<dynamic>)
                .map(
                  (cartItem) => CartItem(
                    id: cartItem['id'],
                    title: cartItem['title'],
                    quantity: cartItem['quantity'],
                    price: cartItem['price'],
                  ),
                )
                .toList(),
          ),
        );
      });
      _orders = loadedOrders.reversed.toList();
      notifyListeners();
    } catch (error) {}
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final url = Uri.parse(
        'https://shop-app-8c4b3-default-rtdb.firebaseio.com/orders.json?auth=$authToken');
    final dateTime = DateTime.now();
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'amount': total,
          'dateTime': dateTime.toIso8601String(),
          'products': cartProducts
              .map(
                (cart) => {
                  'id': cart.id,
                  'title': cart.title,
                  'quantity': cart.quantity,
                  'price': cart.price,
                },
              )
              .toList(),
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
