import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/services/storage_service.dart';

class AdminState {
  final bool isLoggedIn;
  final bool isLoading;
  final String? error;

  const AdminState({
    this.isLoggedIn = false,
    this.isLoading = false,
    this.error,
  });

  AdminState copyWith({
    bool? isLoggedIn,
    bool? isLoading,
    String? error,
  }) {
    return AdminState(
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class AdminNotifier extends StateNotifier<AdminState> {
  AdminNotifier() : super(const AdminState());

  Future<bool> login(String password) async {
    state = state.copyWith(isLoading: true, error: null);
    await Future.delayed(const Duration(milliseconds: 500)); // Simulate check
    final isValid = await StorageService.verifyAdminPassword(password);
    if (isValid) {
      state = state.copyWith(isLoggedIn: true, isLoading: false);
    } else {
      state = state.copyWith(
        isLoading: false,
        error: 'Invalid password. Try: admin123',
      );
    }
    return isValid;
  }

  void logout() {
    state = const AdminState();
  }

  Future<void> changePassword(String newPassword) async {
    await StorageService.setAdminPassword(newPassword);
  }
}

final adminProvider =
    StateNotifierProvider<AdminNotifier, AdminState>((ref) => AdminNotifier());
