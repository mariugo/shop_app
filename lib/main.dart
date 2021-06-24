import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '/screens/auth_screen.dart';
import '/screens/edit_product_screen.dart';
import '/screens/orders_screen.dart';
import '/screens/user_products_screen.dart';
import '/screens/cart_screen.dart';
import '/screens/product_detail_screen.dart';
import '/screens/products_overview_screen.dart';
import '/providers/auth.dart';
import '/providers/products.dart';
import '/providers/cart.dart';
import '/providers/orders.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
            create: (ctx) => Products(
                  Provider.of<Auth>(ctx, listen: false).token!,
                  Provider.of<Auth>(ctx, listen: false).userId!,
                ),
            update: (context, auth, previousProducts) => Products(
                  auth.token!,
                  auth.userId!,
                  //previousProducts!.items,
                )),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (ctx) => Orders(Provider.of<Auth>(ctx, listen: false).token!),
          update: (context, auth, previousOrders) => Orders(
            auth.token!,
          ),
        ),
      ],
      child: Consumer<Auth>(
        builder: (context, authData, _) => MaterialApp(
          title: 'MyShop',
          theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.orange,
            fontFamily: 'Open Sans',
          ),
          home: authData.isAuth ? ProductsOverviewScreen() : AuthScreen(),
          routes: {
            ProductsOverviewScreen.routeName: (ctx) => ProductsOverviewScreen(),
            ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
            CartScreen.routeName: (cxt) => CartScreen(),
            OrdersScreen.routeName: (ctx) => OrdersScreen(),
            UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
            EditProductScreen.routeName: (ctx) => EditProductScreen(),
          },
        ),
      ),
    );
  }
}
