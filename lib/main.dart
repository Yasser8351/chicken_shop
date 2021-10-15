import 'package:flutter/material.dart';
import 'package:chicken_shop/provider/auth.dart';
import 'package:chicken_shop/provider/orders.dart';
import 'package:chicken_shop/screen/auth_screen.dart';
import 'screen/cart_screen.dart';
import 'screen/edite_proudct_screen.dart';
import 'screen/splash_screen.dart';
import 'screen/user_products_screen.dart';
import 'screen/order_screen.dart';
import 'provider/cart.dart';
import 'screen/product_detail_screen.dart';
import 'provider/products.dart';
import 'package:provider/provider.dart';

import 'screen/prodect_overview_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          update: (ctx, auth, product) => Products(
              auth.token, auth.userId, product == null ? [] : product.items),
          create: (context) => null,
        ),
        ChangeNotifierProvider.value(
          value: Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          update: (ctx, auth, orders) => Orders(
              auth.token, auth.userId, orders == null ? [] : orders.orders),
          create: (context) => null,
        ),
      ],
      child: Consumer<Auth>(
        builder: (context, auth, _) => MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
                primaryColor: Colors.purple, accentColor: Colors.deepOrange),
            home: auth.isAuth
                ? ProductsOverviewScreen()
                : FutureBuilder(
                    future: auth.autoLogin(),
                    builder: (context, snapshot) =>
                        snapshot.connectionState == ConnectionState.waiting
                            ? SplashScreen()
                            : AuthScreen(),
                  ),
            routes: {
              ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
              CartScreen.routeName: (ctx) => CartScreen(),
              OrderScreen.routeName: (ctx) => OrderScreen(),
              UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
              EditeProudctScreen.routName: (ctx) => EditeProudctScreen(),
            }),
      ),
    );
  }
}
