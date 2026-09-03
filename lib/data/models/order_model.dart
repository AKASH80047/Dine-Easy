import 'cart_item.dart';

enum OrderStatus {
  pending,
  preparing,
  ready,
  served,
  completed,
  cancelled,
}

enum PaymentMethod {
  online,
  cash,
}

extension OrderStatusExt on OrderStatus {
  String get label {
    switch (this) {
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.preparing:
        return 'Preparing';
      case OrderStatus.ready:
        return 'Ready';
      case OrderStatus.served:
        return 'Served';
      case OrderStatus.completed:
        return 'Completed';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }

  String get emoji {
    switch (this) {
      case OrderStatus.pending:
        return '⏳';
      case OrderStatus.preparing:
        return '👨‍🍳';
      case OrderStatus.ready:
        return '✅';
      case OrderStatus.served:
        return '🍽️';
      case OrderStatus.completed:
        return '🎉';
      case OrderStatus.cancelled:
        return '❌';
    }
  }

  String get description {
    switch (this) {
      case OrderStatus.pending:
        return 'Order received, waiting for confirmation';
      case OrderStatus.preparing:
        return 'Chef is preparing your food';
      case OrderStatus.ready:
        return 'Your food is ready!';
      case OrderStatus.served:
        return 'Food has been served at your table';
      case OrderStatus.completed:
        return 'Order completed. Thank you!';
      case OrderStatus.cancelled:
        return 'Order has been cancelled';
    }
  }

  int get stepIndex {
    switch (this) {
      case OrderStatus.pending:
        return 0;
      case OrderStatus.preparing:
        return 1;
      case OrderStatus.ready:
        return 2;
      case OrderStatus.served:
        return 3;
      case OrderStatus.completed:
        return 4;
      case OrderStatus.cancelled:
        return -1;
    }
  }
}

extension PaymentMethodExt on PaymentMethod {
  String get label {
    switch (this) {
      case PaymentMethod.online:
        return 'Online Payment';
      case PaymentMethod.cash:
        return 'Pay at Counter';
    }
  }
}

class OrderModel {
  final String id;
  final String tableNumber;
  final List<CartItem> items;
  final double subtotal;
  final double gst;
  final double total;
  final OrderStatus status;
  final PaymentMethod paymentMethod;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String? specialInstruction;
  final String? customerName;
  final bool isPaid;

  const OrderModel({
    required this.id,
    required this.tableNumber,
    required this.items,
    required this.subtotal,
    required this.gst,
    required this.total,
    required this.status,
    required this.paymentMethod,
    required this.createdAt,
    this.updatedAt,
    this.specialInstruction,
    this.customerName,
    this.isPaid = false,
  });

  int get totalItems =>
      items.fold(0, (sum, item) => sum + item.quantity);

  OrderModel copyWith({
    String? id,
    String? tableNumber,
    List<CartItem>? items,
    double? subtotal,
    double? gst,
    double? total,
    OrderStatus? status,
    PaymentMethod? paymentMethod,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? specialInstruction,
    String? customerName,
    bool? isPaid,
  }) {
    return OrderModel(
      id: id ?? this.id,
      tableNumber: tableNumber ?? this.tableNumber,
      items: items ?? this.items,
      subtotal: subtotal ?? this.subtotal,
      gst: gst ?? this.gst,
      total: total ?? this.total,
      status: status ?? this.status,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      specialInstruction: specialInstruction ?? this.specialInstruction,
      customerName: customerName ?? this.customerName,
      isPaid: isPaid ?? this.isPaid,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tableNumber': tableNumber,
      'items': items.map((i) => i.toMap()).toList(),
      'subtotal': subtotal,
      'gst': gst,
      'total': total,
      'status': status.name,
      'paymentMethod': paymentMethod.name,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'specialInstruction': specialInstruction,
      'customerName': customerName,
      'isPaid': isPaid,
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      id: map['id'] as String,
      tableNumber: map['tableNumber'] as String,
      items: (map['items'] as List)
          .map((i) => CartItem.fromMap(i as Map<String, dynamic>))
          .toList(),
      subtotal: (map['subtotal'] as num).toDouble(),
      gst: (map['gst'] as num).toDouble(),
      total: (map['total'] as num).toDouble(),
      status: OrderStatus.values.firstWhere(
        (s) => s.name == map['status'],
        orElse: () => OrderStatus.pending,
      ),
      paymentMethod: PaymentMethod.values.firstWhere(
        (p) => p.name == map['paymentMethod'],
        orElse: () => PaymentMethod.cash,
      ),
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt'] as String)
          : null,
      specialInstruction: map['specialInstruction'] as String?,
      customerName: map['customerName'] as String?,
      isPaid: map['isPaid'] as bool? ?? false,
    );
  }
}
