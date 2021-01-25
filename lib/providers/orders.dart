import 'package:flutter/foundation.dart';
import 'package:shop_app/config/general_config.dart';
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

  final String authToken;
  final String userId;

  Orders(this.authToken, this.userId, this._orders);

  Future<void> fetchOrdersFromServer() async {
    try {
      final response = await http.get(GeneralConfig.baseURL +
          _urlRepository +
          '.json?auth=$authToken&orderBy="userId"&equalTo="$userId"');

      final orders = json.decode(response.body) as Map<String, dynamic>;
      _orders.clear();

      if (orders != null) {
        orders.forEach((id, order) {
          var prods = order['products'] as List<dynamic>;
          List<CartItem> items = [];
          prods.forEach((prod) {
            items.add(
              CartItem(
                id: prod['id'],
                price: prod['price'],
                quantity: prod['quantity'],
                title: prod['title'],
              ),
            );
          });

          _orders.insert(
            0,
            OrderItem(
              id: id,
              amount: order['amount'],
              products: items,
              dateTime: DateTime.parse(order['datetime']),
            ),
          );
        });
      }
      //_orders = _orders.reversed.toList();
      notifyListeners();
    } catch (error) {
      _orders.clear();
      throw error;
    }
  }

  List<OrderItem> get orders {
    return [..._orders];
  }

  bool hasOrders() {
    if (_orders != null) {
      return _orders.length > 0;
    }
    return false;
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    try {
      final response = await http.post(
          GeneralConfig.baseURL + _urlRepository + '.json?auth=$authToken',
          body: json.encode({
            'amount': total,
            'datetime': DateTime.now().toIso8601String(),
            'userId': userId,
            'products': cartProducts.map((product) {
              return {
                'id': product.id,
                'price': product.price,
                'quantity': product.quantity,
                'title': product.title,
              };
            }).toList(),
          }));

      _orders.insert(
        0,
        OrderItem(
          id: json.decode(response.body)['name'],
          amount: total,
          products: cartProducts,
          dateTime: DateTime.now(),
        ),
      );
      notifyListeners();
    } catch (error) {
      _orders.removeAt(0);
      throw error;
    }
  }
}
