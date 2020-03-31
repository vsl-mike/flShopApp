import 'package:flutter/material.dart';

class EditProduct extends StatefulWidget {
  static const String routeName = '/edit-product';
  final _focusPrice = FocusNode();
  final _focusDescription = FocusNode();
  @override
  _EditProductState createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  @override
  void dispose() {
    widget._focusPrice.dispose();
    widget._focusDescription.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit'),
      ),
      body: Form(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFormField(
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(labelText: 'Title'),
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(widget._focusPrice);
                  },
                ),
                TextFormField(
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(labelText: 'Price'),
                  keyboardType: TextInputType.number,
                  focusNode: widget._focusPrice,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context)
                        .requestFocus(widget._focusDescription);
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Description'),
                  keyboardType: TextInputType.multiline,
                  maxLines: 3,
                  focusNode: widget._focusDescription,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
