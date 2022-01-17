import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/products.dart';

class AddProductScreen extends StatefulWidget {
  static const routeName = '/add-product-screen';
  const AddProductScreen({Key? key}) : super(key: key);

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  bool _popData = true;
  bool _loading = false;
  final _form = GlobalKey<FormState>();
  Product _editingProduct =
      Product(id: '', title: '', description: '', price: 0, imageUrl: '');
  final _imageUrlController = TextEditingController();
  final _imageFocusNode = FocusNode();
  void _updateImage() {
    if (!_imageFocusNode.hasFocus) {
      setState(() {});
    }
  }

  bool _validatedata() {
    _form.currentState!.save();
    if (!_form.currentState!.validate()) {
      return false;
    }
    return true;
  }

  Future<void> _save() async {
    try {
      setState(() {
        _loading = true;
      });
      await Provider.of<Products>(context, listen: false).addProduct(
          _editingProduct.title,
          _editingProduct.description,
          _editingProduct.price,
          _imageUrlController.text);
    } catch (_) {
      _popData = false;
    } finally {
      Navigator.of(context).pop(_popData);
    }
  }

  @override
  void initState() {
    _imageFocusNode.addListener(_updateImage);
    super.initState();
  }

  @override
  void dispose() {
    _imageUrlController.dispose();
    _imageFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add product'),
        actions: [
          IconButton(
            onPressed: () {
              if (_validatedata()) {
                _save();
              }
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Form(
                key: _form,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(
                          label: Text('Title'),
                        ),
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        onSaved: (value) {
                          _editingProduct = Product(
                              id: _editingProduct.id,
                              title: value as String,
                              description: _editingProduct.description,
                              price: _editingProduct.price,
                              imageUrl: _editingProduct.imageUrl);
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Title not empty!';
                          }
                          if (value.length < 5) {
                            return 'Title not less than 5 character';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          label: Text('Description'),
                        ),
                        keyboardType: TextInputType.multiline,
                        maxLines: 3,
                        textInputAction: TextInputAction.newline,
                        onSaved: (value) {
                          _editingProduct = Product(
                              id: _editingProduct.id,
                              title: _editingProduct.title,
                              description: value as String,
                              price: _editingProduct.price,
                              imageUrl: _editingProduct.imageUrl);
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Description not empty!';
                          }
                          if (value.length < 20) {
                            return 'Description not less than 20 character';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          label: Text('Price'),
                        ),
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        onSaved: (value) {
                          _editingProduct = Product(
                              id: _editingProduct.id,
                              title: _editingProduct.title,
                              description: _editingProduct.description,
                              price: double.parse(value as String),
                              imageUrl: _editingProduct.imageUrl);
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Price not empty!';
                          }
                          if (double.tryParse(value) == null) {
                            return 'incorect type';
                          }
                          if (double.parse(value) < 0) {
                            return 'Price not less than 0';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(right: 10),
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                  width: 2,
                                  color: Theme.of(context).primaryColor),
                            ),
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: _imageUrlController.text.isEmpty
                                    ? Center(
                                        child: Padding(
                                          padding: const EdgeInsets.all(5),
                                          child: Text(
                                            'Enter image url',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColor),
                                          ),
                                        ),
                                      )
                                    : Image.network(
                                        _imageUrlController.text,
                                        height: 300,
                                        fit: BoxFit.cover,
                                      )),
                          ),
                          Expanded(
                            child: TextFormField(
                              decoration: const InputDecoration(
                                label: Text('Image url'),
                              ),
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (_) {
                                setState(() {});
                              },
                              onSaved: (_) {},
                              controller: _imageUrlController,
                              focusNode: _imageFocusNode,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Image url not empty!';
                                }
                                if (!value.startsWith('http') &&
                                        !value.startsWith('https') ||
                                    !value.endsWith('.jpg') &&
                                        !value.endsWith('.png')) {
                                  return 'Error type image url';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
