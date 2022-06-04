import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/edit_product_screen.dart';
import '../providers/products_provider.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String imageUrl;
  final String title;

  UserProductItem({
    @required this.id,
    @required this.imageUrl,
    @required this.title,
  });
  @override
  Widget build(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      title: Text(title),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
              onPressed: () => Navigator.of(context)
                  .pushNamed(EditProductScreen.routeName, arguments: id),
              icon: Icon(
                Icons.edit,
              ),
            ),
            IconButton(
                onPressed: () async {
                  try {
                    await Provider.of<ProductsProvider>(context, listen: false)
                        .deleteProduct(id);
                  } catch (error) {
                    scaffold.showSnackBar(SnackBar(
                      content: Text(
                        'Deleting failed!',
                        textAlign: TextAlign.center,
                      ),
                    ));
                  }
                },
                icon: Icon(Icons.delete),
                color: Theme.of(context).errorColor),
          ],
        ),
      ),
    );
  }
}
