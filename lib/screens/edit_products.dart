import "package:flutter/material.dart";
import 'package:my_shop/providers/product.dart';
import 'package:my_shop/providers/products.dart';
import 'package:provider/provider.dart';

class EditProductScreen extends StatefulWidget {
  static const route = "/edit-products";
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocus = FocusNode();
  final _descFocus = FocusNode();
  final _urlFocus = FocusNode();
  final _urlEditController = TextEditingController();
  final _form = GlobalKey<FormState>();
  var _edited =
      Product(id: null, title: "", description: "", price: 0, imageUrl: "");
  var _isinit = true;
  var _initProd = {
    "title": "",
    "description": "",
    "price": "",
    "imageUrl": "",
  };
  var _isLoad = false;

  @override
  void initState() {
    _urlFocus.addListener(_updateFocus);
    super.initState();
  }

  void _updateFocus() {
    if (!_urlFocus.hasFocus) {
      setState(() {});
    }
  }

  @override
  void didChangeDependencies() {
    if (_isinit) {
      final prodID = ModalRoute.of(context).settings.arguments as String;
      if (prodID != null) {
        _edited =
            Provider.of<Products>(context, listen: false).findById(prodID);
        _initProd = {
          "title": _edited.title,
          "description": _edited.description,
          "price": _edited.price.toString(),
          // "imageUrl": _edited.imageUrl,
          "imageUrl": "",
        };
        _urlEditController.text = _edited.imageUrl;
      }
    }
    _isinit = false;

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _urlEditController.removeListener(_updateFocus);
    _priceFocus.dispose();
    _descFocus.dispose();
    _urlFocus.dispose();
    super.dispose();
  }

  Future<void> _saveForm() async {
    var valid = _form.currentState.validate();
    if (!valid) {
      return;
    }
    _form.currentState.save();
    setState(() {
      _isLoad = true;
    });
    if (_edited.id != null) {
      await Provider.of<Products>(context, listen: false)
          .updateProduct(_edited.id, _edited);
    } else {
      final val = await Provider.of<Products>(context, listen: false)
          .addProduct(_edited);
      if (!val) {
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text("An error occured!"),
            content: Text("SomeThing went wrong "),
            actions: [
              TextButton(
                child: Text("Ok"),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              )
            ],
          ),
        );
      }
    }
    setState(() {
      _isLoad = false;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Product"),
        actions: [
          IconButton(icon: Icon(Icons.save), onPressed: _saveForm),
        ],
      ),
      body: _isLoad
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.all(15),
              child: Form(
                  key: _form,
                  child: ListView(
                    children: [
                      TextFormField(
                        initialValue: _initProd['title'],
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Enter a title";
                          }
                          return null;
                        },
                        decoration: InputDecoration(labelText: "Title"),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_priceFocus);
                        },
                        onSaved: (value) {
                          _edited = Product(
                              id: _edited.id,
                              isFav: _edited.isFav,
                              title: value,
                              description: _edited.description,
                              price: _edited.price,
                              imageUrl: _edited.imageUrl);
                        },
                      ),
                      SizedBox(height: 5),
                      TextFormField(
                        initialValue: _initProd["price"],
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Enter a Price greater than 0";
                          }
                          if (double.tryParse(value) == null) {
                            return "Please enter a valid number";
                          }
                          if (double.parse(value) <= 0) {
                            return "Please enter a number > 0 ";
                          }
                          return null;
                        },
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(labelText: "Price"),
                        textInputAction: TextInputAction.next,
                        focusNode: _priceFocus,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_descFocus);
                        },
                        onSaved: (value) {
                          _edited = Product(
                            id: _edited.id,
                            isFav: _edited.isFav,
                            title: _edited.title,
                            description: _edited.description,
                            price: double.parse(value),
                            imageUrl: _edited.imageUrl,
                          );
                        },
                      ),
                      SizedBox(height: 5),
                      TextFormField(
                        initialValue: _initProd['description'],
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Enter a description";
                          }

                          if (value.length < 10) {
                            return "Enter a description more than 10 characters";
                          }
                          return null;
                        },
                        maxLines: 3,
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(labelText: "Description"),
                        textInputAction: TextInputAction.newline,
                        focusNode: _descFocus,
                        onSaved: (value) {
                          _edited = Product(
                              id: _edited.id,
                              isFav: _edited.isFav,
                              title: _edited.title,
                              description: value,
                              price: _edited.price,
                              imageUrl: _edited.imageUrl);
                        },
                      ),
                      SizedBox(height: 20),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            margin: EdgeInsets.only(right: 5),
                            decoration: BoxDecoration(
                              border: Border.all(width: 1, color: Colors.grey),
                            ),
                            child: _urlEditController.text.isEmpty
                                ? Center(child: Text("Enter Url "))
                                : FittedBox(
                                    child: Image.network(
                                      _urlEditController.text,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                          ),
                          Expanded(
                            child: TextFormField(
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "Enter a Url";
                                }
                                if (!value.startsWith("http") &&
                                    !value.startsWith("https")) {
                                  return "Please enter a valid url ";
                                }
                                if (!value.endsWith(".png") &&
                                    !value.endsWith(".jpg") &&
                                    !value.endsWith(".jpeg")) {
                                  return "Please enter a valid url extension";
                                }
                                return null;
                              },
                              controller: _urlEditController,
                              keyboardType: TextInputType.url,
                              decoration: InputDecoration(labelText: "Url"),
                              focusNode: _urlFocus,
                              onFieldSubmitted: (_) {
                                _saveForm();
                              },
                              onSaved: (value) {
                                _edited = Product(
                                    id: _edited.id,
                                    isFav: _edited.isFav,
                                    title: _edited.title,
                                    description: _edited.description,
                                    price: _edited.price,
                                    imageUrl: value);
                              },
                            ),
                          ),
                        ],
                      )
                    ],
                  )),
            ),
    );
  }
}
