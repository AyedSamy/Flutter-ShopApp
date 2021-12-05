import 'package:flutter/material.dart';
import 'package:miaged/services/auth.dart';
import 'package:miaged/shared/constants.dart';
import 'package:miaged/shared/loading.dart';

class Register extends StatefulWidget {
  final Function toggleView;

  Register({this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  bool loading = false;

  //text field state
  String firstname = '';
  String lastname = '';
  String email = '';
  String password = '';
  String error = '';
  //default fields
  DateTime birthday = DateTime.utc(1970, 1, 1);
  String address = 'NA';
  String postalcode = 'NA';
  String city = 'NA';

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Colors.blue[200],
            appBar: AppBar(
              centerTitle: true,
              title: Text("Sign up to MIAGED"),
              backgroundColor: Colors.blue[800],
              elevation: 0.0,
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
                      TextFormField(
                        decoration:
                            textInputDecoration.copyWith(hintText: 'Last name'),
                        validator: (val) =>
                            val.isEmpty ? "Enter your last name" : null,
                        onChanged: (val) {
                          setState(() {
                            lastname = val;
                          });
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        decoration:
                            textInputDecoration.copyWith(hintText: 'Email'),
                        validator: (val) =>
                            val.isEmpty ? "Enter an email" : null,
                        onChanged: (val) {
                          setState(() {
                            email = val;
                          });
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        decoration:
                            textInputDecoration.copyWith(hintText: 'Password'),
                        validator: (val) => val.length < 6
                            ? "Enter a password 6+ chars long"
                            : null,
                        obscureText: true,
                        onChanged: (val) {
                          setState(() {
                            password = val;
                          });
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        child: Text("Register"),
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            setState(() {
                              loading = true;
                            });
                            dynamic result =
                                await _auth.registerWithEmailAndPassword(
                                    email,
                                    password,
                                    firstname,
                                    lastname,
                                    birthday,
                                    address,
                                    postalcode,
                                    city);
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
