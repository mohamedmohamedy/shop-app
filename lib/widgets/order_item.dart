import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math';

import '../providers/orders.dart' as proOrd;

class OrderItem extends StatefulWidget {
  final proOrd.OrderItem order;

  OrderItem(this.order);

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> with TickerProviderStateMixin {
  bool isextended = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height: isextended
          ? min(widget.order.products.length * 20.0 + 300, 200.0)
          : 95,
      child: Card(
        margin: EdgeInsets.all(8.0),
        child: Column(
          children: [
            ListTile(
              title: Text('\$${widget.order.amount}'),
              subtitle: Text(DateFormat('dd / MM / yyyy -  hh:mm')
                  .format(widget.order.date)),
              trailing: IconButton(
                  icon:
                      Icon(isextended ? Icons.expand_less : Icons.expand_more),
                  onPressed: () {
                    setState(() {
                      isextended = !isextended;
                    });
                  }),
            ),
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              height: isextended
                  ? min(widget.order.products.length * 20.0 + 10, 100.0)
                  : 0,
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
              child: ListView(
                children: widget.order.products
                    .map(
                      (e) => Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${e.title}',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'Amount: ${e.quantity}',
                                style: TextStyle(
                                  fontSize: 18,
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                              ),
                              Text(
                                'Price: \$${e.price}',
                                style: TextStyle(
                                  fontSize: 18,
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                              ),
                            ],
                          ),
                          Divider(
                            thickness: 1,
                          ),
                        ],
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
