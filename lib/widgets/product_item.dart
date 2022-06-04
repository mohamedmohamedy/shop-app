import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/poduct_details_screen.dart';
import '../providers/products.dart';
import '../providers/cart.dart';
import '../providers/auth.dart';

class ProductItem extends StatelessWidget {
  // final String imageUrl;
  // final String title;
  // final String id;

  // ProductItem(
  //   this.id,
  //   this.imageUrl,
  //   this.title,
  // );

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final authData = Provider.of<Auth>(context, listen: false);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: GridTile(
        child: GestureDetector(
          onTap: () => Navigator.of(context).pushNamed(
            ProductDetailsScreen.routeName,
            arguments: product.id,
          ),
          child: Hero(
            tag: product.id,
            child: FadeInImage(
              placeholder: AssetImage('assets/images/product-placeholder.png'),
              image: NetworkImage(product.imageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: Consumer<Product>(
            builder: (context, Product, _) => IconButton(
              icon: Icon(product.isFavourite
                  ? Icons.favorite
                  : Icons.favorite_outline_outlined),
              color: Colors.grey,
              onPressed: () => product.toggleFavouriteStatus(
                  authData.token, authData.userId),
            ),
          ),
          title: Text(product.title),
          trailing: IconButton(
            color: Theme.of(context).colorScheme.secondary,
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              cart.addItem(product.id, product.price, product.title);
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'the Product added to your cart',
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.primary),
                  ),
                  duration: Duration(seconds: 2),
                  action: SnackBarAction(
                    label: 'UNDO',
                    textColor: Colors.red,
                    onPressed: () {
                      cart.removeSingleProduct(product.id);
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
