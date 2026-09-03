import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/food_item.dart';
import '../data/local/menu_data.dart';
import '../data/services/storage_service.dart';

class MenuState {
  final List<FoodCategory> categories;
  final List<FoodItem> allItems;
  final bool isLoading;
  final String? error;

  const MenuState({
    required this.categories,
    required this.allItems,
    this.isLoading = false,
    this.error,
  });

  MenuState copyWith({
    List<FoodCategory>? categories,
    List<FoodItem>? allItems,
    bool? isLoading,
    String? error,
  }) {
    return MenuState(
      categories: categories ?? this.categories,
      allItems: allItems ?? this.allItems,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  List<FoodItem> getItemsByCategory(String categoryId) {
    return allItems
        .where((i) => i.categoryId == categoryId && i.isAvailable)
        .toList();
  }

  List<FoodItem> get popularItems =>
      allItems.where((i) => i.isPopular && i.isAvailable).toList();

  List<FoodItem> search(String query) {
    if (query.isEmpty) return allItems;
    final q = query.toLowerCase();
    return allItems
        .where((i) =>
            i.name.toLowerCase().contains(q) ||
            i.description.toLowerCase().contains(q))
        .toList();
  }
}

class MenuNotifier extends StateNotifier<MenuState> {
  MenuNotifier()
      : super(MenuState(
          categories: MenuData.categories,
          allItems: MenuData.allItems,
        )) {
    _loadCustomItems();
  }

  Future<void> _loadCustomItems() async {
    final custom = await StorageService.loadCustomMenuItems();
    if (custom.isNotEmpty) {
      state = state.copyWith(
        allItems: [...MenuData.allItems, ...custom],
      );
    }
  }

  Future<void> addItem(FoodItem item) async {
    final custom = await StorageService.loadCustomMenuItems();
    custom.add(item);
    await StorageService.saveCustomMenuItems(custom);
    state = state.copyWith(
        allItems: [...MenuData.allItems, ...custom]);
  }

  Future<void> updateItem(FoodItem updated) async {
    final isDefault =
        MenuData.allItems.any((i) => i.id == updated.id);

    if (isDefault) {
      // For default items, we override availability in custom list
      final custom = await StorageService.loadCustomMenuItems();
      final idx = custom.indexWhere((i) => i.id == updated.id);
      if (idx >= 0) {
        custom[idx] = updated;
      } else {
        custom.add(updated);
      }
      await StorageService.saveCustomMenuItems(custom);
    } else {
      final custom = await StorageService.loadCustomMenuItems();
      final idx = custom.indexWhere((i) => i.id == updated.id);
      if (idx >= 0) {
        custom[idx] = updated;
        await StorageService.saveCustomMenuItems(custom);
      }
    }

    final custom = await StorageService.loadCustomMenuItems();
    final base = MenuData.allItems
        .map((i) {
          final override = custom.firstWhere(
            (c) => c.id == i.id,
            orElse: () => i,
          );
          return override;
        })
        .toList();
    final customOnly = custom.where(
        (c) => !MenuData.allItems.any((d) => d.id == c.id)).toList();
    state = state.copyWith(allItems: [...base, ...customOnly]);
  }

  Future<void> deleteItem(String itemId) async {
    final custom = await StorageService.loadCustomMenuItems();
    custom.removeWhere((i) => i.id == itemId);
    await StorageService.saveCustomMenuItems(custom);
    final base = MenuData.allItems.where(
        (i) => !custom.any((c) => c.id == i.id && !c.isAvailable)).toList();
    state = state.copyWith(allItems: [...base, ...custom]);
  }
}

final menuProvider =
    StateNotifierProvider<MenuNotifier, MenuState>((ref) => MenuNotifier());
