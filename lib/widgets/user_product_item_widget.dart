import 'package:flutter/material.dart';

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
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
              icon: Icon(
                Icons.edit,
              ),
              onPressed: () {},
              color: Colors.orange.shade300,
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
