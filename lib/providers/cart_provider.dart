import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/food_item.dart';
import '../data/models/cart_item.dart';
import '../core/utils/formatters.dart';

class CartState {
  final List<CartItem> items;
  final String tableNumber;
  final String specialInstruction;

  const CartState({
    this.items = const [],
    this.tableNumber = '',
    this.specialInstruction = '',
  });

  double get subtotal =>
      items.fold(0.0, (sum, item) => sum + item.totalPrice);

  double get gst => AppFormatters.calculateGST(subtotal);

  double get total => subtotal + gst;

  int get itemCount =>
      items.fold(0, (sum, item) => sum + item.quantity);

  bool get isEmpty => items.isEmpty;

  bool get hasTable => tableNumber.isNotEmpty;

  int getItemQuantity(String itemId, {String? variantLabel}) {
    final matched = items.where(
      (ci) =>
          ci.item.id == itemId &&
          ci.selectedVariant?.label == variantLabel,
    );
    return matched.isEmpty ? 0 : matched.first.quantity;
  }

  CartState copyWith({
    List<CartItem>? items,
    String? tableNumber,
    String? specialInstruction,
  }) {
    return CartState(
      items: items ?? this.items,
      tableNumber: tableNumber ?? this.tableNumber,
      specialInstruction: specialInstruction ?? this.specialInstruction,
    );
  }
}

class CartNotifier extends StateNotifier<CartState> {
  CartNotifier() : super(const CartState());

  void addItem(FoodItem item, {FoodVariant? variant, int quantity = 1}) {
    final existingIdx = state.items.indexWhere(
      (ci) =>
          ci.item.id == item.id &&
          ci.selectedVariant?.label == variant?.label,
    );

    if (existingIdx >= 0) {
      final updatedItems = [...state.items];
      updatedItems[existingIdx] = updatedItems[existingIdx]
          .copyWith(quantity: updatedItems[existingIdx].quantity + quantity);
      state = state.copyWith(items: updatedItems);
    } else {
      state = state.copyWith(
        items: [
          ...state.items,
          CartItem(item: item, quantity: quantity, selectedVariant: variant),
        ],
      );
    }
  }

  void removeItem(String itemId, {String? variantLabel}) {
    final updatedItems = state.items
        .where((ci) =>
            !(ci.item.id == itemId &&
                ci.selectedVariant?.label == variantLabel))
        .toList();
    state = state.copyWith(items: updatedItems);
  }

  void decreaseQuantity(String itemId, {String? variantLabel}) {
    final existingIdx = state.items.indexWhere(
      (ci) =>
          ci.item.id == itemId &&
          ci.selectedVariant?.label == variantLabel,
    );
    if (existingIdx < 0) return;

    final updatedItems = [...state.items];
    if (updatedItems[existingIdx].quantity <= 1) {
      updatedItems.removeAt(existingIdx);
    } else {
      updatedItems[existingIdx] = updatedItems[existingIdx]
          .copyWith(quantity: updatedItems[existingIdx].quantity - 1);
    }
    state = state.copyWith(items: updatedItems);
  }

  void increaseQuantity(String itemId, {String? variantLabel}) {
    final existingIdx = state.items.indexWhere(
      (ci) =>
          ci.item.id == itemId &&
          ci.selectedVariant?.label == variantLabel,
    );
    if (existingIdx < 0) return;
    final updatedItems = [...state.items];
    updatedItems[existingIdx] = updatedItems[existingIdx]
        .copyWith(quantity: updatedItems[existingIdx].quantity + 1);
    state = state.copyWith(items: updatedItems);
  }

  void setTableNumber(String tableNumber) {
    state = state.copyWith(tableNumber: tableNumber);
  }

  void setSpecialInstruction(String instruction) {
    state = state.copyWith(specialInstruction: instruction);
  }

  void clearCart() {
    state = const CartState();
  }

  void clearItems() {
    state = state.copyWith(items: const []);
  }

  int getItemQuantity(String itemId, {String? variantLabel}) {
    final item = state.items.where(
      (ci) =>
          ci.item.id == itemId &&
          ci.selectedVariant?.label == variantLabel,
    );
    return item.isEmpty ? 0 : item.first.quantity;
  }
}

final cartProvider =
    StateNotifierProvider<CartNotifier, CartState>((ref) => CartNotifier());
