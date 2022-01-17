import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';
import './product_item.dart';
class ProductGrid extends StatelessWidget {
  final bool showFavorite;
  const ProductGrid({required this.showFavorite, Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products>(context, listen: false);
    final _products = showFavorite ? productData.itemsFavorite : productData.items;
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 3/2, crossAxisSpacing: 10, mainAxisSpacing: 10),
      itemCount: _products.length,
      itemBuilder: (ctx, index) => ChangeNotifierProvider.value(value: _products[index], child: const ProductItem(),),
    );
  }
}