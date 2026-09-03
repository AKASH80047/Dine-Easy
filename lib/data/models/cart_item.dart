import 'food_item.dart';

class CartItem {
  final FoodItem item;
  final int quantity;
  final FoodVariant? selectedVariant;
  final String? specialInstruction;

  const CartItem({
    required this.item,
    required this.quantity,
    this.selectedVariant,
    this.specialInstruction,
  });

  double get unitPrice => selectedVariant?.price ?? item.price;
  double get totalPrice => unitPrice * quantity;

  CartItem copyWith({
    FoodItem? item,
    int? quantity,
    FoodVariant? selectedVariant,
    String? specialInstruction,
  }) {
    return CartItem(
      item: item ?? this.item,
      quantity: quantity ?? this.quantity,
      selectedVariant: selectedVariant ?? this.selectedVariant,
      specialInstruction: specialInstruction ?? this.specialInstruction,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'item': item.toMap(),
      'quantity': quantity,
      'selectedVariant': selectedVariant?.toMap(),
      'specialInstruction': specialInstruction,
    };
  }

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      item: FoodItem.fromMap(map['item'] as Map<String, dynamic>),
      quantity: map['quantity'] as int,
      selectedVariant: map['selectedVariant'] != null
          ? FoodVariant.fromMap(
              map['selectedVariant'] as Map<String, dynamic>)
          : null,
      specialInstruction: map['specialInstruction'] as String?,
    );
  }
}
