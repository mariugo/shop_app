import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/providers/cart.dart';
import '/screens/cart_screen.dart';
import '/widgets/drawer_widget.dart';
import '/widgets/products_grid_widget.dart';
import '/widgets/cart_badge_widget.dart';

enum FilterOptions {
  Favorites,
  All,
}

class ProductsOverviewScreen extends StatefulWidget {
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  bool _showOnlyFavoritesProducts = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Myshop'),
          actions: [
            PopupMenuButton(
              onSelected: (FilterOptions selectedOption) {
                setState(() {
                  if (selectedOption == FilterOptions.Favorites) {
                    _showOnlyFavoritesProducts = true;
                  } else {
                    _showOnlyFavoritesProducts = false;
                  }
                });
              },
              icon: Icon(
                Icons.more_vert,
              ),
              itemBuilder: (_) => [
                PopupMenuItem(
                  child: Text('Favorites'),
                  value: FilterOptions.Favorites,
                ),
                PopupMenuItem(
                  child: Text('Show All'),
                  value: FilterOptions.All,
                ),
              ],
            ),
            Consumer<Cart>(
              builder: (_, cart, ch) => Badge(
                child: ch,
                value: cart.itemCount.toString(),
              ),
              child: IconButton(
                icon: Icon(
                  Icons.shopping_cart,
                ),
                onPressed: () {
                  Navigator.of(context).pushNamed(CartScreen.routeName);
                },
              ),
            ),
          ],
        ),
        drawer: DrawerWidget(),
        body: ProductsGrid(_showOnlyFavoritesProducts),
      ),
    );
  }
}
