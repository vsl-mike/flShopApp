import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';

class EditProduct extends StatefulWidget {
  static const String routeName = '/edit-product';
  final _focusPrice = FocusNode();
  final _focusDescription = FocusNode();
  final _focusImageUrl = FocusNode();

  @override
  _EditProductState createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  bool isLoad = false;
  bool isEditExistProduct = false;
  String productID;
  var _form = GlobalKey<FormState>();
  var imageUrlController = TextEditingController();
  var newProduct = Product(
    id: null,
    description: '',
    imageUrl: '',
    price: 0,
    title: '',
  );

  @override
  void initState() {
    widget._focusImageUrl.addListener(listnerImageUrl);

    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (isLoad == false) {
      productID = ModalRoute.of(context).settings.arguments as String;
      if (productID != 'null') {
        newProduct =
            Provider.of<Products>(context, listen: false).getByID(productID);
        imageUrlController.text = newProduct.imageUrl;
        isLoad = true;
        isEditExistProduct = true;
      } else {
        isLoad = true;
      }
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    widget._focusImageUrl.removeListener(listnerImageUrl);
    widget._focusPrice.dispose();
    widget._focusDescription.dispose();
    widget._focusImageUrl.dispose();
    super.dispose();
  }

  void saveState() {
    bool isValid = _form.currentState.validate();
    if (!isValid) return;
    newProduct = Product(
        id: DateTime.now().toString(),
        description: newProduct.description,
        imageUrl: imageUrlController.text,
        price: newProduct.price,
        title: newProduct.title);
    _form.currentState.save();
    isEditExistProduct
        ? Provider.of<Products>(context, listen: false)
            .updateItem(productID, newProduct)
        : Provider.of<Products>(context, listen: false).addProduct(newProduct);
    Navigator.of(context).pop();
  }

  void listnerImageUrl() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.save),
              onPressed: () {
                saveState();
              })
        ],
      ),
      body: Form(
        key: _form,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFormField(
                  initialValue: isEditExistProduct ? newProduct.title : '',
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(labelText: 'Title'),
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(widget._focusPrice);
                  },
                  validator: (value) {
                    if (value.isEmpty) return 'No title !';
                    return null;
                  },
                  onSaved: (value) {
                    newProduct = Product(
                        id: null,
                        description: newProduct.description,
                        imageUrl: newProduct.imageUrl,
                        price: newProduct.price,
                        title: value);
                  },
                ),
                TextFormField(
                  initialValue:
                      isEditExistProduct ? newProduct.price.toString() : '',
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(labelText: 'Price'),
                  keyboardType: TextInputType.number,
                  focusNode: widget._focusPrice,
                  validator: (value) {
                    if (value.isEmpty) return 'No price !';
                    if (double.tryParse(value) == null)
                      return 'Price must be a double';
                    else {
                      if (double.parse(value) <= 0)
                        return 'Price must be greater than 0';
                      else
                        return null;
                    }
                  },
                  onFieldSubmitted: (_) {
                    FocusScope.of(context)
                        .requestFocus(widget._focusDescription);
                  },
                  onSaved: (value) {
                    newProduct = Product(
                        id: null,
                        description: newProduct.description,
                        imageUrl: newProduct.imageUrl,
                        price: double.parse(value),
                        title: newProduct.title);
                  },
                ),
                TextFormField(
                  initialValue:
                      isEditExistProduct ? newProduct.description : '',
                  decoration: InputDecoration(labelText: 'Description'),
                  keyboardType: TextInputType.multiline,
                  maxLines: 3,
                  focusNode: widget._focusDescription,
                  validator: (value) {
                    if (value.isEmpty) return 'No descriptions !';
                    if (value.length < 10)
                      return 'Must be at least 10 caracters';
                    return null;
                  },
                  onSaved: (value) {
                    newProduct = Product(
                        id: null,
                        description: value,
                        imageUrl: newProduct.imageUrl,
                        price: newProduct.price,
                        title: newProduct.title);
                  },
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1,
                          color: Colors.grey,
                        ),
                      ),
                      height: 120,
                      width: 120,
                      child: imageUrlController.text.isEmpty
                          ? Text('No image')
                          : FittedBox(
                              child: Image.network(imageUrlController.text),
                              fit: BoxFit.cover,
                            ),
                    ),
                    Container(
                      margin: EdgeInsets.all(8),
                      width: 230,
                      child: TextFormField(
                        decoration: InputDecoration(labelText: 'ImageURL'),
                        keyboardType: TextInputType.url,
                        controller: imageUrlController,
                        focusNode: widget._focusImageUrl,
                        textInputAction: TextInputAction.done,
                        validator: (value) {
                          if (value.isEmpty) return 'No imageURL !';
                          if (!value.startsWith('http://') &&
                              !value.startsWith('https://'))
                            return 'Url must starts with HTTP or HTTPS';
                          if (!value.endsWith('.jpg') &&
                              !value.endsWith('.png') &&
                              !value.endsWith('.jpeg'))
                            return 'Image can be png, jpeg or jpg';
                          return null;
                        },
                        onFieldSubmitted: (_) {
                          saveState();
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
