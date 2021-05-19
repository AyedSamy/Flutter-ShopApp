import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tutorial/models/user-cart.dart';
import 'package:flutter_tutorial/models/user.dart';
import 'package:flutter_tutorial/services/auth.dart';
import 'package:flutter_tutorial/services/database.dart';
import 'package:flutter_tutorial/shared/loading.dart';
import 'package:provider/provider.dart';

class ProductDetail extends StatefulWidget {
  final int id;
  final String name;
  final String description;
  final int price;

  ProductDetail({this.id, this.name, this.description, this.price});

  @override
  _ProductDetailState createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  final _formKey = GlobalKey<FormState>();

  int quantity = 0;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<TheUser>(context);

    if (user == null) {
      return ListView(
        children: [
          Center(
            child: Text(
              widget.name,
              style: TextStyle(fontSize: 18),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Image.asset(
            'assets/kite-${widget.id}.jpg',
            height: 100,
            width: 100,
          ),
          SizedBox(
            height: 10,
          ),
          RichText(
            text: TextSpan(
              style: TextStyle(color: Colors.black),
              children: [
                TextSpan(text: 'Description : ', style: TextStyle(fontWeight: FontWeight.bold,),),
                TextSpan(text: "${widget.description}"),
              ]
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 10,
          ),
          Center(
            child: Text(
              "Create an account to add this item to your cart and make an order",
              textAlign: TextAlign.center,
            ),
          ),
        ],
      );
    }

    return StreamBuilder<UserCartData>(
      stream: DatabaseService(uid: user.uid).userCartData,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          UserCartData userCartData = snapshot.data;
          return Form(
            key: _formKey,
            child: ListView(
              children: [
                Center(
                  child: Text(
                    widget.name,
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Image.asset(
                  'assets/kite-${widget.id}.jpg',
                  height: 100,
                  width: 100,
                ),
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: Text(
                    "Quantity of this product in your cart : ${userCartData.productQuantity.containsKey(widget.name) ? userCartData.productQuantity[widget.name] : 0}",
                    style: TextStyle(fontSize: 13),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      width: 100,
                      child: TextFormField(
                        validator: (val) =>
                            int.parse(val) > 99 ? "99 items max." : null,
                        decoration: InputDecoration(
                          labelText: "Enter your quantity",
                          labelStyle: TextStyle(fontSize: 11),
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ], // Only numbers can be entered
                        onChanged: (val) {
                          setState(() {
                            quantity = int.parse(val);
                          });
                        },
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    ElevatedButton.icon(
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          if (userCartData.productQuantity
                              .containsKey(widget.name)) {
                            userCartData.productQuantity[widget.name] +=
                                quantity;
                          } else {
                            userCartData.productQuantity[widget.name] =
                                quantity;
                          }
                          DatabaseService(uid: user.uid)
                              .updateUserCartData(userCartData.productQuantity);
                          //Navigator.pop(context);
                        }
                      },
                      icon: Icon(Icons.shopping_cart),
                      label: Text("Add to cart"),
                    )
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                ElevatedButton.icon(
                    onPressed: () {},
                    icon: Icon(Icons.remove),
                    label: Text("Remove from cart"))
              ],
            ),
          );
        } else {
          return Loading();
        }
      },
    );
  }
}
