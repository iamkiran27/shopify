import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CartItem {
  final String cartID;
  final String title;
  final double price;
  int quantity;

  CartItem(this.cartID, this.title, this.price, this.quantity);
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  // void update(Products p) {
  //   print("In cart : " + p.authToken);
  //   authToken = p.authToken;
  //   uid = p.userId;
  //   // notifyListeners();
  // }

  Future<void> addItem(String productId, String title, double price,
      String authToken, String uid) async {
    var count, cartid;
    var url = "flutter-my-shop-84e7a-default-rtdb.firebaseio.com";
    final res = await http
        .get(Uri.https(url, "/cartItems/$uid.json", {"auth": "$authToken"}));
    final resDecode = json.decode(res.body) as Map<String, dynamic>;
    if (resDecode == null) {
      print("no cart present added first item to cart");
      final cartItem = await http.post(
          Uri.https(url, "/cartItems/$uid.json", {"auth": "$authToken"}),
          body: json.encode({
            "title": title,
            "productID": productId,
            "price": price,
            "quantity": 1,
          }));
      final cartID = json.decode(cartItem.body)["name"];
      _items.putIfAbsent(productId, () => CartItem(cartID, title, price, 1));
      notifyListeners();
    } else {
      // print(resDecode);
      // print("Entered here");
      resDecode.forEach((key, value) {
        print("V : " + value["productID"]);
        print("p : " + productId);
        if (value["productID"] != productId) {
          count = 0;
        } else {
          count = 1;
          cartid = key;
        }
      });

      if (count == 0 && cartid == null) {
        print("add new item other than existing one ");
        final cartItem = await http.post(
            Uri.https(url, "/cartItems/$uid.json", {"auth": "$authToken"}),
            body: json.encode({
              "title": title,
              "productID": productId,
              "price": price,
              "quantity": 1,
            }));
        final cartID = json.decode(cartItem.body)["name"];
        _items.putIfAbsent(productId, () => CartItem(cartID, title, price, 1));
        notifyListeners();
      } else {
        print("updated the old one ");
        final quan = await http.get(Uri.https(
            url, "/cartItems/$uid/$cartid.json", {"auth": "$authToken"}));
        final quande = json.decode(quan.body)["quantity"];
        await http.patch(
            Uri.https(
                url, "/cartItems/$uid/$cartid.json", {"auth": "$authToken"}),
            body: json.encode({
              "quantity": quande + 1,
            }));
        _items.update(
            productId,
            (value) => CartItem(value.cartID, value.title, value.price,
                value.quantity = value.quantity + 1));
        notifyListeners();
      }
    }

    // if (_items.containsKey(productId)) {
    //   _items.update(
    //       productId,
    //       (value) => CartItem(value.cartID, value.title, value.price,
    //           value.quantity = value.quantity + 1));
    // }
    //  else {
    // final cartItem = await http.post(
    //     Uri.https(url, "/cartItems/$uid.json", {"auth": "$authToken"}),
    //     body: json.encode({
    //       "title": title,
    //       "productID": productId,
    //       "price": price,
    //     }));
    // final cartID = json.decode(cartItem.body)["name"];
    // _items.putIfAbsent(productId, () => CartItem(cartID, title, price, 1));
    // }

    // notifyListeners();
  }

  Future<void> initializeCart(String authToken, String uid) async {
    var url = "flutter-my-shop-84e7a-default-rtdb.firebaseio.com";
    final res = await http
        .get(Uri.https(url, "/cartItems/$uid.json", {"auth": "$authToken"}));
    final resCart = json.decode(res.body) as Map<String, dynamic>;
    Map<String, CartItem> finalCart = {};
    if (resCart == null) {
      print("no cart items initially");
      _items = finalCart;
      notifyListeners();
    } else {
      print("Some cart items are present ");
      resCart.forEach((key, value) {
        finalCart.putIfAbsent(
            value["productID"],
            () => CartItem(
                key, value["title"], value["price"], value["quantity"]));
        print(value["title"]);
      });
      // print(finalCart);
      _items = finalCart;
      notifyListeners();
    }
  }

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get cartLen {
    return _items.length;
  }

  double get total {
    double sum = 0;
    _items.forEach((key, value) {
      sum += _items[key].quantity * _items[key].price;
    });
    // print(sum);
    return sum;
  }

  Future<void> removeItem(String id, String authToken, String uid) async {
    var cartkey;
    var url = "flutter-my-shop-84e7a-default-rtdb.firebaseio.com";
    final res = await http
        .get(Uri.https(url, "/cartItems/$uid.json", {"auth": "$authToken"}));
    final resCart = json.decode(res.body) as Map<String, dynamic>;

    resCart.forEach((key, value) {
      if (value["productID"] == id) {
        cartkey = key;
      }
    });
    http.delete(Uri.https(
        url, "/cartItems/$uid/$cartkey.json", {"auth": "$authToken"}));
    _items.remove(id);
    print("deleted item from cart");
    notifyListeners();
  }

  Future<void> deleteSingleItem(String id, String authToken, String uid) async {
    var cartkey;
    var url = "flutter-my-shop-84e7a-default-rtdb.firebaseio.com";
    final res = await http
        .get(Uri.https(url, "/cartItems/$uid.json", {"auth": "$authToken"}));

    final resCart = json.decode(res.body) as Map<String, dynamic>;
    resCart.forEach((key, value) {
      if (value["productID"] == id) {
        cartkey = key;
      }
    });

    final getCart = await http.get(Uri.https(
        url, "/cartItems/$uid/$cartkey.json", {"auth": "$authToken"}));
    final getCartItem = json.decode(getCart.body)["quantity"];
    if (getCart == null) {
      return;
    } else if (getCartItem > 1) {
      await http.patch(
          Uri.https(
              url, "/cartItems/$uid/$cartkey.json", {"auth": "$authToken"}),
          body: json.encode({
            "quantity": getCartItem - 1,
          }));
      _items.update(
          id,
          (value) => CartItem(value.cartID, value.title, value.price,
              value.quantity = value.quantity - 1));
      print("deleted a qunatity of item ");
    } else {
      http.delete(Uri.https(
          url, "/cartItems/$uid/$cartkey.json", {"auth": "$authToken"}));
      _items.remove(id);
      print("deleted item as only onw item was in cart and pressed undo");
    }
    // if (!_items.containsKey(id)) {
    //   return;
    // }

    // if (_items[id].quantity > 1) {
    //   _items.update(
    //       id,
    //       (value) => CartItem(value.cartID, value.title, value.price,
    //           value.quantity = value.quantity - 1));
    // } else {
    //   _items.remove(id);
    // }
    notifyListeners();
  }

  Future<void> clear(String authToken, String uid) async {
    _items = {};
    notifyListeners();

    final url = "flutter-my-shop-84e7a-default-rtdb.firebaseio.com";
    http.delete(Uri.https(url, "/cartItems/$uid.json", {"auth": "$authToken"}));

    print("cleared all items for user $uid");
  }
}
