import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './product_item.dart';
import '../providers/products_provider.dart';

class ProductsGridViewBuilder extends StatelessWidget {
  final bool showFavourites;

  ProductsGridViewBuilder(this.showFavourites);

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<ProductsProvider>(context);
    final products =
        showFavourites ? productsData.favouriteItems : productsData.items;

    return GridView.builder(
      itemCount: products.length,
      padding: EdgeInsets.all(10.0),
      itemBuilder: (context, index) => ChangeNotifierProvider.value(
        value: products[index],
        child: ProductItem(
            // products[index].id,
            // products[index].imageUrl,
            // products[index].title,
            ),
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        childAspectRatio: 3 / 2,
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
    );
  }
}
