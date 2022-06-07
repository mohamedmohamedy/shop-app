import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/products_overview_screen.dart';
import './screens/poduct_details_screen.dart';
import './screens/cart_screen.dart';
import './screens/order_screen.dart';
import './screens/auth_screen.dart';
import './screens/splash_screen.dart';

import './providers/products_provider.dart';
import './providers/cart.dart';
import './providers/orders.dart';
import './providers/auth.dart';

import './helpers/custom_routes.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => Auth()),
          ChangeNotifierProxyProvider<Auth, ProductsProvider>(
            create: (ctx) => ProductsProvider('', '', []),
            update: (context, auth, previousProducts) => ProductsProvider(
                auth.token,
                auth.userId,
                previousProducts == null ? [] : previousProducts.items),
          ),
          ChangeNotifierProvider(create: (context) => Cart()),
          ChangeNotifierProxyProvider<Auth, OrderProvider>(
            create: (ctx) => OrderProvider('', '', []),
            update: (context, auth, previousOrders) =>
                OrderProvider(auth.token, auth.userId, previousOrders.orders),
          ),
        ],
        child: Consumer<Auth>(
          builder: (context, auth, child) => MaterialApp(
            title: 'MyShop',
            theme: ThemeData(
              fontFamily: 'Lato',
              colorScheme: ColorScheme.fromSwatch(
                  primarySwatch: Colors.blueGrey, accentColor: Colors.grey),
              pageTransitionsTheme: PageTransitionsTheme(builders: {
                TargetPlatform.android: CustomPageTransitionBuilder(),
                TargetPlatform.iOS: CustomPageTransitionBuilder(),
              }),
            ),
            home: auth.isAuth
                ? ProductsOverViewScreen()
                : FutureBuilder(
                    future: auth.tryAutoLogin(),
                    builder: (context, autoLoginSnapshot) =>
                        autoLoginSnapshot.connectionState ==
                                ConnectionState.waiting
                            ? SplashScreen()
                            : AuthScreen(),
                  ),
            routes: {
              ProductDetailsScreen.routeName: (context) =>
                  ProductDetailsScreen(),
              CartScreen.routeName: (context) => CartScreen(),
              OrderScreen.routeName: (context) => OrderScreen(),
            },
          ),
        ));
  }
}
