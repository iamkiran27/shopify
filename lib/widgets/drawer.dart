import "package:flutter/material.dart";
import 'package:my_shop/providers/auth_provider.dart';
import 'package:my_shop/screens/user_products.dart';
import 'package:provider/provider.dart';

class CustomDrawer extends StatelessWidget {
  void drawerTaped(BuildContext context, String route) {
    Navigator.of(context).pushReplacementNamed(route);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text("Hello there !"),
            automaticallyImplyLeading: false,
          ),
          ListTile(
            onTap: () {
              drawerTaped(context, '/products');
            },
            leading: Icon(
              Icons.shop,
              size: 22,
            ),
            title: Text(
              "Home",
              style: TextStyle(
                fontSize: 20,
                fontFamily: "Raleway",
              ),
            ),
          ),
          Divider(),
          ListTile(
            onTap: () {
              drawerTaped(context, '/orders');
            },
            leading: Icon(
              Icons.payment,
              size: 22,
            ),
            title: Text(
              "Orders",
              style: TextStyle(
                fontSize: 20,
                fontFamily: "Raleway",
              ),
            ),
          ),
          Divider(),
          ListTile(
            onTap: () {
              drawerTaped(context, UserProductsScreen.userProducts);
            },
            leading: Icon(
              Icons.edit,
              size: 22,
            ),
            title: Text(
              "Manage Products",
              style: TextStyle(
                fontSize: 20,
                fontFamily: "Raleway",
              ),
            ),
          ),
          Divider(),
          ListTile(
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed("/");

              Provider.of<AuthProvider>(context, listen: false).logout();
            },
            leading: Icon(
              Icons.exit_to_app,
              size: 22,
            ),
            title: Text(
              "Logout",
              style: TextStyle(
                fontSize: 20,
                fontFamily: "Raleway",
              ),
            ),
          ),
        ],
      ),
    );
  }
}
