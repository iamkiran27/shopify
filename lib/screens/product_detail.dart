import "package:flutter/material.dart";
import 'package:my_shop/providers/products.dart';
import 'package:provider/provider.dart';

class ProductDetail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context).settings.arguments as String;
    final item = Provider.of<Products>(context, listen: false).findById(id);
    return Scaffold(
      appBar: AppBar(
        title: Text(item.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 300,
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Card(
                elevation: 6,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(6),
                        topRight: Radius.circular(6))),
                child: ClipRRect(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(6),
                        topRight: Radius.circular(6)),
                    child: Image.network(
                      item.imageUrl,
                      fit: BoxFit.cover,
                    )),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Price : \$${item.price}",
              style: TextStyle(fontSize: 18, fontFamily: "Raleway"),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              // color: Colors.pink,
              width: double.infinity,
              padding: EdgeInsets.all(10),
              child: Text(
                "${item.description}",
                softWrap: true,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontFamily: "Raleway"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
