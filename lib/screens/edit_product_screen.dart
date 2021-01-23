import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/loading_overlay.dart';
import '../providers/products.dart';
import '../providers/product.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageURLfocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();
  Product _editedProduct = Product(
    id: null,
    title: '',
    description: '',
    price: 0,
    imageUrl: '',
  );
  bool _isValidURL = false;
  var _isInit = true;
  var _isLoading = false;

  var _initValues = {
    'title': '',
    'price': '',
    'description': '',
    'imageUrl': ''
  };

  @override
  void initState() {
    _imageURLfocusNode.addListener(_updateImageURL);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != '') {
        _editedProduct =
            Provider.of<Products>(context, listen: false).findById(productId);
      }
      _initValues['title'] = _editedProduct.title;
      _initValues['price'] = _editedProduct.price.toString();
      _initValues['description'] = _editedProduct.description;
      _initValues['imageUrl'] = _editedProduct.imageUrl;
      _imageUrlController.text = _editedProduct.imageUrl;
      _isValidURL = true;
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void _updateImageURL() {
    if ((!_imageUrlController.text.startsWith('http') &&
            !_imageUrlController.text.startsWith('https')) ||
        (!_imageUrlController.text.endsWith('.png') &&
            !_imageUrlController.text.endsWith('.jpg') &&
            !_imageUrlController.text.endsWith('.jpeg'))) {
      _isValidURL = false;
    } else {
      _isValidURL = true;
    }
    if (!_imageURLfocusNode.hasFocus) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _imageURLfocusNode.removeListener(_updateImageURL);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageURLfocusNode.dispose();
    super.dispose();
  }

  Future<void> _errorThrown() {
    setState(() {
      _isLoading = false;
    });
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('An Error has ocurred'),
        content: Text('Something went wrong.' /*+ error.toString()*/),
        actions: [
          FlatButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: Text('OK')),
        ],
      ),
    );
  }

  void _saveForm() async {
    bool validForm = _form.currentState.validate();

    if (!validForm) return;

    _form.currentState.save();

    setState(() {
      _isLoading = true;
    });

    if (_editedProduct.id == null) {
      await Provider.of<Products>(context, listen: false)
          .addProductAsync(_editedProduct)
          .catchError((error) {
        _errorThrown();
      });
    } else {
      await Provider.of<Products>(context, listen: false)
          .updateProduct(_editedProduct.id, _editedProduct)
          .catchError((error) {
        _errorThrown();
      });
    }

    setState(() {
      _isLoading = true;
    });
    Navigator.of(context).pop();

    //Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Form(
              key: _form,
              child: ListView(
                children: [
                  TextFormField(
                    initialValue: _initValues['title'],
                    decoration: InputDecoration(
                        labelText: 'Title',
                        errorStyle: TextStyle(
                          fontFamily: 'Lato',
                        )),
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_priceFocusNode);
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please provide a value!';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _editedProduct = Product(
                          id: _editedProduct.id,
                          title: value,
                          description: _editedProduct.description,
                          price: _editedProduct.price,
                          imageUrl: _editedProduct.imageUrl,
                          isFavorite: _editedProduct.isFavorite);
                    },
                  ),
                  TextFormField(
                    initialValue: _initValues['price'],
                    decoration: InputDecoration(labelText: 'Price'),
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    focusNode: _priceFocusNode,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please provide a price!';
                      } else if (double.tryParse(value) == null) {
                        return 'Please provide a valid number!';
                      } else if (double.parse(value) < 0.01) {
                        return 'The price should\'t be at least 0.01!';
                      }

                      return null;
                    },
                    onSaved: (value) {
                      _editedProduct = Product(
                        id: _editedProduct.id,
                        title: _editedProduct.title,
                        description: _editedProduct.description,
                        price: double.parse(value),
                        imageUrl: _editedProduct.imageUrl,
                        isFavorite: _editedProduct.isFavorite,
                      );
                    },
                    onFieldSubmitted: (_) {
                      FocusScope.of(context)
                          .requestFocus(_descriptionFocusNode);
                    },
                  ),
                  TextFormField(
                    initialValue: _initValues['description'],
                    decoration: InputDecoration(labelText: 'Description'),
                    maxLines: 5,
                    keyboardType: TextInputType.multiline,
                    focusNode: _descriptionFocusNode,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter the descripton!';
                      } else if (value.length < 10) {
                        return 'Should be at least 10 character long!';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _editedProduct = Product(
                        id: _editedProduct.id,
                        title: _editedProduct.title,
                        description: value,
                        price: _editedProduct.price,
                        imageUrl: _editedProduct.imageUrl,
                        isFavorite: _editedProduct.isFavorite,
                      );
                    },
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        margin: EdgeInsets.only(
                          top: 8,
                          right: 10,
                        ),
                        decoration: BoxDecoration(
                            border: Border.all(
                          width: 1,
                          color: Colors.grey,
                        )),
                        child: _imageUrlController.text.isEmpty || !_isValidURL
                            ? Text('Enter a URL')
                            : FittedBox(
                                child: Image.network(_imageUrlController.text),
                                fit: BoxFit.cover,
                              ),
                      ),
                      Expanded(
                        child: TextFormField(
                          decoration: InputDecoration(labelText: 'Image URL'),
                          keyboardType: TextInputType.url,
                          textInputAction: TextInputAction.done,
                          controller: _imageUrlController,
                          focusNode: _imageURLfocusNode,
                          onEditingComplete: () {
                            setState(() {});
                          },
                          onFieldSubmitted: (_) {
                            _saveForm();
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Provide a image URL';
                            } else if (!value.startsWith('http') &&
                                !value.startsWith('https')) {
                              return 'Please, enter a valid URL';
                            } else if (!value.endsWith('.png') &&
                                !value.endsWith('.jpg') &&
                                !value.endsWith('.jpeg')) {
                              return 'Please, enter a valid Image URL (png, jpg, jpeg)';
                            }

                            return null;
                          },
                          onSaved: (value) {
                            _editedProduct = Product(
                              id: _editedProduct.id,
                              title: _editedProduct.title,
                              description: _editedProduct.description,
                              price: _editedProduct.price,
                              imageUrl: value,
                              isFavorite: _editedProduct.isFavorite,
                            );
                          },
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
          _isLoading ? LoadingOverlay('Saving this content...') : SizedBox(),
        ],
      ),
    );
  }
}
