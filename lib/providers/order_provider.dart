import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../data/models/order_model.dart';
import '../data/models/cart_item.dart';
import '../data/services/storage_service.dart';

class OrderState {
  final List<OrderModel> orders;
  final bool isLoading;
  final String? lastOrderId;
  final String? error;

  const OrderState({
    this.orders = const [],
    this.isLoading = false,
    this.lastOrderId,
    this.error,
  });

  List<OrderModel> get activeOrders => orders
      .where((o) =>
          o.status != OrderStatus.completed &&
          o.status != OrderStatus.cancelled)
      .toList();

  List<OrderModel> get todayOrders {
    final now = DateTime.now();
    return orders
        .where((o) =>
            o.createdAt.year == now.year &&
            o.createdAt.month == now.month &&
            o.createdAt.day == now.day)
        .toList();
  }

  double get todayRevenue =>
      todayOrders.fold(0.0, (sum, o) => sum + o.total);

  OrderModel? getOrderById(String id) {
    try {
      return orders.firstWhere((o) => o.id == id);
    } catch (_) {
      return null;
    }
  }

  OrderState copyWith({
    List<OrderModel>? orders,
    bool? isLoading,
    String? lastOrderId,
    String? error,
  }) {
    return OrderState(
      orders: orders ?? this.orders,
      isLoading: isLoading ?? this.isLoading,
      lastOrderId: lastOrderId ?? this.lastOrderId,
      error: error ?? this.error,
    );
  }
}

class OrderNotifier extends StateNotifier<OrderState> {
  static const _uuid = Uuid();

  OrderNotifier() : super(const OrderState()) {
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    state = state.copyWith(isLoading: true);
    try {
      final orders = await StorageService.loadOrders();
      state = state.copyWith(orders: orders, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<String> placeOrder({
    required String tableNumber,
    required List<CartItem> items,
    required double subtotal,
    required double gst,
    required double total,
    required PaymentMethod paymentMethod,
    String? specialInstruction,
  }) async {
    final orderId = _uuid.v4();
    final order = OrderModel(
      id: orderId,
      tableNumber: tableNumber,
      items: items,
      subtotal: subtotal,
      gst: gst,
      total: total,
      status: OrderStatus.pending,
      paymentMethod: paymentMethod,
      createdAt: DateTime.now(),
      specialInstruction: specialInstruction,
      isPaid: paymentMethod == PaymentMethod.online,
    );

    await StorageService.addOrder(order);
    state = state.copyWith(
      orders: [order, ...state.orders],
      lastOrderId: orderId,
    );
    return orderId;
  }

  Future<void> updateOrderStatus(String orderId, OrderStatus status) async {
    await StorageService.updateOrderStatus(orderId, status);
    final updatedOrders = state.orders.map((o) {
      if (o.id == orderId) {
        return o.copyWith(status: status, updatedAt: DateTime.now());
      }
      return o;
    }).toList();
    state = state.copyWith(orders: updatedOrders);
  }

  Future<void> cancelOrder(String orderId) async {
    await updateOrderStatus(orderId, OrderStatus.cancelled);
  }

  Future<void> refreshOrders() async {
    await _loadOrders();
  }
}

final orderProvider =
    StateNotifierProvider<OrderNotifier, OrderState>((ref) => OrderNotifier());
