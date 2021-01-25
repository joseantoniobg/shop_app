import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/http_exception.dart';
import 'dart:convert';

import '../config/general_config.dart';

class Product with ChangeNotifier {
  static const favoritesurlRepository = '/userFavorites';

  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  //final String authToken;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    //@required this.authToken,
    this.isFavorite = false,
  });

  void toggleFavoriteStatus(String token, String userId) async {
    try {
      isFavorite = !isFavorite;
      notifyListeners();
      final url = GeneralConfig.baseURL +
          favoritesurlRepository +
          '/$userId/$id.json?auth=$token';
      final response = await http.put(url,
          body: json.encode(
            isFavorite,
          ));
      if (response.statusCode >= 400) {
        throw HttpException('An error has occured!');
      }
    } catch (_) {
      isFavorite = !isFavorite;
      notifyListeners();
    }
  }
}
