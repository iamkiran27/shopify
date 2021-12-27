import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  @required
  final String id;
  @required
  final String title;
  @required
  final String description;
  @required
  final double price;
  @required
  final String imageUrl;
  bool isFav;

  Product(
      {this.id,
      this.description,
      this.title,
      this.price,
      this.imageUrl,
      this.isFav = false});

  Future<void> setFav(String id, String authToken, String uid) async {
    final original = isFav;
    var updated = !isFav;
    isFav = updated;
    notifyListeners();
    const url = "flutter-my-shop-84e7a-default-rtdb.firebaseio.com";
    try {
      http.put(Uri.https(url, '/userFav/$uid/$id.json', {"auth": "$authToken"}),
          body: json.encode(
            updated,
          ));
    } catch (err) {
      isFav = original;
      notifyListeners();
    }
  }
}
