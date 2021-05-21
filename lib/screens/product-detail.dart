import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tutorial/models/user-cart.dart';
import 'package:flutter_tutorial/models/user.dart';
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

    if (user == null) { // If no user is logged, we invite the user to create an account to make an order
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
            text: TextSpan(style: TextStyle(color: Colors.black), children: [
              TextSpan(
                text: 'Description : ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(text: "${widget.description}"),
            ]),
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

    return StreamBuilder<UserCartData>( // if a user is logged, we retrieve his user cart data from firebase thanks to StreamBuilder and a get method in database service
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
                RichText(
                  text: TextSpan(
                    style: TextStyle(color: Colors.black),
                    children: [
                      TextSpan(
                        text: 'Description : ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(text: "${widget.description}"),
                    ],
                  ),  
                ),
                SizedBox(
                  height: 10,
                ),
                RichText(
                  text: TextSpan(
                    style: TextStyle(color: Colors.black),
                    children: [
                      TextSpan(
                        text: 'Price : ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(text: "${widget.price}€"),
                    ],
                  ),  
                ),
                SizedBox(height: 15,),
                Center(
                  child: Text(
                    "Quantity in your cart : ${userCartData.selectedProducts.containsKey(widget.name) ? userCartData.selectedProducts[widget.name]['quantity'] : 0}",
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
                        validator: (val) {
                          if (val == "" || val == null) {
                            return "1 item min.";
                          } else if (int.parse(val) > 99) {
                            return "99 items max.";
                          } else {
                            return null;
                          }
                        },
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
                            if (val != "" && val != null) {
                              quantity = int.parse(val);
                            }
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
                          if (userCartData.selectedProducts
                              .containsKey(widget.name)) {
                            userCartData.selectedProducts[widget.name]['quantity'] += quantity;
                            userCartData.selectedProducts[widget.name]['total_price'] += quantity * widget.price;
                          } else {
                            userCartData.selectedProducts[widget.name] = {};
                            userCartData.selectedProducts[widget.name]['quantity'] = quantity;
                            userCartData.selectedProducts[widget.name]['total_price'] = quantity * widget.price;
                          }
                          double totalCartPrice = 0.0;
                          userCartData.selectedProducts[widget.name]['unit_price'] = widget.price;
                          userCartData.selectedProducts.forEach((productName, info) {
                            totalCartPrice += info['unit_price'] * info['quantity'];
                          });
                          userCartData.totalCartPrice = totalCartPrice;
                          DatabaseService(uid: user.uid)
                              .updateUserCartData(userCartData.selectedProducts, userCartData.totalCartPrice);
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
                    onPressed: () async {
                      if(userCartData.selectedProducts.containsKey(widget.name)){
                        userCartData.totalCartPrice -= userCartData.selectedProducts[widget.name]['quantity'] * userCartData.selectedProducts[widget.name]['unit_price'];
                        userCartData.selectedProducts.remove(widget.name);
                        DatabaseService(uid: user.uid).updateUserCartData(userCartData.selectedProducts, userCartData.totalCartPrice);
                      }
                    },
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
