import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String title;
  final double price;
  final int quantity;

  CartItem({
    @required this.id,
    @required this.price,
    @required this.quantity,
    @required this.title,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemsCount {
    return _items.length;
  }

  double get totalAmount {
    double total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total.floorToDouble();
  }

  void addItem(String productId, double price, String title) {
    if (_items.containsKey(productId)) {
      //increase the quantity..
      _items.update(
        productId,
        (exisitingProduct) => CartItem(
          id: exisitingProduct.id,
          price: exisitingProduct.price,
          quantity: exisitingProduct.quantity + 1,
          title: exisitingProduct.title,
        ),
      );
    } else {
      _items.putIfAbsent(
        productId,
        () => CartItem(
          id: DateTime.now().toString(),
          price: price,
          quantity: 1,
          title: title,
        ),
      );
    }
    notifyListeners();
  }

  void deleteItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }

  void removeSingleProduct(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    }

    if (_items[productId].quantity > 1) {
      _items.update(
        productId,
        (exisitingProduct) => CartItem(
          id: exisitingProduct.id,
          price: exisitingProduct.price,
          quantity: exisitingProduct.quantity - 1,
          title: exisitingProduct.title,
        ),
      );
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }
}
