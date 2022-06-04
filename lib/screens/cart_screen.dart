import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart' show Cart;
import '../providers/orders.dart';
import '../widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cartScreen';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(title: Text('Your cart')),
      body: Column(
        children: [
          //...........................TOTAL CART COMPONENTS..................//
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //..............................TITLE.......................//
                  Text(
                    'Total',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  Spacer(),
                  //............................TOTAL PRICE...................//
                  Chip(
                    label: Text(
                      '\$${cart.totalAmount}',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  //...........................ORDER BUTTON...................//
                  OrderButton(cart: cart),
                  //..........................................................//
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
          //....................CARTS PRODUCTS................................//
          Expanded(
            child: ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (context, index) => CartItem(
                id: cart.items.values.toList()[index].id,
                price: cart.items.values.toList()[index].price,
                quantity: cart.items.values.toList()[index].quantity,
                title: cart.items.values.toList()[index].title,
                productId: cart.items.keys.toList()[index],
              ),
            ),
          ),
          //..................................................................//
        ],
      ),
    );
  }
}

//............................Order-Button configration.........................
class OrderButton extends StatefulWidget {
  const OrderButton({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  bool _isloading = false;
  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: _isloading
          ? CircularProgressIndicator()
          : Text(
              'ORDER NOW!',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
      onPressed: (widget.cart.totalAmount <= 0 || _isloading)
          ? null
          : () async {
              setState(() {
                _isloading = false;
              });
              await Provider.of<OrderProvider>(context, listen: false).addOrder(
                widget.cart.items.values.toList(),
                widget.cart.totalAmount,
              );
              setState(() {
                _isloading = false;
              });

              widget.cart.clear();
            },
    );
  }
}
