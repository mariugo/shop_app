import 'package:flutter/material.dart';

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
          Icons.delete,
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
      onDismissed: (direction) {},
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
