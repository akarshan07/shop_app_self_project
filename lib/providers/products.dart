import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../modals/http_exception.dart';
import 'dart:convert';
import 'product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [];
  final String? authToken;
  final String? userId;

  Products(this.authToken,this.userId,this._items);

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteProduct {
    return _items.where((prod) => prod.isFavorite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  Future<void> addProduct(Product product) async {
    final url = Uri.parse('https://dummy-shop-app-f3c0b-default-rtdb.firebaseio.com/products.json?auth=$authToken');
    try {
      final response = await http.post(url,
          body: json.encode({
            'title': product.title,
            'price': product.price,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'isFavorite': product.isFavorite,
            'creatorId': userId,
          }));
      var newProduct = Product(
        id: json.decode(response.body)['name'],
        title: product.title,
        price: product.price,
        description: product.description,
        imageUrl: product.imageUrl,
      );
      _items.insert(0, newProduct);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> fetchAndSetProducts([bool filterByUser = false]) async {

    String filterString = filterByUser ? 'orderBy="creatorId"&equalTo="$userId"':'';

    var url = Uri.parse('https://dummy-shop-app-f3c0b-default-rtdb.firebaseio.com/products.json?auth=$authToken&$filterString');
    final response = await http.get(url);
    final Map<String, dynamic> ? extractedData = json.decode(response.body) as Map<String, dynamic>?;
    List<Product> loadedData = [];
    if(extractedData == null) {
      _items = loadedData;
      notifyListeners();
      return;
    }
     url = Uri.parse('https://dummy-shop-app-f3c0b-default-rtdb.firebaseio.com/userFavorite/$userId.json?auth=$authToken');
    final favoriteResponse = await http.get(url);
    final favoriteData = json.decode(favoriteResponse.body);
    extractedData.forEach((prodId, prodData) {
      loadedData.add(Product(
          id: prodId,
          title: prodData['title'],
          price: prodData['price'],
          description: prodData['description'],
          imageUrl: prodData['imageUrl'],
          isFavorite: favoriteData == null?false:favoriteData[prodId]??false,
      ));
    });
    _items = loadedData;
    notifyListeners();
  }

  Future<void> updateProduct(String id, Product product) async{

    final url =  Uri.parse('https://dummy-shop-app-f3c0b-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken');
    await http.patch(url,body: json.encode({
      'description':product.description,
      'imageUrl': product.imageUrl,
      'price': product.price,
      'title':product.title,
    }));
    var prodIndex = _items.indexWhere((prod) => prod.id == id);
    _items[prodIndex] = product;
    notifyListeners();
  }

  Future<void> removeProduct(String id) async{

    final url = Uri.parse('https://dummy-shop-app-f3c0b-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken');
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    Product? existingProduct = _items.elementAt(existingProductIndex);
    _items.removeAt(existingProductIndex);
    notifyListeners();

    final response =  await http.delete(url);

      if (response.statusCode >= 400) {
        _items.insert(existingProductIndex, existingProduct as Product);
        notifyListeners();
        existingProduct = null;
        throw HttpException('Could not delete the item');
      }

  }
}
