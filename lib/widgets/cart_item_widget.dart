import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/providers/cart.dart';

class CartItemWidget extends StatelessWidget {
  final String itemId;
  final String itemTitle;
  final double itemPrice;
  final int itemQuantity;

  CartItemWidget({
    required this.itemId,
    required this.itemTitle,
    required this.itemPrice,
    required this.itemQuantity,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(itemId),
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete_outline,
          color: Colors.white,
          size: 30,
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text(
              'Are you sure?',
            ),
            content: Text(
              'Do you want to remove this item?',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop(false);
                },
                child: Text('No'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop(true);
                },
                child: Text('Yes'),
              ),
            ],
          ),
        );
      },
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).removeItem(itemId);
      },
      child: Card(
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            leading: CircleAvatar(
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: FittedBox(
                  child: Text(
                    '\$$itemPrice',
                  ),
                ),
              ),
            ),
            title: Text(
              itemTitle,
            ),
            subtitle: Text(
              'Total: \$${(itemPrice * itemQuantity)}',
            ),
            trailing: Text('$itemQuantity x'),
          ),
        ),
      ),
    );
  }
}
