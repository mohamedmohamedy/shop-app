import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import '../providers/products_provider.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product-screen';

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();
  var _newProduct = Product(
      id: null, description: '', imageUrl: '', price: 0.0, title: 'title');
  var _isint = true;
  var _initValues = {
    'id': '',
    'title': '',
    'description': '',
    'imageUrl': '',
    'price': '',
  };

  var _isloading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isint) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        _newProduct = Provider.of<ProductsProvider>(context, listen: false)
            .findById(productId);
        _initValues = {
          'id': _newProduct.id,
          'title': _newProduct.title,
          'description': _newProduct.description,
          'imageUrl': '',
          'price': _newProduct.price.toString(),
        };
        _imageUrlController.text = _newProduct.imageUrl;
      }
    }
    _isint = false;
  }

  @override
  void initState() {
    super.initState();
    _imageFocusNode.addListener(_imageUrlUpdate);
  }

  @override
  void dispose() {
    super.dispose();
    _descriptionFocusNode.dispose();
    _priceFocusNode.dispose();
    _imageFocusNode.dispose();
    _imageUrlController.dispose();
    //_imageFocusNode.removeListener(_imageUrlUpdate);
  }

  void _imageUrlUpdate() {
    if (!_imageFocusNode.hasFocus) {
      if (_imageUrlController.text.isEmpty ||
          (!_imageUrlController.text.startsWith('http') &&
              !_imageUrlController.text.startsWith('https'))) {
        return;
      }

      setState(() {});
    }
  }

  void _saveForm() {
    final isValidate = _form.currentState.validate();
    if (!isValidate) {
      return;
    }
    _form.currentState.save();
    setState(() {
      _isloading = true;
    });
    if (_newProduct.id != null) {
      Provider.of<ProductsProvider>(context, listen: false)
          .updateProduct(_newProduct.id, _newProduct);
      setState(() {
        _isloading = false;
      });
      Navigator.of(context).pop();
    } else {
      Provider.of<ProductsProvider>(context, listen: false)
          .addProduct(_newProduct)
          .catchError((error) {
        return showDialog<Null>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('An error occured!'),
            content: Text('unforunatlly there is an error :('),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: Text('Okay'),
              ),
            ],
          ),
        );
      }).then((_) {
        setState(() {
          _isloading = false;
        });
        Navigator.of(context).pop();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit your products'),
        actions: [
          IconButton(
            onPressed: () => _saveForm(),
            icon: Icon(Icons.save),
          ),
        ],
      ),
      body: _isloading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _form,
                child: ListView(
                  children: [
                    //....................TITLE.........................................
                    TextFormField(
                      initialValue: _initValues['title'],
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter a title';
                        }
                        return null;
                      },
                      decoration: InputDecoration(labelText: 'Title'),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) =>
                          FocusScope.of(context).requestFocus(_priceFocusNode),
                      onSaved: (value) {
                        _newProduct = Product(
                          isFavourite: _newProduct.isFavourite,
                          id: _newProduct.id,
                          description: _newProduct.description,
                          imageUrl: _newProduct.imageUrl,
                          price: _newProduct.price,
                          title: value,
                        );
                      },
                    ),
                    //............................PRICE...............................
                    TextFormField(
                      initialValue: _initValues['price'],
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter the price';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        }
                        if (double.parse(value) <= 0) {
                          return 'Please enter a value greater than 0';
                        }
                        return null;
                      },
                      decoration: InputDecoration(labelText: 'Price'),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      focusNode: _priceFocusNode,
                      onFieldSubmitted: (_) => FocusScope.of(context)
                          .requestFocus(_descriptionFocusNode),
                      onSaved: (value) {
                        _newProduct = Product(
                          isFavourite: _newProduct.isFavourite,
                          id: _newProduct.id,
                          description: _newProduct.description,
                          imageUrl: _newProduct.imageUrl,
                          price: double.parse(value),
                          title: _newProduct.title,
                        );
                      },
                    ),
                    //............DESCRIPTION.........................................
                    TextFormField(
                      initialValue: _initValues['description'],
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter a description';
                        }
                        if (value.length < 10) {
                          return 'Please enter a longer description';
                        }
                        return null;
                      },
                      decoration: InputDecoration(labelText: 'Description'),
                      keyboardType: TextInputType.multiline,
                      maxLines: 3,
                      focusNode: _descriptionFocusNode,
                      onSaved: (value) {
                        _newProduct = Product(
                          isFavourite: _newProduct.isFavourite,
                          id: _newProduct.id,
                          description: value,
                          imageUrl: _newProduct.imageUrl,
                          price: _newProduct.price,
                          title: _newProduct.title,
                        );
                      },
                    ),
                    //................IMAGE...........................................
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          margin: EdgeInsets.only(top: 10, right: 10),
                          decoration: BoxDecoration(
                              border: Border.all(
                            color: Colors.grey,
                            width: 1,
                          )),
                          child: _imageUrlController.text.isEmpty
                              ? Text('Enter an image URL!')
                              : FittedBox(
                                  child: Image.network(
                                    _imageUrlController.text,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        ),
                        Expanded(
                          child: TextFormField(
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter an image URL';
                              }
                              if (!value.startsWith('http') ||
                                  !value.startsWith('https')) {
                                return 'Please enter a valid URL';
                              }
                              return null;
                            },
                            onFieldSubmitted: (_) => _saveForm(),
                            decoration: InputDecoration(labelText: 'Image URL'),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            controller: _imageUrlController,
                            focusNode: _imageFocusNode,
                            onEditingComplete: () {
                              setState(() {});
                            },
                            onSaved: (value) {
                              _newProduct = Product(
                                isFavourite: _newProduct.isFavourite,
                                id: _newProduct.id,
                                description: _newProduct.description,
                                imageUrl: value,
                                price: _newProduct.price,
                                title: _newProduct.title,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
