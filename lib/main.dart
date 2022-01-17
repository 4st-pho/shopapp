import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './providers/products.dart';
import './providers/carts.dart';
import './providers/orders.dart';
import './screens/home_screen.dart';
import './screens/order_screen.dart';
import './screens/product_detail_screen.dart';
import './screens/cart_screen.dart';
import './screens/management_screen.dart';
import './screens/add_product_screen.dart';
import './screens/edit_product_screen.dart';
import './helpers/custom_route.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => Products()),
        ChangeNotifierProvider(create: (ctx) => Carts()),
        ChangeNotifierProvider(create: (ctx) => Orders()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          pageTransitionsTheme: PageTransitionsTheme(builders: {
            TargetPlatform.android : CustonRoute(),
            TargetPlatform.iOS : CustonRoute(),
          })
          // scaffoldBackgroundColor: Colors.red,
        ),
        home: const HomeScreen(),
        routes: {
          ProductDetailScreen.routeName : (ctx) => const ProductDetailScreen(),
          CartScreen.routeName : (ctx) => const CartScreen(),
          OrderScreen.routeName : (ctx) => const OrderScreen(),
          ManagementScreen.routeName : (ctx) => const ManagementScreen(),
          AddProductScreen.routeName : (ctx) => const AddProductScreen(),
          EditProductScreen.routeName : (ctx) => const EditProductScreen(),
        },
      ),
    );
  }
}
