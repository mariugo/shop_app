import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/widgets/order_item_widget.dart';
import '/providers/orders.dart';
import '/widgets/drawer_widget.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = '/orders';

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  Future? _ordersFuture;

  Future _getOrdersFuture() =>
      Provider.of<Orders>(context, listen: false).fetchOrders();

  @override
  void initState() {
    _ordersFuture = _getOrdersFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Your Orders'),
        ),
        body: FutureBuilder(
          future: _ordersFuture,
          builder: (ctx, dataSnapshot) {
            if (dataSnapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (dataSnapshot.error != null) {
                return Center(
                  child: Text(
                    'An error occurred ' + dataSnapshot.error.toString(),
                  ),
                );
              } else {
                return Consumer<Orders>(
                  builder: (ctx, ordersData, ch) => ListView.builder(
                    itemBuilder: (ctx, i) => OrderItemWidget(
                      ordersData.orders[i],
                    ),
                    itemCount: ordersData.orders.length,
                  ),
                );
              }
            }
          },
        ),
        drawer: DrawerWidget(),
      ),
    );
  }
}
