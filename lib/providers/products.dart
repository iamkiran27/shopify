import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:my_shop/providers/auth_provider.dart';
import 'package:my_shop/providers/product.dart';
import 'package:http/http.dart' as http;

class Products with ChangeNotifier {
  List<Product> _items = [];

  String authToken;
  String uid;
  // Products(this.authToken, this._items);
  List<Product> get isFav {
    return _items.where((ele) => ele.isFav).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  List<Product> get items {
    return [..._items];
  }

  void update(AuthProvider auth) {
    authToken = auth.auth;
    uid = auth.uid;
    // notifyListeners();
  }

  String get userId {
    return uid;
  }

  Future<bool> addProduct(Product product) async {
    var url = "flutter-my-shop-84e7a-default-rtdb.firebaseio.com";
    try {
      final res = await http.post(
          Uri.https(url, "/products.json", {"auth": "$authToken"}),
          body: json.encode({
            "title": product.title,
            "description": product.description,
            "price": product.price,
            "uid": uid,
            "imageUrl": product.imageUrl
          }));

      final _product = Product(
          id: json.decode(res.body)['name'],
          title: product.title,
          description: product.description,
          imageUrl: product.imageUrl,
          price: product.price);
      _items.insert(0, _product);
      notifyListeners();
      return true;
    } catch (err) {
      // print(err.toString());
      return false;
    }
  }

  Future<void> removeProduct(String id) async {
    final url = "flutter-my-shop-84e7a-default-rtdb.firebaseio.com";
    await http
        .delete(Uri.https(url, '/products/$id.json', {"auth": "$authToken"}));
    _items.removeWhere((ele) => ele.id == id);
    notifyListeners();
  }

  Future<void> initilizeProducts() async {
    var url = "flutter-my-shop-84e7a-default-rtdb.firebaseio.com";
    try {
      print("Token : " + authToken);
      final got = await http
          .get(Uri.https(url, "/products.json", {"auth": "$authToken"}));
      final getFav = await http.get(
        Uri.https(url, '/userFav/$uid.json', {"auth": "$authToken"}),
      );
      final getFavdecode = json.decode(getFav.body);
      final gotDecode = json.decode(got.body) as Map<String, dynamic>;
      print(gotDecode);
      if (gotDecode == null) {
        return;
      }
      List<Product> gotProd = [];
      gotDecode.forEach((key, value) {
        gotProd.add(Product(
            id: key,
            title: value['title'],
            description: value['description'],
            price: value['price'],
            isFav: getFavdecode == null ? false : getFavdecode[key] ?? false,
            imageUrl: value['imageUrl']));
      });
      _items = gotProd;
      notifyListeners();
    } catch (err) {
      print("Entered catch 1");
      print("err : " + err.toString());
      throw (err);
    }
  }

  Future<void> initilizeUserProducts() async {
    var url = "flutter-my-shop-84e7a-default-rtdb.firebaseio.com";
    try {
      print("Token : " + authToken);
      final got = await http
          .get(Uri.https(url, "/products.json", {"auth": "$authToken"}));
      final getFav = await http.get(
        Uri.https(url, '/userFav/$uid.json', {"auth": "$authToken"}),
      );
      final getFavdecode = json.decode(getFav.body);
      final gotDecode = json.decode(got.body) as Map<String, dynamic>;
      print(gotDecode);
      if (gotDecode == null) {
        return;
      }
      List<Product> gotProd = [];
      gotDecode.forEach((key, value) {
        if (value["uid"] == uid) {
          gotProd.add(Product(
              id: key,
              title: value['title'],
              description: value['description'],
              price: value['price'],
              isFav: getFavdecode == null ? false : getFavdecode[key] ?? false,
              imageUrl: value['imageUrl']));
        }
      });

      _items = gotProd;
      notifyListeners();
    } catch (err) {
      print("Entered catch 1");
      print("err : " + err.toString());
      throw (err);
    }
  }

  Future<void> updateProduct(String id, Product prod) async {
    final index = _items.indexWhere((element) => element.id == id);
    const url = "flutter-my-shop-84e7a-default-rtdb.firebaseio.com";
    await http.patch(
        Uri.https(url, '/products/$id.json', {"auth": "$authToken"}),
        body: json.encode({
          "title": prod.title,
          "price": prod.price,
          "description": prod.description,
          "imageUrl": prod.imageUrl,
        }));
    _items[index] = prod;
    notifyListeners();
  }
}
