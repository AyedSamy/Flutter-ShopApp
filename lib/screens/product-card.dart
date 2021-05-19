import 'package:flutter/material.dart';
import 'package:flutter_tutorial/screens/product-detail.dart';

class ProductCard extends StatelessWidget {
  final int id;
  final String productName;
  final int price;
  final Function delete;

  ProductCard(this.id, this.productName, this.price, this.delete);

  @override
  Widget build(BuildContext context) {

    void _showDetailPanel() {
      showModalBottomSheet(context: context, builder: (context) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 60, vertical: 20),
          child: ProductDetail(),
        );
      });
    }

    return Container(
      width: 500,
      child: Card(
        margin: EdgeInsets.all(20),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 10.0,
              ),
              Center(
                child: CircleAvatar(
                  backgroundImage:
                      AssetImage('assets/kite-$id.jpg'), // GET IMAGE WITH ID
                  radius: 40.0,
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Text(
                '$productName', // PRODUCT NAME
                style: TextStyle(
                  color: Colors.blue[800],
                  letterSpacing: 1.0,
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Price : $price €', // PRICE
                    style: TextStyle(
                      color: Colors.blue[800],
                      letterSpacing: 1.0,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  ElevatedButton.icon(
                      onPressed: (){
                        _showDetailPanel();
                      },
                      icon: Icon(Icons.add_shopping_cart),
                      label: Text("Add to cart")),
                ],
              ),
              SizedBox(
                height: 10.0,
              ),
              ElevatedButton.icon(
                  onPressed: delete,
                  icon: Icon(Icons.delete),
                  label: Text("Delete")),
              SizedBox(
                height: 30.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
