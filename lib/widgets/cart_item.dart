import 'package:flutter/material.dart';
import 'package:my_shop/providers/auth_provider.dart';
import 'package:my_shop/providers/cart.dart';
import 'package:provider/provider.dart';

class CardItems extends StatelessWidget {
  final String title;
  final String id;
  final String cartId;
  final double price;
  final int quantity;

  CardItems(this.id, this.cartId, this.title, this.price, this.quantity);
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    return Dismissible(
      key: ValueKey(cartId),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        padding: EdgeInsets.only(right: 20),
        alignment: Alignment.centerRight,
        color: Theme.of(context).errorColor,
        child: Icon(
          (Icons.delete),
          color: Colors.white,
          size: 30,
        ),
      ),
      confirmDismiss: (direction) {
        return showDialog(
            context: context,
            builder: (ctx) {
              return AlertDialog(
                title: Text(
                  "Are you sure ?",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                content: Text("Do you really want to delete this item ?"),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(ctx).pop(false);
                      },
                      child: Text("No")),
                  TextButton(
                      onPressed: () {
                        Navigator.of(ctx).pop(true);
                      },
                      child: Text("Yes")),
                ],
              );
            });
      },
      onDismissed: (direction) async {
        await Provider.of<Cart>(context, listen: false)
            .removeItem(id, auth.auth, auth.uid);
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        child: Padding(
          padding: EdgeInsets.all(5),
          child: ListTile(
            leading: CircleAvatar(
              radius: 24,
              child: Padding(
                padding: const EdgeInsets.all(3.0),
                child: FittedBox(
                  child: Text("$price"),
                ),
              ),
            ),
            title: Text(
              title,
              style: TextStyle(
                  fontSize: 20,
                  // fontFamily: "Raleway",
                  fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              "Total \$${(price * quantity).toStringAsFixed(2)}",
              style: TextStyle(
                fontSize: 15,
              ),
            ),
            trailing: Text(
              " $quantity X",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ),
    );
  }
}
