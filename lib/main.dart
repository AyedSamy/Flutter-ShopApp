import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:miaged/models/user.dart';
import 'package:miaged/screens/register.dart';
import 'package:miaged/screens/sign_in.dart';
import 'package:miaged/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:miaged/screens/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(StreamProvider<TheUser>.value(
    initialData: null,
    value: AuthService().user,
    child: MaterialApp(
      initialRoute: '/register',
      routes: {
        '/': (context) => App(),
        '/signIn': (context) => SignIn(),
        '/register': (context) => Register()
      },
    ),
  ));
}

class App extends StatefulWidget {
  // Create the initialization Future outside of `build`:
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Scaffold(
              body: Center(
                child: Text("Error"),
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return Home();
          }

          return Scaffold(
            body: Center(
              child: Text("Loading"),
            ),
          );
        },
      ),
    );
  }
}
