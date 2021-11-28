import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:miaged/screens/product-detail.dart';

class ProductCard extends StatelessWidget {
  final int id;
  final String name;
  final String description;
  final dynamic price;
  final String imageUrl;
  final String seller;
  final String size;
  final String category;
  final Function delete;

  ProductCard(
      {this.id,
      this.name,
      this.description,
      this.price,
      this.imageUrl,
      this.seller,
      this.size,
      this.category,
      this.delete});

  @override
  Widget build(BuildContext context) {
    void _showDetailPanel() {
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 60, vertical: 20),
              child: ProductDetail(
                name: name,
                description: description,
                price: price,
                imageUrl: imageUrl,
                seller: seller,
                size: size,
                category: category,
              ),
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
                  backgroundImage: NetworkImage(imageUrl),
                  radius: 40.0,
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Text(
                '$name', // PRODUCT NAME
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
                      onPressed: () {
                        _showDetailPanel();
                      },
                      icon: Icon(Icons.dehaze),
                      label: Text("See details")),
                ],
              ),
              SizedBox(
                height: 10.0,
              ),
              Text(
                'Seller : $seller', // Seller
                style: TextStyle(
                  color: Colors.blue[800],
                  letterSpacing: 1.0,
                ),
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
