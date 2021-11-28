import 'package:flutter/material.dart';
import 'package:miaged/models/product.dart';
import 'package:miaged/screens/product-card.dart';
import 'package:miaged/shared/constants.dart';
import 'package:provider/provider.dart';

class ProductList extends StatefulWidget {
  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  final List<String> sizes = ['XS', 'S', 'M', 'L', 'XL'];
  final List<String> categories = [
    'All',
    'Shirts',
    'Pants',
    'Hats',
    'Jackets',
    'Other'
  ];
  String searchedItem = '';
  String selectedCategory = 'All'; // default

  List<Product> searchedProducts;

  bool correspondingProduct(Product e) {
    if (selectedCategory != 'All') {
      return e.name.toLowerCase().contains(searchedItem.toLowerCase()) &&
          e.category == selectedCategory;
    } else {
      return e.name.toLowerCase().contains(searchedItem.toLowerCase());
    }
  }

  void searchProduct(List<Product> products) {
    setState(() {
      searchedProducts =
          products.where((e) => correspondingProduct(e)).toList();
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
          // AJOUTER BAR
          AppBar(
            title: Text(
              "Category",
              style: TextStyle(
                fontSize: 14,
              ),
            ),
            actions: [
              //SelectCategoryWidget(),
              Container(
                margin: EdgeInsets.only(right: 20),
                width: 100,
                child: ButtonTheme(
                  alignedDropdown: true,
                  child: DropdownButton(
                    dropdownColor: Colors.blue,
                    icon: const Icon(
                      Icons.arrow_downward,
                      color: Colors.white,
                    ),
                    iconSize: 24,
                    elevation: 16,
                    style: const TextStyle(color: Colors.white),
                    underline: Container(
                      height: 2,
                      color: Colors.white,
                    ),
                    value: selectedCategory,
                    items: categories
                        .map(
                          (cat) => DropdownMenuItem(
                            value: cat,
                            child: Text(
                              '$cat',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (val) {
                      setState(() {
                        selectedCategory = val;
                        if (selectedCategory != 'All') {
                          searchProduct(products);
                        } else {
                          print("all selected");
                        }
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
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
                  name: searchedProducts[i].name,
                  price: searchedProducts[i].price,
                  description: searchedProducts[i].description,
                  imageUrl: searchedProducts[i].imageUrl,
                  seller: searchedProducts[i].seller,
                  size: searchedProducts[i].size,
                  category: searchedProducts[i].category,
                  brand: searchedProducts[i].brand,
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
