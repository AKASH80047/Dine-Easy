import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/models/order_model.dart';
import '../../../providers/cart_provider.dart';
import '../../../providers/order_provider.dart';

class PaymentScreen extends ConsumerStatefulWidget {
  const PaymentScreen({super.key});

  @override
  ConsumerState<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends ConsumerState<PaymentScreen> {
  PaymentMethod _selectedMethod = PaymentMethod.cash;
  bool _isProcessing = false;

  Future<void> _placeOrder() async {
    final cart = ref.read(cartProvider);
    if (cart.isEmpty) return;

    setState(() => _isProcessing = true);

    // Simulate payment processing
    if (_selectedMethod == PaymentMethod.online) {
      await Future.delayed(const Duration(seconds: 2));
    }

    final orderId = await ref.read(orderProvider.notifier).placeOrder(
          tableNumber: cart.tableNumber,
          items: cart.items,
          subtotal: cart.subtotal,
          gst: cart.gst,
          total: cart.total,
          paymentMethod: _selectedMethod,
          specialInstruction: cart.specialInstruction,
        );

    ref.read(cartProvider.notifier).clearItems();

    if (mounted) {
      context.go('/success/$orderId');
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = ref.watch(cartProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Payment',
            style: GoogleFonts.poppins(
                color: Colors.white, fontWeight: FontWeight.w700)),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
      ),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Order summary
              _buildOrderSummary(cart),

              const SizedBox(height: 20),

              // Payment method selection
              Text(
                '💳 Choose Payment Method',
                style: GoogleFonts.poppins(
                    fontSize: 16, fontWeight: FontWeight.w700),
              ),

              const SizedBox(height: 12),

              // Online Payment
              _PaymentMethodCard(
                title: 'Pay Online',
                subtitle: 'UPI / QR Code / Google Pay / PhonePe / Paytm',
                icon: Icons.payment,
                iconColor: AppColors.primaryLight,
                isSelected: _selectedMethod == PaymentMethod.online,
                onTap: () =>
                    setState(() => _selectedMethod = PaymentMethod.online),
                badge: 'RECOMMENDED',
                badgeColor: AppColors.primary,
                logos: const ['G', 'P', 'B'],
              ).animate().slideX(begin: 0.1, duration: 300.ms),

              const SizedBox(height: 12),

              // Cash Payment
              _PaymentMethodCard(
                title: 'Pay at Counter',
                subtitle: 'Pay cash when your order arrives',
                icon: Icons.money,
                iconColor: AppColors.accent,
                isSelected: _selectedMethod == PaymentMethod.cash,
                onTap: () =>
                    setState(() => _selectedMethod = PaymentMethod.cash),
              ).animate().slideX(begin: 0.1, delay: 100.ms, duration: 300.ms),

              const SizedBox(height: 24),

              // UPI Payment info (if online selected)
              if (_selectedMethod == PaymentMethod.online) ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.primarySurface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                        color: AppColors.primary.withOpacity(0.3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('📱 Scan & Pay with UPI',
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary)),
                      const SizedBox(height: 6),
                      Text(
                        'After tapping "Place Order", show your payment app to the counter to confirm.',
                        style: GoogleFonts.inter(
                            fontSize: 13,
                            color: AppColors.textSecondary),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        children: ['Google Pay', 'PhonePe', 'Paytm', 'UPI']
                            .map((e) => Chip(
                                  label: Text(e,
                                      style:
                                          GoogleFonts.inter(fontSize: 11)),
                                  backgroundColor: Colors.white,
                                  side: const BorderSide(
                                      color: AppColors.primary),
                                ))
                            .toList(),
                      ),
                    ],
                  ),
                ).animate().fade(duration: 300.ms),
                const SizedBox(height: 16),
              ],

              // Total
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primary, AppColors.primaryLight],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Amount to Pay',
                          style: GoogleFonts.inter(
                              color: Colors.white70, fontSize: 12),
                        ),
                        Text(
                          AppFormatters.formatPrice(cart.total),
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Table ${cart.tableNumber}',
                          style: GoogleFonts.inter(
                              color: Colors.white70, fontSize: 12),
                        ),
                        Text(
                          '${cart.itemCount} items',
                          style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 100),
            ],
          ),

          // Processing overlay
          if (_isProcessing)
            Container(
              color: Colors.black45,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircularProgressIndicator(
                        color: AppColors.primary,
                        strokeWidth: 3,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _selectedMethod == PaymentMethod.online
                            ? 'Processing Payment...'
                            : 'Placing Order...',
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        color: Colors.white,
        child: ElevatedButton.icon(
          onPressed: _isProcessing ? null : _placeOrder,
          icon: Icon(
            _selectedMethod == PaymentMethod.online
                ? Icons.payment
                : Icons.check_circle_outline,
          ),
          label: Text(
            _selectedMethod == PaymentMethod.online
                ? 'Pay ${AppFormatters.formatPrice(cart.total)}'
                : 'Place Order — Pay at Counter',
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.w700, fontSize: 15),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: _selectedMethod == PaymentMethod.online
                ? AppColors.accent
                : AppColors.primary,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 52),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14)),
          ),
        ),
      ),
    );
  }

  Widget _buildOrderSummary(CartState cart) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Order Summary',
              style: GoogleFonts.poppins(
                  fontSize: 15, fontWeight: FontWeight.w700)),
          const SizedBox(height: 10),
          ...cart.items.map((item) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        '${item.quantity}× ${item.item.name}${item.selectedVariant != null ? " (${item.selectedVariant!.label})" : ""}',
                        style: GoogleFonts.inter(
                            fontSize: 13, color: AppColors.textSecondary),
                      ),
                    ),
                    Text(
                      AppFormatters.formatPrice(item.totalPrice),
                      style: GoogleFonts.inter(
                          fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              )),
          const Divider(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('GST (5%)',
                  style: GoogleFonts.inter(
                      fontSize: 12, color: AppColors.textHint)),
              Text(AppFormatters.formatPrice(cart.gst),
                  style: GoogleFonts.inter(fontSize: 12)),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total',
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w700, fontSize: 14)),
              Text(AppFormatters.formatPrice(cart.total),
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w800,
                      fontSize: 15,
                      color: AppColors.primary)),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Payment Method Card
// ─────────────────────────────────────────────────────────────────────────────
class _PaymentMethodCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final bool isSelected;
  final VoidCallback onTap;
  final String? badge;
  final Color? badgeColor;
  final List<String>? logos;

  const _PaymentMethodCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.isSelected,
    required this.onTap,
    this.badge,
    this.badgeColor,
    this.logos,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: 200.ms,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withOpacity(0.05)
              : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.divider,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
            )
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 26),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      if (badge != null) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: badgeColor ?? AppColors.primary,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            badge!,
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Radio<bool>(
              value: true,
              groupValue: isSelected,
              onChanged: (_) => onTap(),
              activeColor: AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }
}
