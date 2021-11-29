import 'package:flutter/material.dart';
import 'package:miaged/services/auth.dart';
import 'package:miaged/services/database.dart';
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
  String message = '';
  // initial values
  String firstname;
  String lastname;
  String email;
  String password;
  DateTime birthday;
  String address;
  String postalcode;
  String city;

  @override
  Widget build(BuildContext context) {
    final Map data = ModalRoute.of(context).settings.arguments;

    // initial route args values
    String firstname = data["firstname"];
    String lastname = data["lastname"];
    String email = data["email"];
    String password = data["password"];
    DateTime birthday = data["birthday"];
    String address = data["address"];
    String postalcode = data["postalcode"];
    String city = data["city"];

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
                      bool updateLogs = true;
                      bool updateUser = true;
                      dynamic result = true;
                      if (this.email == null && this.password == null) {
                        updateLogs = false;
                      }
                      if (updateLogs == true) {
                        print(this.email == null ? email : this.email);
                        print(this.password == null ? password : this.password);
                        result = await _auth.updateEmailAndPassword(
                            this.email == null ? email : this.email,
                            this.password == null ? password : this.password);
                      }
                      if (result == null) {
                        updateUser = false;
                        setState(() {
                          loading = false;
                          message = "Please supply a valid email";
                        });
                      }
                      if (updateUser == true) {
                        await DatabaseService(uid: data["uid"]).updateUserData(
                            this.email == null ? email : this.email,
                            this.firstname == null ? firstname : this.firstname,
                            this.lastname == null ? lastname : this.lastname,
                            this.password == null ? password : this.password,
                            this.birthday == null ? birthday : this.birthday,
                            this.address == null ? address : this.address,
                            this.postalcode == null
                                ? postalcode
                                : this.postalcode,
                            this.city == null ? city : this.city);
                        setState(() {
                          loading = false;
                          message = "Your profile has been updated";
                        });
                        print("updated user");
                        //Navigator.pop(context);
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
                      Text(
                        message,
                        style: TextStyle(
                          color: Colors.purple,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      TextFormField(
                        initialValue: firstname,
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
                            this.firstname = val;
                          });
                        },
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      TextFormField(
                        initialValue: lastname,
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
                            this.lastname = val;
                          });
                        },
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      TextFormField(
                        initialValue: email,
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
                            this.email = val;
                            print(this.email);
                          });
                        },
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      TextFormField(
                        obscureText: true,
                        initialValue: password,
                        decoration: textInputDecoration.copyWith(
                          focusedBorder: outlineWhite,
                          hintText: 'Password',
                          hintStyle: TextStyle(height: 2),
                          labelText: 'Password',
                          labelStyle: TextStyle(height: 4),
                        ),
                        validator: (val) =>
                            val.length < 6 ? "Enter a 6+ chars password" : null,
                        onChanged: (val) {
                          setState(() {
                            this.password = val;
                          });
                        },
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      DateTimeFormField(
                        initialValue: birthday,
                        mode: DateTimeFieldPickerMode.date,
                        decoration: textInputDecoration.copyWith(
                          focusedBorder: outlineWhite,
                          hintText: 'Birthday',
                          hintStyle: TextStyle(height: 2),
                          labelText: 'Birthday',
                          labelStyle: TextStyle(height: 4),
                        ),
                        validator: (DateTime e) {
                          return null;
                        },
                        onDateSelected: (DateTime val) {
                          this.birthday = val;
                        },
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      TextFormField(
                        initialValue: address,
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
                            this.address = val;
                          });
                        },
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      TextFormField(
                        initialValue: postalcode,
                        decoration: textInputDecoration.copyWith(
                          focusedBorder: outlineWhite,
                          hintText: 'Postal code',
                          hintStyle: TextStyle(height: 2),
                          labelText: 'Postal code',
                          labelStyle: TextStyle(height: 4),
                        ),
                        validator: (val) =>
                            val.isEmpty ? "Enter your postal code" : null,
                        onChanged: (val) {
                          setState(() {
                            this.postalcode = val;
                          });
                        },
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      TextFormField(
                        initialValue: city,
                        decoration: textInputDecoration.copyWith(
                          focusedBorder: outlineWhite,
                          hintText: 'City',
                          hintStyle: TextStyle(height: 2),
                          labelText: 'City',
                          labelStyle: TextStyle(height: 4),
                        ),
                        validator: (val) =>
                            val.isEmpty ? "Enter your city" : null,
                        onChanged: (val) {
                          setState(() {
                            this.city = val;
                          });
                        },
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
