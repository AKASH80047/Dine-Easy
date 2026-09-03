import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/models/order_model.dart';
import '../../../providers/order_provider.dart';

class OrderSuccessScreen extends ConsumerWidget {
  final String orderId;
  const OrderSuccessScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final order = ref.watch(orderProvider).getOrderById(orderId);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Success animation
              const Icon(
                Icons.check_circle_rounded,
                color: AppColors.success,
                size: 100,
              ).animate().scale(
                    duration: 600.ms,
                    curve: Curves.elasticOut,
                  ),

              const SizedBox(height: 16),

              Text(
                '🎉 Order Placed!',
                style: GoogleFonts.poppins(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ).animate().slideY(begin: 0.3, delay: 300.ms).fade(delay: 300.ms),

              const SizedBox(height: 8),

              Text(
                'Your food is being prepared.\nSit back and relax!',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 15,
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ).animate().fade(delay: 500.ms),

              if (order != null) ...[
                const SizedBox(height: 28),

                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 12,
                      )
                    ],
                  ),
                  child: Column(
                    children: [
                      _InfoRow(
                        label: 'Order ID',
                        value: AppFormatters.formatOrderId(order.id),
                        isBold: true,
                      ),
                      const Divider(height: 20),
                      _InfoRow(
                        label: 'Table',
                        value: 'Table ${order.tableNumber}',
                      ),
                      const SizedBox(height: 8),
                      _InfoRow(
                        label: 'Items',
                        value: '${order.totalItems} items',
                      ),
                      const SizedBox(height: 8),
                      _InfoRow(
                        label: 'Amount',
                        value: AppFormatters.formatPrice(order.total),
                        isBold: true,
                        valueColor: AppColors.primary,
                      ),
                      const SizedBox(height: 8),
                      _InfoRow(
                        label: 'Payment',
                        value: order.paymentMethod == PaymentMethod.online
                            ? 'Online Payment'
                            : 'Pay at Counter',
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.statusPending.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('⏳',
                                style: TextStyle(fontSize: 16)),
                            const SizedBox(width: 8),
                            Text(
                              'Status: Pending Confirmation',
                              style: GoogleFonts.inter(
                                color: AppColors.statusPending,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ).animate().slideY(begin: 0.3, delay: 400.ms).fade(delay: 400.ms),
              ],

              const SizedBox(height: 28),

              // Track Order Button
              ElevatedButton.icon(
                onPressed: () => context.go('/tracking/$orderId'),
                icon: const Icon(Icons.location_on_outlined),
                label: Text(
                  'Track My Order',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w700),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
              ).animate().slideY(begin: 0.3, delay: 600.ms).fade(delay: 600.ms),

              const SizedBox(height: 12),

              OutlinedButton.icon(
                onPressed: () => context.go('/home'),
                icon: const Icon(Icons.menu_book_outlined),
                label: Text(
                  'Back to Menu',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                ),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
              ).animate().slideY(begin: 0.3, delay: 700.ms).fade(delay: 700.ms),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;
  final Color? valueColor;

  const _InfoRow({
    required this.label,
    required this.value,
    this.isBold = false,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: GoogleFonts.inter(
                fontSize: 13, color: AppColors.textSecondary)),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: isBold ? 14 : 13,
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
            color: valueColor ?? AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
