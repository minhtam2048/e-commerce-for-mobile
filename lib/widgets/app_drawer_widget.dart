import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth_provider.dart';
import 'package:shop_app/screens/orders_creen.dart';
import 'package:shop_app/screens/user_products_screen.dart';

class AppDrawerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(children: <Widget>[
        AppBar(
          title: Text('Hello world!'),
          automaticallyImplyLeading: false,
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.shop),
          title: Text('Shop'),
          onTap: () => Navigator.of(context).pushReplacementNamed('/'),
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.payment),
          title: Text('Orders'),
          onTap: () => Navigator.of(context)
              .pushReplacementNamed(OrdersScreen.routeName),
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.edit),
          title: Text('Manage your products'),
          onTap: () => Navigator.of(context)
              .pushReplacementNamed(UserProductsScreen.routeName),
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.exit_to_app),
          title: Text('Logout'),
          onTap: () {
            Navigator.of(context).pop();
            Navigator.of(context).pushReplacementNamed('/');
            Provider.of<AuthProvider>(context, listen: false).logout();
          },
        )
      ]),
    );
  }
}
