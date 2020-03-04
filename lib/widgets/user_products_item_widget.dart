import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products_provider.dart';
import 'package:shop_app/screens/edit_product_screen.dart';

class UserProductItemWidget extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;

  UserProductItemWidget(this.id, this.title, this.imageUrl);

  void _showDialog(BuildContext context) {
    final scaffold = Scaffold.of(context);
    Widget noBtn = FlatButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: Text('No'));
    Widget yesBtn = FlatButton(
        onPressed: () async {
          try {
            Navigator.of(context).pop();
            await Provider.of<ProductsProvider>(context, listen: false)
                .deleteProduct(id);
          } catch (error) {
            scaffold.showSnackBar(SnackBar(
                content: Text(
              'Deleting failed :(',
              textAlign: TextAlign.center,
            )));
          }
        },
        child: Text('Yes'));
    AlertDialog alert = AlertDialog(
      title: Text('Remove'),
      content: Text('Do you really want to remove this item ?'),
      actions: [
        noBtn,
        yesBtn,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      trailing: Container(
        width: 100,
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(EditProductScreen.routeName, arguments: id);
              },
              color: Theme.of(context).highlightColor,
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                // Provider.of<ProductsProvider>(context, listen: false).deleteProduct(id);
                _showDialog(context);
              },
              color: Theme.of(context).errorColor,
            ),
          ],
        ),
      ),
    );
  }
}
