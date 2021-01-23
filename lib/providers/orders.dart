import 'package:flutter/foundation.dart';
import 'package:shop_app/config/general_config.dart';
import 'package:shop_app/providers/products.dart';
import '../providers/cart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  final _urlRepository = '/orders';

  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  void addOrder(List<CartItem> cartProducts, double total) async {
    try {
      await http.post(GeneralConfig.baseURL + _urlRepository + '.json',
          body: json.encode({
            'amount': total,
            'datetime': DateTime.now(),
            'products:': [
              cartProducts.forEach((product) {
                return {
                  'id': product.id,
                  'price': product.price,
                  'quantity': product.quantity,
                  'title': product.title,
                };
              }),
            ]
          }));
      _orders.insert(
        0,
        OrderItem(
          id: DateTime.now().toString(),
          amount: total,
          products: cartProducts,
          dateTime: DateTime.now(),
        ),
      );
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
