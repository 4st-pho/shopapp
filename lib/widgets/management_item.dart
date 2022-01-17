import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/products.dart';
import '../screens/edit_product_screen.dart';

class ManagementItem extends StatelessWidget {
  const ManagementItem({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final _product = Provider.of<Product>(context);
    final _products = Provider.of<Products>(context, listen: false);
    return Column(
      children: [
        ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(_product.imageUrl),
          ),
          title: Text(_product.title),
          trailing: SizedBox(
            width: 100,
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pushNamed(EditProductScreen.routeName,
                            arguments: _product)
                        .then(
                      (value) {
                        if (value == true) {
                          scaffoldMessenger.hideCurrentSnackBar();
                          scaffoldMessenger.showSnackBar(
                            const SnackBar(
                              content: Text('Update success'),
                              backgroundColor: Colors.green,
                              duration: Duration(seconds: 2),
                            ),
                          );
                        } else if (value == false) {
                          scaffoldMessenger.hideCurrentSnackBar();
                          scaffoldMessenger.showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Update error!',
                                style: TextStyle(color: Colors.red),
                              ),
                              backgroundColor: Colors.grey,
                              duration: Duration(seconds: 2),
                            ),
                          );
                        }
                      },
                    );
                  },
                  icon: const Icon(Icons.edit),
                ),
                IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Confirm'),
                        content: const Text('Product will be deleted!'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              _products.deleteProduct(_product.id);
                              Navigator.of(ctx).pop();
                              scaffoldMessenger.hideCurrentSnackBar();
                              scaffoldMessenger.showSnackBar(
                                const SnackBar(
                                  content: Text('Delete success'),
                                  backgroundColor: Colors.green,
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            },
                            child: const Text('Yes'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(ctx).pop();
                            },
                            child: const Text('cancel'),
                          ),
                        ],
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.delete,
                    color: Theme.of(context).errorColor,
                  ),
                ),
              ],
            ),
          ),
        ),
        const Divider(
          color: Colors.green,
        ),
      ],
    );
  }
}
