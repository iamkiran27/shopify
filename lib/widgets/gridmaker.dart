import 'package:flutter/material.dart';
import 'package:my_shop/providers/products.dart';
import 'package:my_shop/widgets/product_item.dart';
import 'package:provider/provider.dart';

class GridMaker extends StatelessWidget {
  final bool isfav;
  GridMaker(this.isfav);
  @override
  Widget build(BuildContext context) {
    final prodObj = Provider.of<Products>(context);
    final items = isfav ? prodObj.isFav : prodObj.items;
    return (isfav && items.length == 0)
        ? Center(
            child: Text(
            "No favs yet !!",
            style: TextStyle(fontSize: 24, fontFamily: "Raleway"),
          ))
        : GridView.builder(
            itemCount: items.length,
            padding: EdgeInsets.all(15),
            itemBuilder: (_, i) {
              return ChangeNotifierProvider.value(
                value: items[i],
                child: ProductItem(),
              );
            },
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              childAspectRatio: 5 / 4,
              // mainAxisSpacing: 10,
              // crossAxisSpacing: 10,
            ),
          );
  }
}
