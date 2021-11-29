import 'package:flutter/material.dart';
import 'package:miaged/models/user.dart';
import 'package:miaged/services/auth.dart';
import 'package:miaged/services/database.dart';
import 'package:miaged/shared/constants.dart';
import 'package:miaged/shared/loading.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final AuthService _auth = AuthService();
  final DatabaseService _db = DatabaseService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  //text field state
  String firstname = '';
  String lastname = '';
  String email = '';
  String password = '';
  String error = '';
  List<String> id;
  TheUser user;

  //String seller = await DatabaseService().getSeller(user.uid);

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Colors.blue[200],
            appBar: AppBar(
              title: Text("Profile"),
              backgroundColor: Colors.blue[800],
              elevation: 0.0,
              actions: [
                ElevatedButton(
                  child: Text("Validate"),
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      setState(() {
                        loading = true;
                      });
                      dynamic result =
                          await _auth.updateEmailAndPassword(email, password);
                      if (result == null) {
                        setState(() {
                          loading = false;
                          error = "Please supply a valid email";
                        });
                      } else {
                        print(email);
                        print(password);
                        Navigator.pop(context);
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    textStyle: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            body: ListView(children: [
              Container(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        initialValue: '',
                        decoration: textInputDecoration.copyWith(
                            hintText: 'First name'),
                        validator: (val) =>
                            val.isEmpty ? "Enter your first name" : null,
                        onChanged: (val) {
                          setState(() {
                            firstname = val;
                          });
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Text(
                        error,
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
              ),
            ]),
          );
  }
}
