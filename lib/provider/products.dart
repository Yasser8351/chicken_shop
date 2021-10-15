import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:chicken_shop/model/http_exeption.dart';
import 'package:chicken_shop/provider/prodects.dart';
import 'package:http/http.dart' as http;

class Products with ChangeNotifier {
  List<Product> _items = [];

  final authToken;
  final userId;
  Products(this.authToken, this.userId, this._items);

  List<Product> get items {
    return [..._items];
  }

  List<Product> get faverItem {
    return _items.where((prod) => prod.isFaverts).toList();
  }

  Future<void> fetchProducts([bool filterByUser = false]) async {
    final filterString =
        filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';

    try {
      var url =
          "https://shopapp-37037-default-rtdb.firebaseio.com/products.json?auth=$authToken&$filterString";

      final response = await http.get(url);
      final extractData = json.decode(response.body) as Map<String, dynamic>;
      if (extractData == null) {
        return;
      }
      url =
          "https://shopapp-37037-default-rtdb.firebaseio.com/products/userFaverts/$userId.json?auth=$authToken";

      final faverResponse = await http.get(url);
      final faverData = json.decode(faverResponse.body);
      final List<Product> loadedProducts = [];
      extractData.forEach(
        (prodId, prodData) {
          loadedProducts.add(
            Product(
                id: prodId,
                title: prodData["title"],
                description: prodData["description"],
                imageUrl: prodData["imageUrl"],
                price: prodData["price"],
                isFaverts:
                    faverData == null ? false : faverData[prodId] ?? false),
          );
        },
      );
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addProduct(Product pro) async {
    //add
    final url =
        "https://shopapp-37037-default-rtdb.firebaseio.com/products.json?auth=$authToken";
    try {
      var response = await http.post(
        url,
        body: json.encode({
          "title": pro.title,
          "description": pro.description,
          "price": pro.price,
          "imageUrl": pro.imageUrl,
          "isFaverts": pro.isFaverts,
          "creatorId": userId
        }),
      );
      final newProduct = Product(
        id: json.decode(response.body)["name"],
        title: pro.title,
        imageUrl: pro.imageUrl,
        price: pro.price,
        description: pro.description,
      );

      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) {
    final prodIndex = _items.indexWhere((element) => element.id == id);
    if (prodIndex >= 0) {
      final url =
          "https://shopapp-37037-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken";
      http.patch(
        url,
        body: json.encode(
          {
            "title": newProduct.title,
            "description": newProduct.description,
            "imageUrl": newProduct.imageUrl,
            "price": newProduct.price
          },
        ),
      );
      _items[prodIndex] = newProduct;
      notifyListeners();
    } else {
      print("");
    }
  }

  void delteProduct(String id) async {
    final url =
        "https://shopapp-37037-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken";
    final existingIndex = _items.indexWhere((element) => element.id == id);
    var existing = _items[existingIndex];
    _items.removeAt(existingIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      throw HttpException("coud not delete product");
    }
    existing = null;
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }
}
