import 'package:flutter/material.dart';
import 'package:chicken_shop/provider/auth.dart';
import 'package:chicken_shop/screen/order_screen.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text("Hello Friend!"),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            title: Text("Shop"),
            leading: Icon(Icons.shop),
            onTap: () {
              Navigator.of(context).pushReplacementNamed("/");
            },
          ),
          Divider(),
          ListTile(
            title: Text("Orders"),
            leading: Icon(
              Icons.payment,
            ),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(OrderScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            title: Text("Logout"),
            leading: Icon(Icons.exit_to_app),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed("/");
              Navigator.of(context).pushNamed('/');
              Provider.of<Auth>(context, listen: false).logout();
            },
          )
        ],
      ),
    );
  }
}
