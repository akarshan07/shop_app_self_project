import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';
import '../providers/product.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product-screen';

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  var _existingItem =
      Product(id: '', title: '', price: 0, description: '', imageUrl: '');
  final _form = GlobalKey<FormState>();
  var _isInit = true;
  var _isLoading = false;
  var _initialValue = {
    'title': '',
    'price': '',
    'description': '',
    'imageUrl': '',
  };

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      String productId =
          ModalRoute.of(context)?.settings.arguments.toString() as String;
      if (productId != 'null') {
        _existingItem = Provider.of<Products>(context).findById(productId);
        _initialValue = {
          'title': _existingItem.title,
          'price': _existingItem.price.toString(),
          'description': _existingItem.description,
          'imageUrl': '',
        };
        _imageUrlController.text = _existingItem.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _priceFocusNode.dispose();
    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus ||
        (_imageUrlController.text.isEmpty) ||
        (!_imageUrlController.text.startsWith('http') &&
            !_imageUrlController.text.startsWith('https'))) {
      setState(() {});
    }
  }

  Future<void> _saveForm() async{
    final isValid = _form.currentState?.validate() ?? false;
    setState(() {
      _isLoading = true;
    });
    if (!isValid) {
      return;
    }
    _form.currentState?.save();
    if (_existingItem.id != '') {
      await Provider.of<Products>(context, listen: false).updateProduct(_existingItem.id, _existingItem);
      Navigator.of(context).pop();
    } else {
      try{
        await Provider.of<Products>(context, listen: false).addProduct(_existingItem);
      }catch(error){
        await showDialog<Null>(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text('Error Occured!'),
              content: Text('Something went wrong.'),
              actions: [
                TextButton(onPressed: (){
                  Navigator.of(ctx).pop();
                }, child: Text('Okay')),
              ],
            ));
      };
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop();

    }
    // Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product'),
        actions: [
          IconButton(
              onPressed: () {
                _saveForm();
              },
              icon: Icon(Icons.save)),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _form,
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: _initialValue['title'],
                      decoration: InputDecoration(labelText: 'Title'),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter title';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _existingItem = Product(
                          id: _existingItem.id,
                          title: value.toString(),
                          price: _existingItem.price,
                          description: _existingItem.description,
                          imageUrl: _existingItem.imageUrl,
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: _initialValue['price'],
                      decoration: InputDecoration(labelText: 'Price'),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      focusNode: _priceFocusNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(_descriptionFocusNode);
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter some amount!';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Enter a valid number';
                        }
                        if (double.parse(value) <= 0) {
                          return 'Enter price greater then 0';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _existingItem = Product(
                          id: _existingItem.id,
                          isFavorite: _existingItem.isFavorite,
                          title: _existingItem.title,
                          price: double.parse(value!),
                          description: _existingItem.description,
                          imageUrl: _existingItem.imageUrl,
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: _initialValue['description'],
                      decoration: InputDecoration(labelText: 'Discription'),
                      keyboardType: TextInputType.multiline,
                      maxLines: 3,
                      focusNode: _descriptionFocusNode,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter some text';
                        }
                        if (value.length <= 10) {
                          return 'Enter description atleast 10 characters long';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _existingItem = Product(
                          id: _existingItem.id,
                          isFavorite: _existingItem.isFavorite,
                          title: _existingItem.title,
                          price: _existingItem.price,
                          description: value.toString(),
                          imageUrl: _existingItem.imageUrl,
                        );
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          height: 100,
                          width: 100,
                          margin: EdgeInsets.only(
                            top: 8,
                            right: 10,
                          ),
                          decoration: BoxDecoration(
                              border: Border.all(width: 1, color: Colors.grey)),
                          child: _imageUrlController.text.isEmpty
                              ? Text('No Image')
                              : Image.network(
                                  _imageUrlController.text,
                                  fit: BoxFit.cover,
                                ),
                        ),
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(labelText: 'ImageUrl'),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            controller: _imageUrlController,
                            focusNode: _imageUrlFocusNode,
                            onEditingComplete: () {
                              setState(() {});
                            },
                            onFieldSubmitted: (_) {
                              _saveForm();
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Enter some url!';
                              }
                              if (!value.startsWith('http') &&
                                  !value.startsWith('https')) {
                                return 'Enter a valid url';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _existingItem = Product(
                                id: _existingItem.id,
                                title: _existingItem.title,
                                isFavorite: _existingItem.isFavorite,
                                price: _existingItem.price,
                                description: _existingItem.description,
                                imageUrl: value.toString(),
                              );
                            },
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
