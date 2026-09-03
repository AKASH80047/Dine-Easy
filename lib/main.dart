import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'core/theme/app_theme.dart';
import 'presentation/customer/splash/splash_screen.dart';
import 'presentation/customer/splash/table_select_screen.dart';
import 'presentation/customer/home/home_screen.dart';
import 'presentation/customer/menu/category_screen.dart';
import 'presentation/customer/menu/product_detail_screen.dart';
import 'presentation/customer/cart/cart_screen.dart';
import 'presentation/customer/payment/payment_screen.dart';
import 'presentation/customer/payment/order_success_screen.dart';
import 'presentation/customer/tracking/order_tracking_screen.dart';
import 'presentation/admin/auth/admin_login_screen.dart';
import 'presentation/admin/dashboard/admin_dashboard_screen.dart';
import 'presentation/admin/orders/order_management_screen.dart';
import 'presentation/admin/menu/menu_management_screen.dart';
import 'presentation/admin/analytics/analytics_screen.dart';
import 'presentation/admin/tables/table_qr_screen.dart';

void main() {
  runApp(
    const ProviderScope(
      child: PandeyFoodsApp(),
    ),
  );
}

final _router = GoRouter(
  initialLocation: '/',
  routes: [
    // ── Customer Routes ──────────────────────────────────────────────────
    GoRoute(
      path: '/',
      builder: (ctx, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/table-select',
      builder: (ctx, state) => const TableSelectScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (ctx, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/category/:id',
      builder: (ctx, state) => CategoryScreen(
        categoryId: state.pathParameters['id']!,
      ),
    ),
    GoRoute(
      path: '/product/:id',
      builder: (ctx, state) => ProductDetailScreen(
        foodId: state.pathParameters['id']!,
      ),
    ),
    GoRoute(
      path: '/cart',
      builder: (ctx, state) => const CartScreen(),
    ),
    GoRoute(
      path: '/payment',
      builder: (ctx, state) => const PaymentScreen(),
    ),
    GoRoute(
      path: '/success/:orderId',
      builder: (ctx, state) => OrderSuccessScreen(
        orderId: state.pathParameters['orderId']!,
      ),
    ),
    GoRoute(
      path: '/tracking/:orderId',
      builder: (ctx, state) => OrderTrackingScreen(
        orderId: state.pathParameters['orderId']!,
      ),
    ),

    // ── Admin Routes ─────────────────────────────────────────────────────
    GoRoute(
      path: '/admin',
      builder: (ctx, state) => const AdminLoginScreen(),
    ),
    GoRoute(
      path: '/admin/dashboard',
      builder: (ctx, state) => const AdminDashboardScreen(),
    ),
    GoRoute(
      path: '/admin/orders',
      builder: (ctx, state) => const OrderManagementScreen(),
    ),
    GoRoute(
      path: '/admin/menu',
      builder: (ctx, state) => const MenuManagementScreen(),
    ),
    GoRoute(
      path: '/admin/analytics',
      builder: (ctx, state) => const AnalyticsScreen(),
    ),
    GoRoute(
      path: '/admin/tables',
      builder: (ctx, state) => const TableQRScreen(),
    ),
  ],
);

class PandeyFoodsApp extends StatelessWidget {
  const PandeyFoodsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Pandey Foods',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: _router,
    );
  }
}
