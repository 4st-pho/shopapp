import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/carts.dart';
import '../screens/product_detail_screen.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final _product = Provider.of<Product>(context, listen: false);
    final _carts = Provider.of<Carts>(context, listen: false);
    void _selectPage() {
      Navigator.of(context)
          .pushNamed(ProductDetailScreen.routeName, arguments: _product.id);
    }

    return Container(
      margin: const EdgeInsets.all(5),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: GridTile(
          child: Hero(
            tag: _product.id,
            child: GestureDetector(
              onTap: () => _selectPage(),
              child: FadeInImage(
                placeholder: const AssetImage('assets/images/inter-milan-logo.png'),
                image: NetworkImage(
                  _product.imageUrl,
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          footer: GridTileBar(
            backgroundColor: Colors.black54,
            leading: Consumer<Product>(
              builder: (ctx, product, _) => IconButton(
                icon: product.favorite
                    ? const Icon(Icons.favorite)
                    : const Icon(Icons.favorite_border),
                onPressed: () => product.toggleFavorite(),
              ),
            ),
            title: Text(_product.title),
            trailing: IconButton(
              icon: const Icon(Icons.shopping_cart_sharp),
              onPressed: () {
                _carts.addItem(_product.id, _product.title, _product.price);
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Add sucess'),
                    backgroundColor: Colors.green,
                    action: SnackBarAction(
                      label: 'Undo',
                      onPressed: () => _carts.removeSingleItem(_product.id),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
