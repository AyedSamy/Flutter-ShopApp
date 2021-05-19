import 'package:flutter/material.dart';
import 'package:flutter_tutorial/models/product.dart';
import 'package:flutter_tutorial/models/user.dart';
import 'package:flutter_tutorial/screens/product-list.dart';
import 'package:flutter_tutorial/services/auth.dart';
import 'package:flutter_tutorial/services/database.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService _auth = AuthService();

  List<Product> products = [
    Product(id: 1, name: "Classic kite", price: 34),
    Product(id: 2, name: "Dragon kite", price: 40),
    Product(id: 2, name: "Dragon kite", price: 40)
  ];

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<TheUser>(context);

    return StreamProvider<List<Product>>.value(
      initialData: [],
      value: DatabaseService().products,
      child: Scaffold(
        backgroundColor: Colors.blue[900],
        appBar: AppBar(
          title: Text("Kite Shop"),
          backgroundColor: Colors.blue[800],
          elevation: 0.0,
          actions: [
            TextButton.icon(
              onPressed: () async {
                user == null
                    ? Navigator.pushNamed(context, "/signIn")
                    : await _auth.signOut();
              },
              icon: Icon(Icons.person),
              label: user == null ? Text("Login") : Text("Logout"),
            ),
            if (user == null)
              TextButton.icon(
                onPressed: () async {
                  Navigator.pushNamed(context, "/register");
                },
                icon: Icon(Icons.person),
                label: Text("Register"),
              ),
          ],
        ),
        body: Column(
          children: [
            Text("Check your cart"),
            ProductList(),
          ],
        ),
        
      ),
    );
  }
}
