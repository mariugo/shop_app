import 'package:flutter/material.dart';
import 'package:shop_app/screens/edit_product_screen.dart';

class UserProductItemWidget extends StatelessWidget {
  final String userProductItemTitle;
  final String userProductUrl;

  UserProductItemWidget({
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
              onPressed: () =>
                  Navigator.of(context).pushNamed(EditProductScreen.routeName),
              color: Colors.orange.shade300,
            ),
            SizedBox(
              width: 10,
            ),
            IconButton(
              icon: Icon(
                Icons.delete,
              ),
              onPressed: () {},
              color: Theme.of(context).errorColor,
            ),
          ],
        ),
      ),
    );
  }
}
