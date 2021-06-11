import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '/providers/orders.dart';

class OrderItemWidget extends StatefulWidget {
  final OrderItem order;

  OrderItemWidget(this.order);

  @override
  _OrderItemWidgetState createState() => _OrderItemWidgetState();
}

class _OrderItemWidgetState extends State<OrderItemWidget> {
  var _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            title: Text('\$${widget.order.amount}'),
            subtitle: Text(
              DateFormat('dd/MM/yyyy hh:mm').format(widget.order.dateTime),
            ),
            trailing: IconButton(
              icon: Icon(
                _isExpanded ? Icons.expand_less : Icons.expand_more,
              ),
              onPressed: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
            ),
          ),
          if (_isExpanded)
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 4,
              ),
              height: min(widget.order.products.length * 20 + 15, 100),
              child: ListView(
                children: widget.order.products
                    .map(
                      (orderItem) => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            orderItem.title,
                            style: TextStyle(fontSize: 18),
                          ),
                          Text(
                            '\$${orderItem.quantity} x \$${orderItem.price}',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    )
                    .toList(),
              ),
            ),
        ],
      ),
    );
  }
}
