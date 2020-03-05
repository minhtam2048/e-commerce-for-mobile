import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/orders_providers.dart';

class OrderButtonWidget extends StatefulWidget {
  const OrderButtonWidget({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  _OrderButtonWidgetState createState() => _OrderButtonWidgetState();
}

class _OrderButtonWidgetState extends State<OrderButtonWidget> {
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: Text('order now!'),
      onPressed: (widget.cart.totalAmount <= 0 || _isLoading == true)
          ? null
          : () async {
              setState(() {
                _isLoading = true;
              });
              await Provider.of<OrdersProviders>(context, listen: false)
                  .addOrder(
                widget.cart.items.values.toList(),
                widget.cart.totalAmount,
              );
              setState(() {
                _isLoading = false;
              });
              widget.cart.clear();
            },
      textColor: Theme.of(context).primaryColor,
    );
  }
}
