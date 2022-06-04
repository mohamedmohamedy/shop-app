import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/order_screen.dart';
import '../screens/user_screen.dart';
import '../providers/auth.dart';

class TheDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text('Welcome!'),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
              leading: Icon(Icons.shopping_cart),
              title: Text('Shop'),
              onTap: () => Navigator.of(context).pushReplacementNamed('/')),
          Divider(),
          ListTile(
              leading: Icon(Icons.payment),
              title: Text('Orders'),
              onTap: () =>
                  Navigator.of(context).pushNamed(OrderScreen.routeName)),
          Divider(),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Your products'),
            onTap: () => Navigator.of(context).pushNamed(UserScreen.routeName),
          ),
          Divider(),
          ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Logout'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).restorablePushReplacementNamed('/');
                Provider.of<Auth>(context, listen: false).logOut();
              }),
        ],
      ),
    );
  }
}
