import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/models/order_model.dart';
import '../../../providers/order_provider.dart';
import '../../../providers/admin_provider.dart';

class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderState = ref.watch(orderProvider);
    final todayOrders = orderState.todayOrders;
    final activeOrders = orderState.activeOrders;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            const Text('🍔', style: TextStyle(fontSize: 22)),
            const SizedBox(width: 8),
            Text(
              'Admin Dashboard',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              ref.read(adminProvider.notifier).logout();
              context.go('/admin');
            },
            icon: const Icon(Icons.logout, color: Colors.white),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.read(orderProvider.notifier).refreshOrders(),
        color: AppColors.primary,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Stats Row
            _buildStatsRow(todayOrders, activeOrders),

            const SizedBox(height: 20),

            // Quick Actions
            Text(
              'Quick Actions',
              style: GoogleFonts.poppins(
                  fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            _buildQuickActions(context),

            const SizedBox(height: 20),

            // Active Orders
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '🔔 Active Orders (${activeOrders.length})',
                  style: GoogleFonts.poppins(
                      fontSize: 16, fontWeight: FontWeight.w700),
                ),
                TextButton(
                  onPressed: () => context.push('/admin/orders'),
                  child: Text('See All',
                      style: GoogleFonts.inter(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600)),
                ),
              ],
            ),

            if (activeOrders.isEmpty)
              _buildEmptyOrders()
            else
              ...activeOrders.take(5).toList().asMap().entries.map((e) {
                return _AdminOrderCard(
                  order: e.value,
                  onStatusUpdate: (status) {
                    ref
                        .read(orderProvider.notifier)
                        .updateOrderStatus(e.value.id, status);
                  },
                ).animate().slideX(
                      begin: 0.1,
                      delay: Duration(milliseconds: e.key * 60),
                      duration: 300.ms,
                    );
              }),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsRow(
      List<OrderModel> todayOrders, List<OrderModel> activeOrders) {
    return Row(
      children: [
        _StatCard(
          title: "Today's Orders",
          value: '${todayOrders.length}',
          icon: Icons.receipt_long,
          color: AppColors.primary,
          flex: 1,
        ),
        const SizedBox(width: 12),
        _StatCard(
          title: "Today's Revenue",
          value: AppFormatters.formatPrice(
              todayOrders.fold(0.0, (s, o) => s + o.total)),
          icon: Icons.currency_rupee,
          color: AppColors.accent,
          flex: 1,
        ),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    final actions = [
      _QuickAction(
          icon: Icons.receipt_long,
          label: 'Orders',
          color: AppColors.primary,
          route: '/admin/orders'),
      _QuickAction(
          icon: Icons.menu_book,
          label: 'Menu',
          color: AppColors.accent,
          route: '/admin/menu'),
      _QuickAction(
          icon: Icons.bar_chart,
          label: 'Analytics',
          color: AppColors.primaryLight,
          route: '/admin/analytics'),
      _QuickAction(
          icon: Icons.qr_code,
          label: 'Tables',
          color: Colors.purple,
          route: '/admin/tables'),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 0.85,
        crossAxisSpacing: 10,
      ),
      itemCount: actions.length,
      itemBuilder: (ctx, i) {
        final a = actions[i];
        return GestureDetector(
          onTap: () => context.push(a.route),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: a.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(a.icon, color: a.color, size: 26),
              ),
              const SizedBox(height: 6),
              Text(
                a.label,
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ).animate().scale(
              delay: Duration(milliseconds: i * 60),
              duration: 300.ms,
              curve: Curves.easeOut,
            );
      },
    );
  }

  Widget _buildEmptyOrders() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Text('🎉', style: TextStyle(fontSize: 40)),
          const SizedBox(height: 8),
          Text(
            'No active orders',
            style: GoogleFonts.inter(
                color: AppColors.textHint, fontSize: 14),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final int flex;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.flex = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.15),
              blurRadius: 12,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(height: 10),
            Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 11,
                color: AppColors.textHint,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickAction {
  final IconData icon;
  final String label;
  final Color color;
  final String route;
  const _QuickAction(
      {required this.icon,
      required this.label,
      required this.color,
      required this.route});
}

// ─────────────────────────────────────────────────────────────────────────────
//  Admin Order Card
// ─────────────────────────────────────────────────────────────────────────────
class _AdminOrderCard extends StatelessWidget {
  final OrderModel order;
  final Function(OrderStatus) onStatusUpdate;

  const _AdminOrderCard({required this.order, required this.onStatusUpdate});

  Color get _statusColor {
    switch (order.status) {
      case OrderStatus.pending:
        return AppColors.statusPending;
      case OrderStatus.preparing:
        return AppColors.statusPreparing;
      case OrderStatus.ready:
        return AppColors.statusReady;
      case OrderStatus.served:
        return AppColors.statusServed;
      default:
        return AppColors.textHint;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border(
            left: BorderSide(color: _statusColor, width: 4)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppFormatters.formatOrderId(order.id),
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w700, fontSize: 14),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${order.status.emoji} ${order.status.label}',
                    style: GoogleFonts.inter(
                      color: _statusColor,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 6),

            Row(
              children: [
                const Icon(Icons.table_restaurant,
                    size: 14, color: AppColors.textHint),
                const SizedBox(width: 4),
                Text(
                  'Table ${order.tableNumber}',
                  style: GoogleFonts.inter(
                      fontSize: 12, color: AppColors.textSecondary),
                ),
                const SizedBox(width: 12),
                const Icon(Icons.access_time,
                    size: 14, color: AppColors.textHint),
                const SizedBox(width: 4),
                Text(
                  AppFormatters.formatTime(order.createdAt),
                  style: GoogleFonts.inter(
                      fontSize: 12, color: AppColors.textSecondary),
                ),
                const Spacer(),
                Text(
                  AppFormatters.formatPrice(order.total),
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                    fontSize: 14,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Items preview
            Text(
              order.items
                  .map((i) => '${i.quantity}× ${i.item.name}')
                  .join(', '),
              style: GoogleFonts.inter(
                  fontSize: 12, color: AppColors.textHint),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 12),

            // Status action buttons
            Row(
              children: _buildActionButtons(),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildActionButtons() {
    final actions = <Widget>[];

    if (order.status == OrderStatus.pending) {
      actions.add(_ActionBtn(
        'Accept',
        AppColors.statusPreparing,
        () => onStatusUpdate(OrderStatus.preparing),
      ));
      actions.add(const SizedBox(width: 8));
      actions.add(_ActionBtn(
        'Cancel',
        AppColors.statusCancelled,
        () => onStatusUpdate(OrderStatus.cancelled),
        isOutlined: true,
      ));
    } else if (order.status == OrderStatus.preparing) {
      actions.add(_ActionBtn(
        '✅ Mark Ready',
        AppColors.statusReady,
        () => onStatusUpdate(OrderStatus.ready),
      ));
    } else if (order.status == OrderStatus.ready) {
      actions.add(_ActionBtn(
        '🍽️ Mark Served',
        AppColors.statusServed,
        () => onStatusUpdate(OrderStatus.served),
      ));
    } else if (order.status == OrderStatus.served) {
      actions.add(_ActionBtn(
        '✔ Complete',
        AppColors.statusCompleted,
        () => onStatusUpdate(OrderStatus.completed),
      ));
    }

    return actions;
  }
}

class _ActionBtn extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;
  final bool isOutlined;

  const _ActionBtn(this.label, this.color, this.onTap,
      {this.isOutlined = false});

  @override
  Widget build(BuildContext context) {
    return isOutlined
        ? OutlinedButton(
            onPressed: onTap,
            style: OutlinedButton.styleFrom(
              foregroundColor: color,
              side: BorderSide(color: color),
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: Text(label,
                style:
                    GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 12)),
          )
        : ElevatedButton(
            onPressed: onTap,
            style: ElevatedButton.styleFrom(
              backgroundColor: color,
              foregroundColor: Colors.white,
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              elevation: 0,
            ),
            child: Text(label,
                style:
                    GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 12)),
          );
  }
}
