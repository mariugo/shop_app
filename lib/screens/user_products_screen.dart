import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/screens/edit_product_screen.dart';
import '/widgets/drawer_widget.dart';
import '/widgets/user_product_item_widget.dart';
import '/providers/products.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-products-screen';

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false).fetchProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Products'),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(EditProductScreen.routeName);
              },
              icon: const Icon(
                Icons.add,
              ),
            ),
          ],
        ),
        drawer: DrawerWidget(),
        body: FutureBuilder(
          future: _refreshProducts(context),
          builder: (ctx, snapshot) => snapshot.connectionState ==
                  ConnectionState.waiting
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : RefreshIndicator(
                  onRefresh: () => _refreshProducts(ctx),
                  child: Consumer<Products>(
                    builder: (ctx, productsData, _) => Padding(
                      padding: const EdgeInsets.all(8),
                      child: ListView.builder(
                        itemCount: productsData.items.length,
                        itemBuilder: (_, i) => Column(
                          children: [
                            UserProductItemWidget(
                              productId: productsData.items[i].id!,
                              userProductItemTitle: productsData.items[i].title,
                              userProductUrl: productsData.items[i].imageUrl,
                            ),
                            Divider(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
