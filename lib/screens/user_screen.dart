import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products_provider.dart';
import '../widgets/user_product_item.dart';
import './edit_product_screen.dart';
import '../widgets/the_drawer.dart';

class UserScreen extends StatelessWidget {
  static const routeName = '/user-screen';
  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<ProductsProvider>(context, listen: false)
        .getAndSetProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    //final productData = Provider.of<ProductsProvider>(context);
    print('revuilding..');
    return Scaffold(
      appBar: AppBar(
        title: Text('Your products'),
        actions: [
          IconButton(
            onPressed: () =>
                Navigator.of(context).pushNamed(EditProductScreen.routeName),
            icon: Icon(Icons.add),
          )
        ],
      ),
      drawer: TheDrawer(),
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (context, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: () => _refreshProducts(context),
                    child: Consumer<ProductsProvider>(
                      builder: (context, productData, _) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView.builder(
                            itemCount: productData.items.length,
                            itemBuilder: (_, index) => UserProductItem(
                                  id: productData.items[index].id,
                                  imageUrl: productData.items[index].imageUrl,
                                  title: productData.items[index].title,
                                )),
                      ),
                    ),
                  ),
      ),
    );
  }
}
