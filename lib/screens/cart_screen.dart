import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/providers/orders.dart';
import '/providers/cart.dart';
import '/widgets/cart_item_widget.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Your Cart'),
        ),
        body: Container(
          child: Column(children: [
            Card(
              margin: const EdgeInsets.all(15),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total:',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    Spacer(),
                    Chip(
                      label: Text(
                        '\$${cart.totalAmount.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextButton(
                        onPressed: cart.totalAmount <= 0
                            ? null
                            : () {
                                Provider.of<Orders>(
                                  context,
                                  listen: false,
                                ).addOrder(
                                  cart.items.values.toList(),
                                  cart.totalAmount,
                                );
                                cart.clearCart();
                              },
                        child: Text(
                          'ORDER NOW',
                          style: TextStyle(
                            color: Theme.of(context).accentColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
                child: ListView.builder(
              itemBuilder: (ctx, i) => CartItemWidget(
                itemId: cart.items.values.toList()[i].id,
                itemPrice: cart.items.values.toList()[i].price,
                itemQuantity: cart.items.values.toList()[i].quantity,
                itemTitle: cart.items.values.toList()[i].title,
              ),
              itemCount: cart.itemCount,
            ))
          ]),
        ),
      ),
    );
  }
}
