import 'package:flutter/material.dart';
import 'package:my_shop/providers/auth_provider.dart';
import 'package:my_shop/providers/cart.dart';
import 'package:my_shop/providers/orders.dart';
import 'package:my_shop/widgets/cart_item.dart';
import 'package:provider/provider.dart';

class CartsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cartObj = Provider.of<Cart>(context);
    final itemsLen = cartObj.cartLen;
    final items = cartObj.items;

    return Scaffold(
      appBar: AppBar(
        title: Text("Your Cart !"),
      ),
      body:
          // ? Center(
          //     child: Text("No Items Added Yet !"),
          //   )
          Column(
        children: [
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "Total",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(),
                  Chip(
                      elevation: 5,
                      backgroundColor: Theme.of(context).primaryColor,
                      label: Text(
                        "\$${cartObj.total.toStringAsFixed(2)}",
                        style: TextStyle(color: Colors.white),
                      )),
                  PlaceOrderButton(
                      itemsLen: itemsLen, items: items, cartObj: cartObj),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            "Your Item's",
            style: TextStyle(
                fontSize: 24,
                fontFamily: "Raleway",
                fontWeight: FontWeight.w500),
          ),
          Expanded(
            child: (itemsLen == 0)
                ? Center(
                    child: Text(
                    "No items added yet..!",
                    style: TextStyle(
                        fontSize: 18, color: Theme.of(context).errorColor),
                  ))
                : Padding(
                    padding: EdgeInsets.all(3),
                    child: ListView.builder(
                      itemBuilder: (_, i) {
                        return CardItems(
                            items.keys.toList()[i],
                            items.values.toList()[i].cartID,
                            items.values.toList()[i].title,
                            items.values.toList()[i].price,
                            items.values.toList()[i].quantity);
                      },
                      itemCount: itemsLen,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class PlaceOrderButton extends StatefulWidget {
  const PlaceOrderButton({
    Key key,
    @required this.itemsLen,
    @required this.items,
    @required this.cartObj,
  }) : super(key: key);

  final int itemsLen;
  final Map<String, CartItem> items;
  final Cart cartObj;

  @override
  _PlaceOrderButtonState createState() => _PlaceOrderButtonState();
}

class _PlaceOrderButtonState extends State<PlaceOrderButton> {
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    return TextButton(
      onPressed: (widget.itemsLen == 0 || _isLoading == true)
          ? null
          : () async {
              setState(() {
                _isLoading = true;
              });
              await Provider.of<Orders>(context, listen: false).addOrder(
                  widget.items.values.toList(),
                  widget.cartObj.total,
                  auth.auth,
                  auth.uid);
              setState(() {
                _isLoading = false;
              });
              await widget.cartObj.clear(auth.auth, auth.uid);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.black87,
                  // margin: EdgeInsets.all(5),
                  padding: EdgeInsets.all(8),
                  action: SnackBarAction(
                      label: "Ok",
                      textColor: Colors.deepOrange,
                      onPressed: () {
                        Navigator.of(context).pushReplacementNamed("/products");
                      }),
                  // behavior: SnackBarBehavior.floating,
                  content: Text(
                    "Order Successfully Placed!",
                    style: TextStyle(fontSize: 16),
                  ),
                  duration: Duration(seconds: 3),
                ),
              );
            },
      child: _isLoading
          ? CircularProgressIndicator()
          : Text(
              "ORDER NOW",
              style: TextStyle(fontSize: 20, fontFamily: "RobotoCondensed"),
            ),
    );
  }
}
