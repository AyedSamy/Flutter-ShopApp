import 'package:flutter/material.dart';
import 'package:flutter_tutorial/models/product.dart';
import 'package:flutter_tutorial/screens/product-card.dart';
import 'package:flutter_tutorial/shared/constants.dart';
import 'package:provider/provider.dart';

class ProductList extends StatefulWidget {
  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  String searchedItem = '';

  List<Product> searchedProducts;

  void searchProduct(List<Product> products) {
    setState(() {
      searchedProducts = products
          .where(
              (e) => e.name.toLowerCase().contains(searchedItem.toLowerCase()))
          .toList();
      print(searchedProducts);
    });
  }

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<List<Product>>(context);
    searchProduct(products);
    return Expanded(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                padding: EdgeInsets.only(right: 20, top: 5, bottom: 5),
                height: 50,
                width: 200,
                child: TextField(
                  decoration: textInputDecoration.copyWith(
                    hintText: 'Search',
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.black54,
                    ),
                    contentPadding: EdgeInsets.only(top: 0.0),
                  ),
                  onChanged: (val) {
                    setState(() {
                      searchedItem = val;
                      searchProduct(products);
                      print(searchedItem);
                    });
                  },
                ),
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: searchedProducts.length,
              itemBuilder: (context, i) {
                return ProductCard(
                  id: searchedProducts[i].id,
                  name: searchedProducts[i].name,
                  price: searchedProducts[i].price,
                  description: searchedProducts[i].description,
                  delete: () => setState(() {
                    searchedProducts.remove(searchedProducts[i]);
                  }),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
