import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/widgets/order_item_widget.dart';
import '/providers/orders.dart';
import '/widgets/drawer_widget.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';

  @override
  Widget build(BuildContext context) {
    final ordersData = Provider.of<Orders>(context);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Your Orders'),
        ),
        body: ListView.builder(
          itemBuilder: (ctx, i) => OrderItemWidget(
            ordersData.orders[i],
          ),
          itemCount: ordersData.orders.length,
        ),
        drawer: DrawerWidget(),
      ),
    );
  }
}
