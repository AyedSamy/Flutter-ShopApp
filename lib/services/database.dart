import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:miaged/models/product.dart';
import 'package:miaged/models/user-cart.dart';

class DatabaseService {
  final String uid;

  DatabaseService({this.uid});

  // collection reference

  final CollectionReference productsCollection =
      FirebaseFirestore.instance.collection("products");

  final CollectionReference userCartCollection =
      FirebaseFirestore.instance.collection("user_cart");

  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection("users");

  Future updateUserCartData(Map selectedProducts, double totalCartPrice) async {
    return await userCartCollection.doc(uid).set({
      'selected_products': selectedProducts,
      'total_cart_price': totalCartPrice,
    });
  }

  Future updateUserData(
      String email,
      String firstname,
      String lastname,
      String password,
      DateTime birthday,
      String address,
      String postalcode,
      String city) async {
    return await usersCollection.doc(uid).set({
      'email': email,
      'firstname': firstname,
      'lastname': lastname,
      'password': password,
      'birthday': birthday,
      'address': address,
      'postalcode': postalcode,
      'city': city,
    });
  }

  Future updateProductData(
      String description,
      String name,
      dynamic price,
      String imageUrl,
      String seller,
      String size,
      String category,
      String brand) async {
    return await productsCollection.doc().set({
      'description': description,
      'name': name,
      'price': price,
      'image_url': imageUrl,
      'seller': seller,
      'size': size,
      'category': category,
      'brand': brand
    });
  }

  // Product list from snapshot

  List<Product> _productListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Product(
        name: doc["name"] ?? 'NA',
        description: doc["description"] ?? 'NA',
        price: doc["price"] ?? 0.0,
        imageUrl: doc["image_url"] ??
            'https://semantic-ui.com/images/wireframe/image.png',
        seller: doc["seller"] ?? 'NA',
        size: doc["size"] ?? 'NA',
        category: doc["category"] ?? 'NA',
        brand: doc["brand"] ?? 'NA',
      );
    }).toList();
  }

  // user cart data from snapshot

  UserCartData _userCartDataFromSnapsot(DocumentSnapshot snapshot) {
    return UserCartData(
      uid: uid,
      selectedProducts: snapshot['selected_products'],
      totalCartPrice: snapshot['total_cart_price'],
    );
  }

  // get list of products stream

  Stream<List<Product>> get products {
    return productsCollection.snapshots().map(_productListFromSnapshot);
  }

  // get user cart stream

  Stream<UserCartData> get userCartData {
    return userCartCollection
        .doc(uid)
        .snapshots()
        .map(_userCartDataFromSnapsot);
  }

  Future<String> getSeller(String uid) async {
    String seller;
    var docRef = usersCollection.doc(uid);
    await docRef.get().then((doc) {
      seller = doc['email'];
      print(seller);
    }).catchError((e) {
      print(e);
    });
    return seller;
  }

  Future<List<dynamic>> getIdentity(String uid) async {
    String firstname;
    String lastname;
    String email;
    String password;
    DateTime birthday;
    String address;
    String postalcode;
    String city;
    var docRef = usersCollection.doc(uid);
    await docRef.get().then((doc) {
      firstname = doc['firstname'];
      lastname = doc['lastname'];
      email = doc['email'];
      password = doc['password'];
      birthday = doc['birthday'].toDate();
      address = doc['address'];
      postalcode = doc['postalcode'];
      city = doc['city'];
      print(firstname);
    }).catchError((e) {
      print(e);
    });
    return [
      firstname,
      lastname,
      email,
      password,
      birthday,
      address,
      postalcode,
      city
    ];
  }
}
