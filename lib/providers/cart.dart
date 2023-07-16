import 'package:flutter/material.dart';

class CartItem {
  final String title;
  final String id;
  final double price;
  final int quantity;

  CartItem(
      {required this.id,
      required this.title,
      required this.price,
      required this.quantity});
}

class Cart with ChangeNotifier {

  Map<String, CartItem> _cartItems = {};

  Map<String, CartItem> get cartItem{
    return {..._cartItems};
  }

  void addToCart(
    String productId,
    String title,
    double price,
  ) {
    if (_cartItems.containsKey(productId)) {
      _cartItems.update(
        productId,
        (existingCartProduct) => CartItem(
          id: existingCartProduct.id,
          title: existingCartProduct.title,
          price: existingCartProduct.price,
          quantity: existingCartProduct.quantity + 1,
        ),
      );
    } else {
      _cartItems.putIfAbsent(
          productId,
          () => CartItem(
              id: DateTime.now().toString(),
              title: title,
              price: price,
              quantity: 1));
    }
    notifyListeners();
  }

  double get totalAmount{
    var total = 0.0;
    _cartItems.forEach((productId, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  int get quantity {
    return _cartItems.length;
  }

  void removeItem(String productId){
    _cartItems.remove(productId);
    notifyListeners();
  }

  void removeSingleItem(String productId){

    if(!_cartItems.containsKey(productId)){
      return;
    }
    if(_cartItems[productId]!.quantity > 1){
      _cartItems.update(productId, (existingProduct) => CartItem(id: existingProduct.id, title: existingProduct.title, price: existingProduct.price, quantity: existingProduct.quantity - 1));
    }else{
      _cartItems.remove(productId);
    }
    notifyListeners();
  }

  void clear(){
    _cartItems = {};
    notifyListeners();
 }

}
