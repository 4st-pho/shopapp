import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/products.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product-screen';
  const EditProductScreen({Key? key}) : super(key: key);

  @override
  State<EditProductScreen> createState() => EditProductScreenState();
}

class EditProductScreenState extends State<EditProductScreen> {
  bool loader = true;
  final _form = GlobalKey<FormState>();
  late Product _editingProduct;
  final _imageUrlController = TextEditingController();
  final _imageFocusNode = FocusNode();
  void _updateImage() {
    if (!_imageFocusNode.hasFocus) {
      setState(() {});
    }
  }

  void _save() {
    _form.currentState!.save();
    if (!_form.currentState!.validate()) {
      return;
    }
    _editingProduct = Product(
        id: _editingProduct.id,
        favorite: _editingProduct.favorite,
        title: _editingProduct.title,
        description: _editingProduct.description,
        price: _editingProduct.price,
        imageUrl: _imageUrlController.text);
    Provider.of<Products>(context, listen: false)
        .updateProduct(_editingProduct.id, _editingProduct);
    Navigator.of(context).pop(true);
  }

  @override
  void initState() {
    _imageFocusNode.addListener(_updateImage);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (loader == true) {
      _editingProduct = ModalRoute.of(context)!.settings.arguments as Product;
      _imageUrlController.text = _editingProduct.imageUrl;
      loader = false;
    }
    super.didChangeDependencies();
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
            onPressed: () => _save(),
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _form,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                TextFormField(
                  initialValue: _editingProduct.title,
                  decoration: const InputDecoration(
                    label: Text('Title'),
                  ),
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  onSaved: (value) {
                    _editingProduct = Product(
                        id: _editingProduct.id,
                        favorite: _editingProduct.favorite,
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
                  initialValue: _editingProduct.description,
                  decoration: const InputDecoration(
                    label: Text('Description'),
                  ),
                  keyboardType: TextInputType.multiline,
                  maxLines: 3,
                  textInputAction: TextInputAction.newline,
                  onSaved: (value) {
                    _editingProduct = Product(
                        id: _editingProduct.id,
                        favorite: _editingProduct.favorite,
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
                  initialValue: _editingProduct.price.toString(),
                  decoration: const InputDecoration(
                    label: Text('Price'),
                  ),
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  onSaved: (value) {
                    _editingProduct = Product(
                        id: _editingProduct.id,
                        favorite: _editingProduct.favorite,
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
                            width: 2, color: Theme.of(context).primaryColor),
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
                                          color:
                                              Theme.of(context).primaryColor),
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
