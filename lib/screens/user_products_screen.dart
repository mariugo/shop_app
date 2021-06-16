import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/screens/edit_product_screen.dart';
import '/widgets/drawer_widget.dart';
import '/widgets/user_product_item_widget.dart';
import '/providers/products.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-products-screen';

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Products'),
          actions: [
            IconButton(
              onPressed: () =>
                  Navigator.of(context).pushNamed(EditProductScreen.routeName),
              icon: const Icon(
                Icons.add,
              ),
            ),
          ],
        ),
        drawer: DrawerWidget(),
        body: Padding(
          padding: const EdgeInsets.all(8),
          child: ListView.builder(
            itemCount: productsData.items.length,
            itemBuilder: (_, i) => Column(
              children: [
                UserProductItemWidget(
                  userProductItemTitle: productsData.items[i].title,
                  userProductUrl: productsData.items[i].imageUrl,
                ),
                Divider(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
