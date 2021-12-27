import 'package:flutter/material.dart';
import 'package:my_shop/providers/auth_provider.dart';
import 'package:my_shop/providers/cart.dart';
import 'package:my_shop/providers/product.dart';
import 'package:provider/provider.dart';

class ProductItem extends StatelessWidget {
  static const productDetail = "/product-detail";

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final product = Provider.of<Product>(context);
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10))),
      elevation: 6,
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pushNamed(productDetail, arguments: product.id);
        },
        child: GridTile(
          child: ClipRRect(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10)),
            child: Image.network(
              product.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          footer: GridTileBar(
            backgroundColor: Colors.black87,
            leading: Consumer<Product>(
              builder: (ctx, product, _) => IconButton(
                icon: Icon(
                  product.isFav ? Icons.favorite : Icons.favorite_border,
                  size: 30,
                ),
                color: Theme.of(context).accentColor,
                onPressed: () async {
                  print(auth.uid);
                  await product.setFav(product.id, auth.auth, auth.uid);
                  print(product.title);
                  print(product.isFav);
                },
              ),
            ),
            title: Text(
              product.title,
              style: TextStyle(
                fontSize: 20,
                fontFamily: "Raleway",
              ),
              textAlign: TextAlign.center,
            ),
            trailing: Consumer<Cart>(
              builder: (_, cart, child) {
                return IconButton(
                  icon: Icon(Icons.shopping_cart),
                  iconSize: 30,
                  color: Theme.of(context).accentColor,
                  onPressed: () {
                    cart.addItem(product.id, product.title, product.price,
                        auth.auth, auth.uid);
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        // elevation: 5,
                        backgroundColor: Colors.black87,
                        // margin: EdgeInsets.all(5),
                        padding: EdgeInsets.all(8),
                        action: SnackBarAction(
                            label: "UNDO",
                            textColor: Colors.deepOrange,
                            onPressed: () async {
                              await cart.deleteSingleItem(
                                  product.id, auth.auth, auth.uid);
                            }),
                        // behavior: SnackBarBehavior.floating,
                        content: Text(
                          "Added Item to cart",
                          style: TextStyle(fontSize: 16),
                        ),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
