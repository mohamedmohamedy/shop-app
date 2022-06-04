import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/orders.dart' show OrderProvider;
import '../widgets/order_item.dart';
import '../widgets/the_drawer.dart';

class OrderScreen extends StatefulWidget {
  static const routeName = '/orders';

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  //.........to not rebuild all the widget if some thing changed like dialog box
  Future _orderFuture;

  Future _obtainOrdersFuture() {
    return Provider.of<OrderProvider>(context, listen: false)
        .setAndFetchOrders();
  }

  @override
  void initState() {
    super.initState();
    _orderFuture = _obtainOrdersFuture();
  }

  //............................................................................
  // var _isLoading = false;
  @override
  Widget build(BuildContext context) {
    //final orderData = Provider.of<OrderProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Your orders')),
      drawer: TheDrawer(),
      body: FutureBuilder(
        future: _orderFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.error != null) {
            return Center(child: Text('there is an error'));
          } else {
            return Consumer<OrderProvider>(
              builder: (context, orderData, child) => ListView.builder(
                itemCount: orderData.orders.length,
                itemBuilder: (context, index) =>
                    OrderItem(orderData.orders[index]),
              ),
            );
          }
        },
      ),
    );
  }
}
