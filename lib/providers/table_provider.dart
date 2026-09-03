import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/restaurant_table.dart';
import '../data/local/menu_data.dart';
import '../data/services/storage_service.dart';

class TableState {
  final List<RestaurantTable> tables;
  final String? selectedTableNumber;
  final bool isLoading;

  const TableState({
    this.tables = const [],
    this.selectedTableNumber,
    this.isLoading = false,
  });

  bool get hasTable =>
      selectedTableNumber != null && selectedTableNumber!.isNotEmpty;

  String get tableDisplay =>
      hasTable ? 'Table $selectedTableNumber' : 'Select Table';

  TableState copyWith({
    List<RestaurantTable>? tables,
    String? selectedTableNumber,
    bool? isLoading,
  }) {
    return TableState(
      tables: tables ?? this.tables,
      selectedTableNumber: selectedTableNumber ?? this.selectedTableNumber,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class TableNotifier extends StateNotifier<TableState> {
  TableNotifier() : super(const TableState()) {
    _init();
  }

  Future<void> _init() async {
    state = state.copyWith(isLoading: true);

    // Load saved tables or use defaults
    var tables = await StorageService.loadTables();
    if (tables.isEmpty) {
      tables = MenuData.defaultTables;
      await StorageService.saveTables(tables);
    }

    // Restore table session
    final savedTable = await StorageService.getCurrentTable();

    state = state.copyWith(
      tables: tables,
      selectedTableNumber: savedTable,
      isLoading: false,
    );
  }

  Future<void> selectTable(String tableNumber) async {
    await StorageService.setCurrentTable(tableNumber);
    state = state.copyWith(selectedTableNumber: tableNumber);
  }

  Future<void> clearTable() async {
    await StorageService.clearCurrentTable();
    state = TableState(tables: state.tables);
  }

  Future<void> addTable(RestaurantTable table) async {
    final tables = [...state.tables, table];
    await StorageService.saveTables(tables);
    state = state.copyWith(tables: tables);
  }

  Future<void> toggleTableActive(String tableId) async {
    final tables = state.tables.map((t) {
      if (t.id == tableId) return t.copyWith(isActive: !t.isActive);
      return t;
    }).toList();
    await StorageService.saveTables(tables);
    state = state.copyWith(tables: tables);
  }

  Future<void> deleteTable(String tableId) async {
    final tables = state.tables.where((t) => t.id != tableId).toList();
    await StorageService.saveTables(tables);
    state = state.copyWith(tables: tables);
  }
}

final tableProvider =
    StateNotifierProvider<TableNotifier, TableState>((ref) => TableNotifier());
