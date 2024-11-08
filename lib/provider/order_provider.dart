import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vendor_store_app/models/order.dart';

class OrderProvider extends StateNotifier<List<Order>> {
  OrderProvider() : super([]);
  // set the list of orders

  void setOrders(List<Order> orders) {
    state = orders;
  }

  void updateOrderStatus(String orderId, {bool? processing, bool? delivered}) {
    state = [
      for (final order in state)
        if (order.id == orderId)
          Order(
              id: order.id,
              fullName: order.fullName,
              email: order.email,
              state: order.state,
              city: order.city,
              locality: order.locality,
              productName: order.productName,
              productPrice: order.productPrice,
              quantity: order.quantity,
              category: order.category,
              image: order.image,
              buyerId: order.buyerId,
              vendorId: order.vendorId,
              processing: processing ?? order.processing,
              delivered: delivered ?? order.delivered)
    ];
  }
}

final orderProvider = StateNotifierProvider<OrderProvider, List<Order>>((ref) {
  return OrderProvider();
});
