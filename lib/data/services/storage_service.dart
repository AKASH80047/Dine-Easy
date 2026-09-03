import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/order_model.dart';
import '../models/food_item.dart';
import '../models/restaurant_table.dart';

class StorageService {
  static const _ordersKey = 'pandey_orders';
  static const _tablesKey = 'pandey_tables';
  static const _menuItemsKey = 'pandey_menu_items';
  static const _tableSessionKey = 'pandey_current_table';
  static const _adminPasswordKey = 'pandey_admin_password';
  static const _defaultAdminPassword = 'admin123';

  // ── Orders ──────────────────────────────────────────────────────────────────
  static Future<List<OrderModel>> loadOrders() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_ordersKey);
    if (raw == null) return [];
    try {
      final list = jsonDecode(raw) as List;
      return list
          .map((e) => OrderModel.fromMap(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  static Future<void> saveOrders(List<OrderModel> orders) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        _ordersKey, jsonEncode(orders.map((o) => o.toMap()).toList()));
  }

  static Future<void> addOrder(OrderModel order) async {
    final orders = await loadOrders();
    orders.insert(0, order);
    await saveOrders(orders);
  }

  static Future<void> updateOrderStatus(
      String orderId, OrderStatus status) async {
    final orders = await loadOrders();
    final idx = orders.indexWhere((o) => o.id == orderId);
    if (idx != -1) {
      orders[idx] = orders[idx].copyWith(
        status: status,
        updatedAt: DateTime.now(),
      );
      await saveOrders(orders);
    }
  }

  // ── Custom Menu Items (admin-added) ─────────────────────────────────────────
  static Future<List<FoodItem>> loadCustomMenuItems() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_menuItemsKey);
    if (raw == null) return [];
    try {
      final list = jsonDecode(raw) as List;
      return list
          .map((e) => FoodItem.fromMap(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  static Future<void> saveCustomMenuItems(List<FoodItem> items) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        _menuItemsKey, jsonEncode(items.map((i) => i.toMap()).toList()));
  }

  // ── Tables ──────────────────────────────────────────────────────────────────
  static Future<List<RestaurantTable>> loadTables() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_tablesKey);
    if (raw == null) return [];
    try {
      final list = jsonDecode(raw) as List;
      return list
          .map((e) => RestaurantTable.fromMap(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  static Future<void> saveTables(List<RestaurantTable> tables) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        _tablesKey, jsonEncode(tables.map((t) => t.toMap()).toList()));
  }

  // ── Current Table Session ────────────────────────────────────────────────────
  static Future<String?> getCurrentTable() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tableSessionKey);
  }

  static Future<void> setCurrentTable(String tableNumber) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tableSessionKey, tableNumber);
  }

  static Future<void> clearCurrentTable() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tableSessionKey);
  }

  // ── Admin Password ───────────────────────────────────────────────────────────
  static Future<String> getAdminPassword() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_adminPasswordKey) ?? _defaultAdminPassword;
  }

  static Future<void> setAdminPassword(String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_adminPasswordKey, password);
  }

  static Future<bool> verifyAdminPassword(String password) async {
    final stored = await getAdminPassword();
    return stored == password;
  }
}
