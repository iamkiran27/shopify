import 'package:flutter/material.dart';
import 'package:my_shop/providers/auth_provider.dart';
import 'package:my_shop/providers/cart.dart';
import 'package:my_shop/providers/products.dart';
import 'package:my_shop/widgets/badge.dart';
import 'package:my_shop/widgets/drawer.dart';
import 'package:my_shop/widgets/gridmaker.dart';
import 'package:provider/provider.dart';

class ProductsScreen extends StatefulWidget {
  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  var _isfav = false;
  var _isload = false;
  var _isInit = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isload = true;
      });

      Provider.of<Products>(context, listen: false)
          .initilizeProducts()
          .then((_) {
        setState(() {
          _isload = false;
        });
      }).catchError((onError) {
        print("User not authenticated");
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    Provider.of<Cart>(context, listen: false)
        .initializeCart(auth.auth, auth.uid);
    return Scaffold(
      appBar: AppBar(
        actions: [
          PopupMenuButton(
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text("My Favourites"),
                value: 0,
              ),
              PopupMenuItem(
                child: Text("All items"),
                value: 1,
              ),
            ],
            onSelected: (int value) {
              setState(() {
                if (value == 0) {
                  _isfav = true;
                } else {
                  _isfav = false;
                }
              });
            },
          ),
          Consumer<Cart>(
            builder: (_, cart, child) {
              return Badge(
                  child: IconButton(
                    icon: Icon(Icons.shopping_cart),
                    onPressed: () {
                      Navigator.of(context).pushNamed('/cart-screen');
                    },
                  ),
                  value: cart.cartLen.toString());
            },
          ),
        ],
        title: Text(
          "My Shop",
          style: TextStyle(fontFamily: "Lato"),
        ),
      ),
      drawer: CustomDrawer(),
      body: _isload
          ? Center(
              child: CircularProgressIndicator(),
            )
          : GridMaker(_isfav),
    );
  }
}
