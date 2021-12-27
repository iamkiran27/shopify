import 'dart:math';

import "package:flutter/material.dart";
import 'package:my_shop/providers/orders.dart';
import 'package:intl/intl.dart';

class OrderItm extends StatefulWidget {
  final OrderItem item;

  OrderItm(this.item);

  @override
  _OrderItmState createState() => _OrderItmState();
}

class _OrderItmState extends State<OrderItm> {
  var _isExpanded = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 5,
      margin: EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            title: Text(
              "Total : \$${widget.item.total.toStringAsFixed(2)}",
              style: TextStyle(fontSize: 18),
            ),
            subtitle: Text(
                DateFormat('dd/MM/yyyy hh:mm').format(widget.item.dateTime)),
            trailing: IconButton(
              icon: Icon(
                _isExpanded ? Icons.expand_less : Icons.expand_more,
              ),
              onPressed: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
            ),
          ),
          if (_isExpanded)
            Text("Your Item's",
                style: TextStyle(fontSize: 18, fontFamily: "Raleway")),
          if (_isExpanded)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              height: min(widget.item.items.length * 20.0 + 120, 250),
              child: ListView.builder(
                itemBuilder: (_, i) {
                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 4, horizontal: 5),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              widget.item.items[i].title,
                              style: TextStyle(fontSize: 18),
                            ),
                            Spacer(),
                            Chip(
                              label: Text("${widget.item.items[i].quantity}X"),
                              backgroundColor: Theme.of(context).primaryColor,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "\$${widget.item.items[i].price}",
                              style:
                                  TextStyle(color: Colors.blue, fontSize: 18),
                            ),
                          ],
                        ),
                        Divider()
                      ],
                    ),
                  );
                },
                itemCount: widget.item.items.length,
              ),
            ),
        ],
      ),
    );
  }
}
