import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import './products.dart';
import '../models/http_exception.dart';

class ProductsProvider with ChangeNotifier {
  final String authToken;
  final String userId;

  ProductsProvider(this.authToken, this.userId, this._items);

  List<Product> _items = [
    Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    Product(
      id: 'p3',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl:
          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    Product(
      id: 'p4',
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ),
  ];

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favouriteItems {
    return _items.where((element) => element.isFavourite).toList();
  }

  Product findById(String Id) {
    return _items.firstWhere((product) => product.id == Id);
  }

  Future<void> getAndSetProducts([bool filterByUser = false]) async {
    final filterString =
        filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    var url = Uri.parse(
        'https://shopapp-c7855-default-rtdb.firebaseio.com/ProductsProvider.json?auth=$authToken&$filterString');
    try {
      final response = await http.get(url);
      final fetchedDate = jsonDecode(response.body) as Map<String, dynamic>;
      if (fetchedDate == null) {
        return;
      }
      url = Uri.parse(
          'https://shopapp-c7855-default-rtdb.firebaseio.com/UserFavourites/$userId.json?auth=$authToken');
      final favouriteResponse = await http.get(url);
      final favouriteData = json.decode(favouriteResponse.body);
      final List<Product> updatedData = [];
      fetchedDate.forEach((prodId, prodData) {
        updatedData.add(
          Product(
            id: prodId,
            description: prodData['description'],
            imageUrl: prodData['imageUrl'],
            price: prodData['price'],
            title: prodData['title'],
            isFavourite:
                favouriteData == null ? false : favouriteData[prodId] ?? false,
          ),
        );
      });
      _items = updatedData;
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future addProduct(Product product) async {
    try {
      final url = Uri.parse(
          'https://shopapp-c7855-default-rtdb.firebaseio.com/ProductsProvider.json?auth=$authToken');
      final response = await http.post(
        url,
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'imageUrl': product.imageUrl,
          'price': product.price,
          'creatorId': userId,
        }),
      );
      final newProduct = Product(
        id: json.decode(response.body)['name'],
        description: product.description,
        imageUrl: product.imageUrl,
        price: product.price,
        title: product.title,
      );

      _items.add(newProduct);

      //_items.insert(0, product) --> to insert in  the top of the list.

      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final productIndex = _items.indexWhere((product) => product.id == id);
    if (productIndex >= 0) {
      final url = Uri.parse(
          'shopapp-c7855-default-rtdb.firebaseio.com/ProductsProvider/$id.json?auth=$authToken');
      await http.patch(url,
          body: json.encode({
            'description': newProduct.description,
            'title': newProduct.title,
            'price': newProduct.price,
            'imageUrl': newProduct.imageUrl,
          }));
      _items[productIndex] = newProduct;
      notifyListeners();
    }
  }

  Future<void> deleteProduct(String id) async {
    final url = Uri.parse(
        'shopapp-c7855-default-rtdb.firebaseio.com/ProductsProvider/$id.json?auth=$authToken');
    final exisitingItemIndex = _items.indexWhere((product) => product.id == id);
    var exisitingItem = _items[exisitingItemIndex];
    _items.removeAt(exisitingItemIndex);
    notifyListeners();

    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(exisitingItemIndex, exisitingItem);
      notifyListeners();

      throw HttpException('Deleting failed!');
    }
    exisitingItem = null;
  }
}
