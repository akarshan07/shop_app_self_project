import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../providers/cart.dart';

class OrderItem {
  final String id;
  final DateTime dateTime;
  final double amount;
  final List<CartItem> cartItem;

  OrderItem({
    required this.id,
    required this.dateTime,
    required this.amount,
    required this.cartItem,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  final String? authToken;
  final String? userId;
  Orders(this.authToken,this.userId,this._orders);

  List<OrderItem> get items {
    return [..._orders];
  }

  Future<void> fectchAndSetOrders() async {
    final url = Uri.parse(
        'https://dummy-shop-app-f3c0b-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken');
    final response = await http.get(url);
    final Map<String, dynamic>? extractedData = json.decode(response.body) as Map<String, dynamic>?;
    List<OrderItem> loadedOrders = [];
    if(extractedData == null){
      _orders = loadedOrders.reversed.toList();
      notifyListeners();
      return ;
    }
    extractedData.forEach((orderId, orderData) {
      loadedOrders.add(
        OrderItem(
          id: orderId,
          dateTime: DateTime.parse(orderData['dateTime']),
          amount: orderData['amount'],
          cartItem: (orderData['cartItem'] as List<dynamic>).map((ci){
            return CartItem(id: ci['id'], title: ci['title'], price: ci['price'], quantity: ci['quantity']);
          }).toList(),
        ),
      );
      _orders = loadedOrders.reversed.toList();
      notifyListeners();
    });
  }

  Future<void> addOrderItem(double amount, List<CartItem> cartItem) async {
    final instantDate = DateTime.now();
    final url = Uri.parse(
        'https://dummy-shop-app-f3c0b-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken');

    final response = await http.post(url,
        body: json.encode({
          'amount': amount,
          'dateTime': instantDate.toIso8601String(),
          'cartItem': cartItem
              .map((cartProd) => {
                    'id': cartProd.id,
                    'title': cartProd.title,
                    'price': cartProd.price,
                    'quantity': cartProd.quantity,
                  })
              .toList(),
        }));

    _orders.insert(
        0,
        OrderItem(
          id: json.decode(response.body)['name'].toString(),
          dateTime: instantDate,
          amount: amount,
          cartItem: cartItem,
        ));
    notifyListeners();
  }
}
