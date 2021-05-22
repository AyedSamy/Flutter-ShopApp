import 'package:flutter/material.dart';
import 'package:flutter_tutorial/models/user-cart.dart';
import 'package:flutter_tutorial/models/user.dart';
import 'package:flutter_tutorial/services/database.dart';
import 'package:provider/provider.dart';

class CartDetail extends StatefulWidget {
  final UserCartData userCartData;

  CartDetail(this.userCartData);

  @override
  _CartDetailState createState() => _CartDetailState();
}

class _CartDetailState extends State<CartDetail> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<TheUser>(context);

    var selectedProductsNames = [...widget.userCartData.selectedProducts.keys];

    //print(selectedProductsNames);

    return Column(
      children: [
        Center(
          child: Text(
            "My Cart",
            style: TextStyle(fontSize: 18),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: selectedProductsNames.length,
            itemBuilder: (context, i) {
              return ListTile(
                leading: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    if (user != null) {
                      widget.userCartData.totalCartPrice -= widget.userCartData.selectedProducts[selectedProductsNames[i]]['quantity'] * widget.userCartData.selectedProducts[selectedProductsNames[i]]['unit_price'];
                      setState(() {
                        widget.userCartData.selectedProducts.remove(selectedProductsNames[i]);                 
                      });
                      
                      DatabaseService(uid: user.uid).updateUserCartData(widget.userCartData.selectedProducts, widget.userCartData.totalCartPrice);
                    }
                  },
                ),
                title: Text(
                  "• ${selectedProductsNames[i]} x${widget.userCartData.selectedProducts[selectedProductsNames[i]]['quantity']} - ${widget.userCartData.selectedProducts[selectedProductsNames[i]]['unit_price']}€",
                ),
                subtitle: Text(
                    "Subtotal: ${widget.userCartData.selectedProducts[selectedProductsNames[i]]['quantity'] * widget.userCartData.selectedProducts[selectedProductsNames[i]]['unit_price']}€"),
              );
            },
          ),
        ),
        Container(
            margin: EdgeInsets.only(bottom: 30),
            child: Text("Total : ${widget.userCartData.totalCartPrice}€"))
      ],
    );
  }
}
