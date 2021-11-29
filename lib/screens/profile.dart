import 'package:flutter/material.dart';
import 'package:miaged/services/auth.dart';
import 'package:miaged/shared/constants.dart';
import 'package:miaged/shared/loading.dart';
import 'package:date_field/date_field.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  //text field state
  String firstname = '';
  String lastname = '';
  String email = '';
  String password = '';
  String address = '';
  String postalcode = '';
  String city = '';
  DateTime birthday;
  String error = '';

  //String seller = await DatabaseService().getSeller(user.uid);

  @override
  Widget build(BuildContext context) {
    final Map data = ModalRoute.of(context).settings.arguments;
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
                        initialValue: data['firstname'],
                        decoration: textInputDecoration.copyWith(
                          focusedBorder: outlineWhite,
                          hintText: 'First name',
                          hintStyle: TextStyle(height: 2),
                          labelText: 'First name',
                          labelStyle: TextStyle(height: 4),
                        ),
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
                        initialValue: data['lastname'],
                        decoration: textInputDecoration.copyWith(
                          focusedBorder: outlineWhite,
                          hintText: 'Last name',
                          hintStyle: TextStyle(height: 2),
                          labelText: 'Last name',
                          labelStyle: TextStyle(height: 4),
                        ),
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
                        initialValue: data['email'],
                        decoration: textInputDecoration.copyWith(
                          focusedBorder: outlineWhite,
                          hintText: 'Email',
                          hintStyle: TextStyle(height: 2),
                          labelText: 'Email',
                          labelStyle: TextStyle(height: 4),
                        ),
                        validator: (val) =>
                            val.isEmpty ? "Enter your email" : null,
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
                        obscureText: true,
                        initialValue: data['password'],
                        decoration: textInputDecoration.copyWith(
                          focusedBorder: outlineWhite,
                          hintText: 'Password',
                          hintStyle: TextStyle(height: 2),
                          labelText: 'Password',
                          labelStyle: TextStyle(height: 4),
                        ),
                        validator: (val) =>
                            val.isEmpty ? "Enter your password" : null,
                        onChanged: (val) {
                          setState(() {
                            password = val;
                          });
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      DateTimeFormField(
                        mode: DateTimeFieldPickerMode.date,
                        decoration: textInputDecoration.copyWith(
                          focusedBorder: outlineWhite,
                          hintText: 'Birthday',
                          hintStyle: TextStyle(height: 2),
                          labelText: 'Birthday',
                          labelStyle: TextStyle(height: 4),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        initialValue: data['address'],
                        decoration: textInputDecoration.copyWith(
                          focusedBorder: outlineWhite,
                          hintText: 'Address',
                          hintStyle: TextStyle(height: 2),
                          labelText: 'Address',
                          labelStyle: TextStyle(height: 4),
                        ),
                        validator: (val) =>
                            val.isEmpty ? "Enter your address" : null,
                        onChanged: (val) {
                          setState(() {
                            address = val;
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
