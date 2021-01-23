import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../config/general_config.dart';
import '../providers/products.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite = false,
  });

  void toggleFavoriteStatus() async {
    try {
      isFavorite = !isFavorite;
      notifyListeners();
      final url = GeneralConfig.baseURL + Products.urlRepository + '/$id.json';
      await http.patch(url,
          body: json.encode({
            'isFavorite': isFavorite,
          }));
    } catch (_) {
      isFavorite = !isFavorite;
      notifyListeners();
    }
  }
}
