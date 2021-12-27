import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:my_shop/providers/cart.dart';
// import 'package:my_shop/restapi.dart';
import 'package:http/http.dart' as http;

class OrderItem {
  final String oid;
  final DateTime dateTime;
  final List<CartItem> items;
  final double total;

  OrderItem(this.oid, this.dateTime, this.items, this.total);
}

class Orders with ChangeNotifier {
  List<OrderItem> _orderItems = [];

  List<OrderItem> get items {
    return [..._orderItems];
  }

  Future<void> addOrder(List<CartItem> cartItems, double total,
      String authToken, String uid) async {
    const url = "flutter-my-shop-84e7a-default-rtdb.firebaseio.com";
    final timestamp = DateTime.now();
    final res =
        await http.post(Uri.https(url, "/orders.json", {"auth": "$authToken"}),
            body: json.encode({
              "total": total,
              "dateTime": timestamp.toIso8601String(),
              "uid": uid,
              "items": cartItems
                  .map((e) => {
                        "cartID": e.cartID,
                        "title": e.title,
                        "price": e.price,
                        "quantity": e.quantity,
                      })
                  .toList(),
            }));

    // final resParse = json.decode(res.body) as Map<String, dynamic>;

    _orderItems.insert((0),
        OrderItem(json.decode(res.body)['name'], timestamp, cartItems, total));
    notifyListeners();
  }

  Future<void> initilizeOrders(String authToken, String uid) async {
    const url = "flutter-my-shop-84e7a-default-rtdb.firebaseio.com";
    try {
      final got = await http
          .get(Uri.https(url, "/orders.json", {"auth": "$authToken"}));
      final gotDecode = json.decode(got.body) as Map<String, dynamic>;
      print(gotDecode);
      List<OrderItem> gotOrders = [];
      if (gotDecode == null) {
        print("no orders");
        return;
      }
      gotDecode.forEach((key, value) {
        if (value["uid"] == uid) {
          gotOrders.add(OrderItem(
              key,
              DateTime.parse(value["dateTime"]),
              (value["items"] as List<dynamic>)
                  .map((e) => CartItem(
                      e['cartId'], e['title'], e['price'], e['quantity']))
                  .toList(),
              value["total"]));
        }
      });
      _orderItems = gotOrders.reversed.toList();
      notifyListeners();
    } catch (err) {
      print(err.toString());
      throw (err);
    }
  }
}
