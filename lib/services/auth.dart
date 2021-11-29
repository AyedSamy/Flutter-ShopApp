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
    // Create a credential
    AuthCredential credential =
        EmailAuthProvider.credential(email: email, password: password);
    // Reauthenticate
    await _auth.currentUser.reauthenticateWithCredential(credential);
  }

  // register with email & password

  Future registerWithEmailAndPassword(
      String email, String password, String firstname, String lastname) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;

      // create a new document for the user and his cart using his uid
      await DatabaseService(uid: user.uid).updateUserCartData({},
          0.0); // set an empty cart when a user is created, total cart price 0

      // create a new document for the user and his personal data
      await DatabaseService(uid: user.uid)
          .updateUserData(email, firstname, lastname);

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
