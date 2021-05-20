import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_tutorial/models/product.dart';
import 'package:flutter_tutorial/models/user-cart.dart';

class DatabaseService {
  final String uid;

  DatabaseService({this.uid});

  // collection reference

  final CollectionReference productsCollection =
      FirebaseFirestore.instance.collection("products");

  final CollectionReference userCartCollection =
      FirebaseFirestore.instance.collection("user_cart");

  Future updateUserCartData(Map selectedProducts, dynamic totalCartPrice) async {
    return await userCartCollection.doc(uid).set({
      'selected_products': selectedProducts,
      'total_cart_price': totalCartPrice,
    });
  }

  // Product list from snapshot

  List<Product> _productListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Product(
        id: doc["id"] ?? 0,
        name: doc["name"] ?? 'NA',
        description: doc["description"] ?? 'NA',
        price: doc["price"] ?? 0,
      );
    }).toList();
  }

  // user cart data from snapshot

  UserCartData _userCartDataFromSnapsot(DocumentSnapshot snapshot) {
    return UserCartData(
      uid:uid,
      selectedProducts:snapshot['selected_products'],
      totalCartPrice:snapshot['total_cart_price'],
    );
  }

  // get product stream

  Stream<List<Product>> get products {
    return productsCollection.snapshots().map(_productListFromSnapshot);
  }

  // get user doc stream

  Stream<UserCartData> get userCartData {
    return userCartCollection.doc(uid).snapshots().map(_userCartDataFromSnapsot);
  }

}
