import 'package:flutter/material.dart';

import '/widgets/products_grid_widget.dart';

class ProductsOverviewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Myshop'),
        ),
        body: ProductsGrid(),
      ),
    );
  }
}
