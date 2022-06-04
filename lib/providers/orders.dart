import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../providers/cart.dart';
import '../models/http_exception.dart';

class OrderItem {
  final String id;
  final DateTime date;
  final List<CartItem> products;
  final double amount;

  OrderItem({
    @required this.amount,
    @required this.date,
    @required this.id,
    @required this.products,
  });
}

class OrderProvider with ChangeNotifier {
  List<OrderItem> _orders = [];
  final String authToken;
  final String userId;

  OrderProvider(this.authToken, this.userId, this._orders);

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> setAndFetchOrders() async {
    final url = Uri.parse(
        'https://shopapp-c7855-default-rtdb.firebaseio.com/Orders/$userId.json?auth=$authToken');
    try {
      final response = await http.get(url);
      final List<OrderItem> uploadedData = [];
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      extractedData.forEach((productId, productData) {
        uploadedData.add(
          OrderItem(
            amount: productData['amount'],
            date: DateTime.parse(productData['date']),
            id: productId,
            products: (productData['product'] as List<dynamic>)
                .map(
                  (e) => CartItem(
                    id: e['id'],
                    price: e['price'],
                    quantity: e['quantity'],
                    title: e['title'],
                  ),
                )
                .toList(),
          ),
        );
      });
      _orders = uploadedData.reversed.toList();
      notifyListeners();
    } catch (error) {
      return;
    }
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final url = Uri.parse(
        'https://shopapp-c7855-default-rtdb.firebaseio.com/Orders/$userId.json?auth=$authToken');
    final timeStamp = DateTime.now();
    final response = await http.post(
      url,
      body: json.encode({
        'amount': total,
        'date': timeStamp.toIso8601String(),
        'products': cartProducts
            .map((e) => {
                  'id': e.id,
                  'title': e.title,
                  'price': e.price,
                  'quantity': e.quantity,
                })
            .toList(),
      }),
    );

    _orders.insert(
      0,
      OrderItem(
        amount: total,
        date: timeStamp,
        id: json.decode(response.body)['name'],
        products: cartProducts,
      ),
    );
    notifyListeners();
  }
}
