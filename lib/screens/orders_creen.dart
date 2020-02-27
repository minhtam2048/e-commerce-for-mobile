import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/orders_providers.dart';
import 'package:shop_app/widgets/app_drawer_widget.dart';
import 'package:shop_app/widgets/order_item_widget.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';

  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<OrdersProviders>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('your orders'),
      ),
      drawer: AppDrawerWidget(),
      body: ListView.builder(
          itemBuilder: (ctx, i) => OrderItemWidget(orderData.orders[i]),
          itemCount: orderData.orders.length),
    );
  }
}
