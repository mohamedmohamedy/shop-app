import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';
import '../providers/products_provider.dart';

import '../screens/cart_screen.dart';

import '../widgets/products_gridview_builder.dart';
import '../widgets/badge.dart';
import '../widgets/the_drawer.dart';

enum filterOptions { favoritesOnly, all }

class ProductsOverViewScreen extends StatefulWidget {
  @override
  State<ProductsOverViewScreen> createState() => _ProductsOverViewScreenState();
}

class _ProductsOverViewScreenState extends State<ProductsOverViewScreen> {
  bool _favouriteSelected = false;
  bool _isInit = true;
  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<ProductsProvider>(context).getAndSetProducts().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MY SHOP'),
        actions: [
          PopupMenuButton(
            itemBuilder: (_) => [
              PopupMenuItem(
                  child: Text('Only favourites'),
                  value: filterOptions.favoritesOnly),
              PopupMenuItem(child: Text('Show all'), value: filterOptions.all),
            ],
            onSelected: (filterOptions value) {
              setState(() {
                if (value == filterOptions.favoritesOnly) {
                  _favouriteSelected = true;
                } else {
                  _favouriteSelected = false;
                }
              });
            },
            icon: Icon(Icons.more_vert),
          ),
          Consumer<Cart>(
            builder: (_, cart, ch) => Badge(
              child: ch,
              value: cart.itemsCount.toString(),
            ),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          ),
        ],
      ),
      drawer: TheDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ProductsGridViewBuilder(_favouriteSelected),
    );
  }
}
