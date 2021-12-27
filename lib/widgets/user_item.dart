import 'package:flutter/material.dart';
import 'package:my_shop/providers/products.dart';
import 'package:my_shop/screens/edit_products.dart';
import 'package:provider/provider.dart';

class UserItem extends StatelessWidget {
  final String title;
  final String id;
  final String imageUrl;

  UserItem(this.id, this.title, this.imageUrl);
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      elevation: 4,
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(imageUrl),
        ),
        title: Text(title),
        trailing: Container(
          width: 100,
          child: Row(
            children: [
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed(EditProductScreen.route, arguments: id);
                },
                color: Theme.of(context).primaryColor,
              ),
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () async {
                  await Provider.of<Products>(context, listen: false)
                      .removeProduct(id);
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      // elevation: 5,
                      backgroundColor: Colors.black87,
                      // margin: EdgeInsets.all(5),
                      padding: EdgeInsets.all(8),
                      action: SnackBarAction(
                          label: "OK",
                          textColor: Colors.deepOrange,
                          onPressed: () {}),
                      // behavior: SnackBarBehavior.floating,
                      content: Text(
                        "Your item deleted!",
                        style: TextStyle(fontSize: 16),
                      ),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                color: Theme.of(context).errorColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
