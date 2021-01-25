import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/config/general_config.dart';
import 'package:shop_app/models/http_exception.dart';
import './product.dart';

class Products with ChangeNotifier {
  static const urlRepository = '/products';

  final String authToken;
  final String userId;

  Products(this.authToken, this.userId, this._items);

  List<Product> _items = [];

  // List<Product> _items = [
  //   Product(
  //     id: 'p1',
  //     title: 'Red Shirt',
  //     description: 'A red shirt - it is pretty red!',
  //     price: 29.99,
  //     imageUrl:
  //         'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
  //   ),
  //   Product(
  //     id: 'p2',
  //     title: 'Trousers',
  //     description: 'A nice pair of trousers.',
  //     price: 59.99,
  //     imageUrl:
  //         'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
  //   ),
  //   Product(
  //     id: 'p3',
  //     title: 'Yellow Scarf',
  //     description: 'Warm and cozy - exactly what you need for the winter.',
  //     price: 19.99,
  //     imageUrl:
  //         'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
  //   ),
  //   Product(
  //     id: 'p4',
  //     title: 'A Pan',
  //     description: 'Prepare any meal you want.',
  //     price: 49.99,
  //     imageUrl:
  //         'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
  //   ),
  // ];

  var _showFavoritesOnly = false;

  Future<void> fetchAndSetProducts([bool filterByUser = false]) async {
    try {
      final filter = filterByUser ? 'orderBy="userId"&equalTo="$userId"' : '';
      final response = await http.get(GeneralConfig.baseURL +
          urlRepository +
          '.json?auth=$authToken&$filter');
      final extratedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loadedProducts = [];

      if (extratedData != null) {
        final favoriteResponse = await http.get(GeneralConfig.baseURL +
            Product.favoritesurlRepository +
            '/$userId.json?auth=$authToken');

        final favoriteData = json.decode(favoriteResponse.body);

        extratedData.forEach((prodId, prodData) {
          loadedProducts.add(Product(
            id: prodId,
            description: prodData['description'],
            imageUrl: prodData['imageUrl'],
            price: prodData['price'],
            title: prodData['title'],
            isFavorite:
                favoriteData == null ? false : favoriteData[prodId] ?? false,
          ));
        });
      }

      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  List<Product> get items {
    if (_showFavoritesOnly) {
      return _items.where((prod) => prod.isFavorite).toList();
    } else {
      List<Product> i = [..._items];
      i.sort((a, b) => a.title.compareTo(b.title));
      return i;
    }
  }

  List<Product> get favoriteItems {
    return _items.where((prod) => prod.isFavorite).toList();
  }

  // void showFavoritesOnly() {
  //   _showFavoritesOnly = true;
  //   notifyListeners();
  // }

  // void showAll() {
  //   _showFavoritesOnly = false;
  //   notifyListeners();
  // }

  Future<void> addProductAsync(Product prod) async {
    try {
      final response = await http.post(
        GeneralConfig.baseURL + urlRepository + '.json?auth=$authToken',
        body: json.encode({
          'title': prod.title,
          'description': prod.description,
          'imageUrl': prod.imageUrl,
          'price': prod.price,
          'userId': userId,
        }),
      );

      final newProduct = Product(
        id: json.decode(response.body)['name'],
        title: prod.title,
        description: prod.description,
        price: prod.price,
        imageUrl: prod.imageUrl,
      );
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  // Future<void> addProduct(Product prod) {
  //   return http
  //       .post(
  //     GeneralConfig.baseURL + urlRepository + '.json?auth=$authToken',
  //     body: json.encode({
  //       'title': prod.title,
  //       'description': prod.description,
  //       'imageUrl': prod.imageUrl,
  //       'price': prod.price,
  //       'userId': userId,
  //     }),
  //   )
  //       .then((response) {
  //     final newProduct = Product(
  //       id: json.decode(response.body)['name'],
  //       title: prod.title,
  //       description: prod.description,
  //       price: prod.price,
  //       imageUrl: prod.imageUrl,
  //     );
  //     _items.add(newProduct);
  //     notifyListeners();
  //   }).catchError((error) {
  //     throw error;
  //   });
  // }

  Future<void> updateProduct(String id, Product prod) async {
    try {
      final prodIndex = _items.indexWhere((element) => element.id == id);
      if (prodIndex >= 0) {
        final url =
            GeneralConfig.baseURL + urlRepository + '/$id.json?auth=$authToken';
        await http.patch(url,
            body: json.encode({
              'title': prod.title,
              'description': prod.description,
              'imageUrl': prod.imageUrl,
              'price': prod.price
            }));

        _items[prodIndex] = prod;
      } else {
        addProductAsync(prod);
      }
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> removeProduct(String id) async {
    final prodIndex = _items.indexWhere((element) => element.id == id);
    if (prodIndex >= 0) {
      final url =
          GeneralConfig.baseURL + urlRepository + '/$id.json?auth=$authToken';
      final existingIndex = _items.indexWhere((element) => element.id == id);
      var existingProduct = this.findById(id);
      final response = await http.delete(url);
      _items.removeWhere((element) => element.id == id);
      notifyListeners();
      if (response.statusCode >= 400) {
        _items.insert(existingIndex, existingProduct);
        throw HttpException(
            'Error in request: ' + response.statusCode.toString());
      }
      existingProduct = null;
    }
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }
}
