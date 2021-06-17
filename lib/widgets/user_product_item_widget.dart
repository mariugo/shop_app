import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/providers/products.dart';
import '/screens/edit_product_screen.dart';

class UserProductItemWidget extends StatelessWidget {
  final String productId;
  final String userProductItemTitle;
  final String userProductUrl;

  UserProductItemWidget({
    required this.productId,
    required this.userProductItemTitle,
    required this.userProductUrl,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        userProductItemTitle,
      ),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(
          userProductUrl,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 8),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
              icon: Icon(
                Icons.edit,
              ),
              onPressed: () => Navigator.of(context).pushNamed(
                EditProductScreen.routeName,
                arguments: productId,
              ),
              color: Colors.orange.shade300,
            ),
            SizedBox(
              width: 10,
            ),
            IconButton(
              icon: Icon(
                Icons.delete,
              ),
              onPressed: () => Provider.of<Products>(context, listen: false)
                  .deleteProduct(productId),
              color: Theme.of(context).errorColor,
            ),
          ],
        ),
      ),
    );
  }
}
