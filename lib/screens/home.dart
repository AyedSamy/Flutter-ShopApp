import 'package:flutter/material.dart';
import 'package:flutter_tutorial/models/product.dart';
import 'package:flutter_tutorial/models/user.dart';
import 'package:flutter_tutorial/screens/add-item.dart';
import 'package:flutter_tutorial/screens/cart.dart';
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

  @override
  Widget build(BuildContext context) {
    void _showAddItemPanel() {
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return Container(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: AddItem(),
            );
          });
    }

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
            ElevatedButton.icon(
              onPressed: () async {
                user == null
                    ? Navigator.pushNamed(context, "/signIn")
                    : await _auth.signOut();
              },
              icon: Icon(Icons.person),
              label: user == null ? Text("Login") : Text("Logout"),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.blue[800]),
                elevation: MaterialStateProperty.all(0),
              ),
            ),
            if (user == null)
              ElevatedButton.icon(
                onPressed: () async {
                  Navigator.pushNamed(context, "/register");
                },
                icon: Icon(Icons.person_add_alt),
                label: Text("Register"),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.blue[800]),
                  elevation: MaterialStateProperty.all(0),
                ),
              ),
          ],
        ),
        body: Column(
          children: [
            Cart(),
            ProductList(),
          ],
        ),
        floatingActionButton: user != null ? FloatingActionButton.extended(
          onPressed: _showAddItemPanel,
          label: const Text('Add item'),
          icon: const Icon(Icons.add),
          backgroundColor: Colors.blue,
        ) : SizedBox.shrink(),
      ),
    );
  }
}
