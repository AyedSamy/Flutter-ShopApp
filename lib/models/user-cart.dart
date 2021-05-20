class UserCartData {
  
  final String uid;
  Map<String,dynamic> selectedProducts;
  double totalCartPrice;
  
  UserCartData({this.uid, this.selectedProducts, this.totalCartPrice});
}