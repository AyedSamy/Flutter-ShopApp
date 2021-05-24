import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tutorial/services/database.dart';
import 'package:flutter_tutorial/shared/constants.dart';
import 'package:image_picker/image_picker.dart';

import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';

class AddItem extends StatefulWidget {
  @override
  _AddItemState createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  final _storage = FirebaseStorage.instance;
  PickedFile _imageFile;
  final ImagePicker _picker = ImagePicker();
  File _file;

  String imageUrl;

  final _formKey = GlobalKey<FormState>();

  //text field state
  String productName = '';
  String description = '';
  double price;
  String error = '';

  void takePhoto(ImageSource source) async {
      final pickedFile = await _picker.getImage(source: source);
      setState(() {
        _imageFile = pickedFile;
        _file = File(pickedFile.path);
      });
    }

  @override
  Widget build(BuildContext context) {
    void _showImageOptions() {
      showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: 110,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: Column(
              children: [
                Text("Choose an image for your product"),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton.icon(
                      onPressed: () {
                        takePhoto(ImageSource.camera);
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.camera),
                      label: Text("Camera"),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        takePhoto(ImageSource.gallery);
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.image),
                      label: Text("Gallery"),
                    )
                  ],
                ),
              ],
            ),
          );
        },
      );
    }

    

    return ListView(children: [
      Container(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: _imageFile == null ? AssetImage('assets/default-item.jpg') : FileImage(_file),
                  ),
                  Positioned(
                    bottom: 20,
                    right: 20,
                    child: InkWell(
                      onTap: _showImageOptions,
                      child: Icon(
                        Icons.camera_alt,
                        color: Colors.teal,
                        size: 28,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                decoration:
                    textInputDecoration.copyWith(hintText: 'Product name'),
                validator: (val) =>
                    val.isEmpty ? "Enter the product name" : null,
                onChanged: (val) {
                  setState(() {
                    productName = val;
                  });
                },
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                validator: (val) => val.isEmpty ? "Enter a price" : null,
                onChanged: (val) {
                  setState(() {
                    val = val.replaceAll('.', '');
                    val = val.replaceAll(',', '.');
                    if (val != '') price = double.parse(val);
                    print(val);
                  });
                },
                inputFormatters: [
                  CurrencyTextInputFormatter(
                      locale: 'es',
                      decimalDigits: 2,
                      symbol: '', // or to remove symbol set ''.
                      name: 'EUR')
                ],
                keyboardType: TextInputType.number,
                decoration: textInputDecoration.copyWith(hintText: 'Price (€)'),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                decoration:
                    textInputDecoration.copyWith(hintText: 'Description'),
                validator: (val) => val.isEmpty ? "Enter a description" : null,
                onChanged: (val) {
                  setState(() {
                    description = val;
                  });
                },
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                child: Text("Add item"),
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    await DatabaseService().updateProductData(1, description, productName, price);
                    if(_imageFile != null){
                      var snapshot = await _storage.ref()
                      .child('productsImages/$productName')
                      .putFile(_file);
                      var downloadUrl = await snapshot.ref.getDownloadURL();
                      
                      setState(() {
                        imageUrl = downloadUrl;
                      });
                    }
                    Navigator.pop(context);
                  }
                  
                },
                style: ElevatedButton.styleFrom(
                  textStyle: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(
                height: 12,
              ),
              Text(
                error,
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
      ),
    ]);
  }
}
