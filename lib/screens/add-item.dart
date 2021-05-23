import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tutorial/shared/constants.dart';

import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';

class AddItem extends StatefulWidget {
  @override
  _AddItemState createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  final _formKey = GlobalKey<FormState>();

  //text field state
  String productName = '';
  String description = '';
  double price;
  String error = '';

  @override
  Widget build(BuildContext context) {
    return ListView(children: [
      Container(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
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
                    //val = val.replaceAll(' €','');
                    val = val.replaceAll('.','');
                    val = val.replaceAll(',','.');
                    if(val != '')
                      price = double.parse(val);
                    print(val);
                  });
                },
                inputFormatters: [
                  CurrencyTextInputFormatter(
                    locale: 'es',
                    decimalDigits: 2,
                    symbol: '', // or to remove symbol set ''.
                    name: 'EUR'
                  )
                ],
                keyboardType: TextInputType.number,
                decoration: textInputDecoration.copyWith(hintText: 'Price (€)'),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                decoration: textInputDecoration.copyWith(hintText: 'Description'),
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
                onPressed: () async {},
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
