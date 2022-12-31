import '../models/orders_model.dart';
import '../models/pizza_model.dart';
import 'networking.dart';

class PizzaServices {
  static List<PizzaModel> pizzas = [];
  static List<OrderModel> orders = [];

  static Future<List<PizzaModel>> getPizzas({String? pizzaId}) async {
    try {
      if (pizzas.isNotEmpty) {
        pizzas.clear();
      }
      var response = await Networking.getRequest(
          endpoint: '/pizzas',
          queryParams: pizzaId != null ? {'id': pizzaId} : {});
      for (var pizza in response) {
        pizzas.add(PizzaModel.fromJson(pizza));
      }
      return pizzas;
    } catch (e) {
      rethrow;
    }
  }

  static Future<List<OrderModel>> getOrders({String? userId}) async {
    try {
      if (orders.isNotEmpty) {
        orders.clear();
      }
      var response = await Networking.getRequest(
          endpoint: '/fetchorders',
          queryParams: userId != null ? {'user_id': userId} : {});
      for (var order in response) {
        orders.add(OrderModel.fromJson(order));
      }
      return orders;
    } catch (e) {
      rethrow;
    }
  }

  static Future<String> placeOrder(
      {required Map<String, dynamic> order}) async {
    try {
      var response =
          await Networking.post(endpoint: '/createorder', body: order);
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
