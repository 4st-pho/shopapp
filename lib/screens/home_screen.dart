import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/product_grid.dart';
import '../widgets/badge.dart';
import '../widgets/app_drawer.dart';
import '../providers/carts.dart';
import '../providers/products.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _showFavorite = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
          actions: [
            Consumer<Carts>(
                builder: (ctx, carts, _) => Badge(
                      quantity: carts.count().toString(),
                    )),
            PopupMenuButton(
              itemBuilder: (ctx) => [
                const PopupMenuItem(
                  child: Text('All'),
                  value: false,
                ),
                const PopupMenuItem(
                  child: Text('Favorite'),
                  value: true,
                ),
              ],
              onSelected: (bool value) {
                setState(() {
                  _showFavorite = value;
                });
              },
            ),
          ],
        ),
        drawer: const AppDrawer(),
        body: FutureBuilder(
          future: Provider.of<Products>(context, listen: false)
              .fetchAndSetProducts(),
          builder: (ctx, data) {
            if (data.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (data.error != null) {
                return const Center(
                  child: Text('Error!'),
                );
              } else {
                return ProductGrid(showFavorite: _showFavorite);
              }
            }
          },
        ));
  }
}
