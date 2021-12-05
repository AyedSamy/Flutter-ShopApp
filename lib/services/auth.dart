import 'package:firebase_auth/firebase_auth.dart';
import 'package:miaged/models/user.dart';
import 'package:miaged/services/database.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create TheUser obj based on firebase User

  TheUser _userFromFirebaseUser(User user) {
    return user != null ? TheUser(uid: user.uid) : null;
  }

  // auth change user stream
  Stream<TheUser> get user {
    return _auth
        .authStateChanges()
        .map((User user) => _userFromFirebaseUser(user));
  }

  // sign in anon
  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // sign in with email & password

  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // update email & password

  Future updateEmailAndPassword(String email, String password) async {
    try {
      // This operation is sensitive and requires recent authentication. It may be necessary to Log in again before retrying the operation.
      await _auth.currentUser.updateEmail(email);
      await _auth.currentUser.updatePassword(password);
      print("updated email pass");
      return true;
    } catch (e) {
      String message;
      print(e.toString());
      if (e.code == 'requires-recent-login') {
        message = "Please log in again to update your email/password.";
        return message;
      }
      return "The email/password update has failed.";
    }
  }

  // register with email & password

  Future registerWithEmailAndPassword(
      String email,
      String password,
      String firstname,
      String lastname,
      DateTime birthday,
      String address,
      String postalcode,
      String city) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;

      // create a new document for the user and his cart using his uid
      await DatabaseService(uid: user.uid).updateUserCartData({},
          0.0); // set an empty cart when a user is created, total cart price 0

      // create a new document for the user and his personal data
      await DatabaseService(uid: user.uid).updateUserData(email, firstname,
          lastname, password, birthday, address, postalcode, city);

      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
