import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth_provider.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/orders_providers.dart';

import 'package:shop_app/providers/products_provider.dart';
import 'package:shop_app/screens/auth_screen.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:shop_app/screens/orders_creen.dart';
import 'package:shop_app/screens/user_products_screen.dart';
import './screens/products_overview_screen.dart';
import './screens/product_detail_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: AuthProvider(),
        ),
        //This provder will rebuild when auth proider changes
        ChangeNotifierProxyProvider<AuthProvider, ProductsProvider>(
          update: (ctx, auth, previousProductsProvider) => ProductsProvider(
              auth.token,
              auth.userId,
              previousProductsProvider == null
                  ? []
                  : previousProductsProvider.items),
          create: (BuildContext context) {},
        ),
        ChangeNotifierProvider.value(value: Cart()),
        ChangeNotifierProxyProvider<AuthProvider, OrdersProviders>(
          update: (ctx, auth, previousOrdersProvider) => OrdersProviders(
              auth.token,
              previousOrdersProvider == null
                  ? []
                  : previousOrdersProvider.orders), 
          create: (BuildContext context) {},
        )
      ],
      // Make sure Material App rebuild when auth change
      child: Consumer<AuthProvider>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'Amazon',
          theme: ThemeData(
              primarySwatch: Colors.purple,
              accentColor: Colors.deepOrange,
              fontFamily: 'Anton'),
          home: auth.isAuth ? ProductsOverviewScreen() : AuthScreen(),
          routes: {
            ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
            CartScreen.routeName: (ctx) => CartScreen(),
            OrdersScreen.routeName: (ctx) => OrdersScreen(),
            UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
            EditProductScreen.routeName: (ctx) => EditProductScreen(),
            AuthScreen.routeName: (ctx) => AuthScreen(),
          },
        ),
      ),
    );
  }
}
