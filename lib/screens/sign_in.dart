import 'package:flutter/material.dart';
import 'package:miaged/services/auth.dart';
import 'package:miaged/shared/constants.dart';
import 'package:miaged/shared/loading.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  bool loading = false;

  //text field state
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Colors.blue[200],
            appBar: AppBar(
              title: Text("Sign in to MIAGED"),
              backgroundColor: Colors.blue[800],
              elevation: 0.0,
            ),
            body: Container(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      decoration:
                          textInputDecoration.copyWith(hintText: 'Email'),
                      validator: (val) => val.isEmpty ? "Enter an email" : null,
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
                      child: Text("Sign in"),
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          setState(() {
                            loading = true;
                          });
                          dynamic result = await _auth
                              .signInWithEmailAndPassword(email, password);
                          if (result == null) {
                            setState(
                              () {
                                loading = false;
                                error =
                                    "could not sign in with those credentials";
                              },
                            );
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
          );
  }
}
