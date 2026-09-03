import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/models/order_model.dart';
import '../../../providers/order_provider.dart';

class OrderTrackingScreen extends ConsumerStatefulWidget {
  final String orderId;
  const OrderTrackingScreen({super.key, required this.orderId});

  @override
  ConsumerState<OrderTrackingScreen> createState() =>
      _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends ConsumerState<OrderTrackingScreen> {
  @override
  Widget build(BuildContext context) {
    final orderState = ref.watch(orderProvider);
    final order = orderState.getOrderById(widget.orderId);

    if (order == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Track Order')),
        body: const Center(child: Text('Order not found')),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Track Order ${AppFormatters.formatOrderId(order.id)}',
          style: GoogleFonts.poppins(
              color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16),
        ),
        leading: IconButton(
          onPressed: () => context.go('/home'),
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Status Card
          _buildStatusCard(order),

          const SizedBox(height: 20),

          // Progress Stepper
          _buildProgressStepper(order.status),

          const SizedBox(height: 20),

          // Order Details
          _buildOrderDetails(order),

          const SizedBox(height: 20),

          // Items list
          _buildItemsList(order),

          const SizedBox(height: 24),

          // Help button
          OutlinedButton.icon(
            onPressed: () => context.go('/home'),
            icon: const Icon(Icons.home_outlined),
            label: Text('Back to Menu',
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 48),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard(OrderModel order) {
    Color statusColor;
    switch (order.status) {
      case OrderStatus.pending:
        statusColor = AppColors.statusPending;
        break;
      case OrderStatus.preparing:
        statusColor = AppColors.statusPreparing;
        break;
      case OrderStatus.ready:
        statusColor = AppColors.statusReady;
        break;
      case OrderStatus.served:
        statusColor = AppColors.statusServed;
        break;
      case OrderStatus.completed:
        statusColor = AppColors.statusCompleted;
        break;
      case OrderStatus.cancelled:
        statusColor = AppColors.statusCancelled;
        break;
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: statusColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: statusColor.withOpacity(0.4),
            blurRadius: 16,
            offset: const Offset(0, 6),
          )
        ],
      ),
      child: Row(
        children: [
          Text(
            order.status.emoji,
            style: const TextStyle(fontSize: 40),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  order.status.label,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  order.status.description,
                  style: GoogleFonts.inter(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().scale(duration: 400.ms, curve: Curves.easeOut);
  }

  Widget _buildProgressStepper(OrderStatus currentStatus) {
    final steps = [
      OrderStatus.pending,
      OrderStatus.preparing,
      OrderStatus.ready,
      OrderStatus.served,
      OrderStatus.completed,
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Order Progress',
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w700, fontSize: 14)),
          const SizedBox(height: 16),
          ...steps.asMap().entries.map((e) {
            final stepStatus = e.value;
            final isCompleted =
                currentStatus.stepIndex >= stepStatus.stepIndex &&
                    currentStatus != OrderStatus.cancelled;
            final isActive = currentStatus == stepStatus;

            return _StepItem(
              status: stepStatus,
              isCompleted: isCompleted,
              isActive: isActive,
              isLast: e.key == steps.length - 1,
            );
          }),
        ],
      ),
    );
  }

  Widget _buildOrderDetails(OrderModel order) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Order Details',
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w700, fontSize: 14)),
          const Divider(height: 20),
          _DetailRow('Table', 'Table ${order.tableNumber}'),
          _DetailRow('Order Time',
              AppFormatters.formatDateShort(order.createdAt)),
          _DetailRow('Payment', order.paymentMethod.label),
          _DetailRow(
              'Total', AppFormatters.formatPrice(order.total),
              isBold: true),
        ],
      ),
    );
  }

  Widget _buildItemsList(OrderModel order) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Items Ordered',
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w700, fontSize: 14)),
          const Divider(height: 20),
          ...order.items.map((ci) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        '${ci.quantity}× ${ci.item.name}${ci.selectedVariant != null ? " (${ci.selectedVariant!.label})" : ""}',
                        style: GoogleFonts.inter(
                            fontSize: 13,
                            color: AppColors.textSecondary),
                      ),
                    ),
                    Text(
                      AppFormatters.formatPrice(ci.totalPrice),
                      style: GoogleFonts.inter(
                          fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}

class _StepItem extends StatelessWidget {
  final OrderStatus status;
  final bool isCompleted;
  final bool isActive;
  final bool isLast;

  const _StepItem({
    required this.status,
    required this.isCompleted,
    required this.isActive,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Circle + line
        Column(
          children: [
            AnimatedContainer(
              duration: 300.ms,
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: isCompleted ? AppColors.primary : Colors.grey[200],
                shape: BoxShape.circle,
                border: Border.all(
                  color: isActive ? AppColors.accent : Colors.transparent,
                  width: 2,
                ),
              ),
              child: Center(
                child: isCompleted
                    ? (isActive
                        ? Text(status.emoji,
                            style: const TextStyle(fontSize: 14))
                        : const Icon(Icons.check,
                            color: Colors.white, size: 16))
                    : Text(status.emoji,
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[400])),
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 32,
                color: isCompleted ? AppColors.primary : Colors.grey[200],
              ),
          ],
        ),

        const SizedBox(width: 12),

        // Text
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 4, bottom: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  status.label,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: isActive
                        ? FontWeight.w700
                        : FontWeight.w500,
                    color: isCompleted
                        ? AppColors.primary
                        : Colors.grey[400],
                  ),
                ),
                if (isActive)
                  Text(
                    status.description,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: AppColors.textHint,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;

  const _DetailRow(this.label, this.value, {this.isBold = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: GoogleFonts.inter(
                  fontSize: 13, color: AppColors.textSecondary)),
          Text(value,
              style: GoogleFonts.poppins(
                fontWeight: isBold ? FontWeight.w700 : FontWeight.w600,
                fontSize: 13,
                color: isBold ? AppColors.primary : AppColors.textPrimary,
              )),
        ],
      ),
    );
  }
}
