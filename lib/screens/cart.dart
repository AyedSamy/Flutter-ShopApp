import 'package:flutter/material.dart';
import 'package:flutter_tutorial/models/user-cart.dart';
import 'package:flutter_tutorial/models/user.dart';
import 'package:flutter_tutorial/screens/cart-detail.dart';
import 'package:flutter_tutorial/services/database.dart';
import 'package:flutter_tutorial/shared/loading.dart';
import 'package:provider/provider.dart';

class Cart extends StatefulWidget {
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  @override
  Widget build(BuildContext context) {

    void _showCartDetailPanel(UserCartData userCartData) {
      showModalBottomSheet(context: context, builder: (context) {
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
              RichText(
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
                      text: "${userCartData.totalCartPrice}€",
                      style: TextStyle(),
                    ),
                  ],
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
