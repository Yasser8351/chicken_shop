import 'package:chicken_shop/provider/cart.dart';
import 'package:chicken_shop/widget/app_drawer.dart';
import 'package:chicken_shop/widget/badge.dart';
import 'package:chicken_shop/widget/product_grid.dart';
import 'package:flutter/material.dart';
import 'package:chicken_shop/provider/products.dart';
import 'package:provider/provider.dart';

import 'cart_screen.dart';

enum ShowList {
  Faverts,
  All,
}

class ProductsOverviewScreen extends StatefulWidget {
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _showFaverts = false;
  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Products>(context).fetchProducts().then((_) => setState(() {
            _isLoading = false;
          }));
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "My Shop",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          Consumer<Cart>(
            builder: (_, cart, ch) => Badge(
              child: ch,
              value: cart.itemCount.toString(),
            ),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          ),
          PopupMenuButton(
              onSelected: (ShowList select) {
                setState(() {
                  if (select == ShowList.Faverts) {
                    _showFaverts = true;
                  } else {
                    _showFaverts = false;
                  }
                });
              },
              icon: Icon(Icons.more_vert),
              itemBuilder: (_) => [
                    PopupMenuItem(
                      child: Text("Only Faverts"),
                      value: ShowList.Faverts,
                    ),
                    PopupMenuItem(
                      child: Text("Show All"),
                      value: ShowList.All,
                    ),
                  ])
        ],
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ProductGrid(_showFaverts),
    );
  }
}
