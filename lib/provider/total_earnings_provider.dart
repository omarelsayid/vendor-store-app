import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vendor_store_app/models/order.dart';

class TotalEarningsProvider extends StateNotifier<Map<String, dynamic>> {
  TotalEarningsProvider()
      : super({
          'totalEarnings': 0.0,
          'orderCount': 0,
        });
  calculateTotalEarnings(List<Order> orders) {
    double earnings = 0.0;
    int orderCount = 0;
    for (var order in orders) {
      if (order.delivered) {
        orderCount++;
        earnings += order.productPrice * order.quantity;
      }
    }
    state = {
      'totalEarnings': earnings,
      'orderCount': orderCount,
    };
  }
}

final totalEarningsProvider =
    StateNotifierProvider<TotalEarningsProvider, Map<String, dynamic>>(
  (ref) => TotalEarningsProvider(),
);
