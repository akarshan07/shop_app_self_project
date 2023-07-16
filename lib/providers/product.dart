import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Product with ChangeNotifier{

  final String id;
  final String title;
  final double price;
  final String description;
  final String imageUrl;
  bool isFavorite;

  Product({
  required  this.id,
  required  this.title,
  required  this.price,
  required  this.description,
  required  this.imageUrl,
    this.isFavorite = false,
});

  Future<void> toggleFavorite(String? token,String? userId) async{
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();

    final url = Uri.parse('https://dummy-shop-app-f3c0b-default-rtdb.firebaseio.com/userFavorite/$userId/$id.json?auth=$token');
    try{

    final response = await http.put(url,body: json.encode(
        isFavorite
    ));

    if(response.statusCode>=400){
      isFavorite = oldStatus;
      notifyListeners();
    }}catch(error){
      isFavorite = oldStatus;
      notifyListeners();
    }
  }
}