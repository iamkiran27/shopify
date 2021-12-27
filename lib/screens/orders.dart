import 'package:flutter/material.dart';
import 'package:my_shop/providers/auth_provider.dart';
import 'package:my_shop/providers/orders.dart';
import 'package:my_shop/widgets/drawer.dart';
import 'package:my_shop/widgets/order_item.dart';
import 'package:provider/provider.dart';

class OrdersScreen extends StatefulWidget {
  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Your Orders",
          style: TextStyle(fontFamily: "Lato"),
        ),
      ),
      drawer: CustomDrawer(),
      body: FutureBuilder(
          future: Provider.of<Orders>(context, listen: false)
              .initilizeOrders(auth.auth, auth.uid),
          builder: (ctx, dataSnap) {
            if (dataSnap.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (dataSnap.error != null) {
              return Center(
                child: Text("An error has occured"),
              );
            } else {
              return Consumer<Orders>(builder: (c, items, child) {
                return (items.items.length == 0)
                    ? Center(
                        child: Text(
                          "No previous orders!",
                          style: TextStyle(fontSize: 24),
                        ),
                      )
                    : ListView.builder(
                        itemBuilder: (_, i) {
                          return OrderItm(items.items[i]);
                        },
                        itemCount: items.items.length,
                      );
              });
            }
          }),
    );
  }
}
