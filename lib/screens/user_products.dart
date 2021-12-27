import 'package:flutter/material.dart';
import 'package:my_shop/providers/products.dart';
import 'package:my_shop/screens/edit_products.dart';
import 'package:my_shop/widgets/drawer.dart';
import 'package:my_shop/widgets/user_item.dart';
import 'package:provider/provider.dart';

class UserProductsScreen extends StatefulWidget {
  static const userProducts = "/user-products";

  @override
  _UserProductsScreenState createState() => _UserProductsScreenState();
}

class _UserProductsScreenState extends State<UserProductsScreen> {
  var _load = false;

  @override
  void initState() {
    setState(() {
      _load = true;
    });
    Future.delayed(Duration.zero).then((value) {
      Provider.of<Products>(context, listen: false)
          .initilizeUserProducts()
          .then((value) {
        setState(() {
          _load = false;
        });
      });
    });

    super.initState();
  }

  Future<void> _onLoad(BuildContext context) async {
    await Provider.of<Products>(context, listen: false)
        .initilizeUserProducts()
        .then((_) => print("Hey loaded!!!"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Products"),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            color: Colors.white,
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.route);
            },
          ),
        ],
      ),
      drawer: CustomDrawer(),
      body: _load
          ? Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: () =>
                  _onLoad(context).then((_) => print("Loading done  !!")),
              child: Consumer<Products>(builder: (_, p, c) {
                return p.items.length == 0
                    ? Center(
                        child: Text(
                          "Add item's now !",
                          style: TextStyle(fontSize: 24),
                        ),
                      )
                    : Padding(
                        padding: EdgeInsets.all(8),
                        child: ListView.builder(
                          itemCount: p.items.length,
                          itemBuilder: (_, i) {
                            return UserItem(p.items[i].id, p.items[i].title,
                                p.items[i].imageUrl);
                          },
                        ),
                      );
              }),
            ),
    );
  }
}
