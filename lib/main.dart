import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_shop/providers/auth_provider.dart';
import 'package:my_shop/providers/cart.dart';
import 'package:my_shop/providers/orders.dart';
import 'package:my_shop/providers/products.dart';
import 'package:my_shop/screens/auth.dart';
import 'package:my_shop/screens/cart_items.dart';
import 'package:my_shop/screens/edit_products.dart';
import 'package:my_shop/screens/orders.dart';
import 'package:my_shop/screens/product_detail.dart';
import 'package:my_shop/screens/products_screen.dart';
import 'package:my_shop/screens/splash_screen.dart';
import 'package:my_shop/screens/user_products.dart';
import 'package:my_shop/widgets/product_item.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: AuthProvider()),
        ChangeNotifierProxyProvider<AuthProvider, Products>(
          create: (_) => Products(),
          update: (_, auth, previous) => previous..update(auth),
        ),
        // ChangeNotifierProxyProvider<Products, Cart>(
        //   create: (_) => Cart(),
        //   update: (_, p, previous) => previous..update(p),
        // ),
        ChangeNotifierProvider.value(
          value: Cart(),
        ),
        ChangeNotifierProvider.value(
          value: Orders(),
        ),
      ],
      child: Consumer<AuthProvider>(
        builder: (_, auth, child) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            // primarySwatch: Colors.purple,
            accentColor: Colors.deepOrange,
            fontFamily: "Lato",
          ),
          home: auth.isAuth
              ? ProductsScreen()
              : FutureBuilder(
                  future: auth.autoLogin(),
                  builder: (ctx, snap) =>
                      snap.connectionState == ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen()),
          routes: {
            "/products": (_) => ProductsScreen(),
            ProductItem.productDetail: (_) => ProductDetail(),
            "/cart-screen": (_) => CartsScreen(),
            "/orders": (_) => OrdersScreen(),
            UserProductsScreen.userProducts: (_) => UserProductsScreen(),
            EditProductScreen.route: (_) => EditProductScreen(),
          },
        ),
      ),
    );
  }
}
