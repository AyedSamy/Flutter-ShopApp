import 'package:flutter/material.dart';
import 'package:flutter_tutorial/models/product.dart';
import 'package:flutter_tutorial/screens/product-card.dart';
import 'package:provider/provider.dart';

class ProductList extends StatefulWidget {
  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {

  @override
  Widget build(BuildContext context) {

    final products = Provider.of<List<Product>>(context);

    return ListView.builder(
          itemCount: products.length,
          itemBuilder: (context, i) {
            return ProductCard(
              products[i].id,
              products[i].name,
              products[i].price,
              () => setState(() {
                products.remove(products[i]);
              }),
            );
          },
        );
  }
}