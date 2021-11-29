import 'package:flutter/material.dart';
import 'package:miaged/models/user-cart.dart';
import 'package:miaged/models/user.dart';
import 'package:miaged/screens/cart-detail.dart';
import 'package:miaged/services/database.dart';
import 'package:miaged/shared/loading.dart';
import 'package:provider/provider.dart';
import 'dart:math';

double roundDouble(double value, int places) {
  double mod = pow(10.0, places);
  return ((value * mod).round().toDouble() / mod);
}

class Cart extends StatefulWidget {
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  @override
  Widget build(BuildContext context) {
    void _showCartDetailPanel(UserCartData userCartData) {
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return Container(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: CartDetail(userCartData),
            );
          });
    }

    final user = Provider.of<TheUser>(context);

    if (user == null) {
      return SizedBox.shrink();
    }

    return StreamBuilder<UserCartData>(
      stream: DatabaseService(uid: user.uid).userCartData,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          UserCartData userCartData = snapshot.data;

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton.icon(
                onPressed: () => _showCartDetailPanel(userCartData),
                icon: Icon(Icons.arrow_forward_ios),
                label: Text("My Cart"),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.blue[900]),
                  elevation: MaterialStateProperty.all(0),
                ),
              ),
              Container(
                margin: EdgeInsets.only(right: 20),
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    children: [
                      TextSpan(
                        text: 'Total : ',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      TextSpan(
                        text: "${roundDouble(userCartData.totalCartPrice, 2)}€",
                        style: TextStyle(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        } else {
          return Loading();
        }
      },
    );
  }
}
