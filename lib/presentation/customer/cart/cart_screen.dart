import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../providers/cart_provider.dart';

class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});

  @override
  ConsumerState<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  final _instructionController = TextEditingController();

  @override
  void dispose() {
    _instructionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cart = ref.watch(cartProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'My Cart',
          style: GoogleFonts.poppins(
              color: Colors.white, fontWeight: FontWeight.w700),
        ),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        actions: [
          if (!cart.isEmpty)
            TextButton(
              onPressed: () => _showClearConfirm(context),
              child: Text(
                'Clear',
                style: GoogleFonts.inter(
                    color: Colors.white70, fontWeight: FontWeight.w600),
              ),
            ),
        ],
      ),
      body: cart.isEmpty
          ? _buildEmptyCart(context)
          : Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      // Table info
                      _buildTableInfo(cart.tableNumber),

                      const SizedBox(height: 16),

                      // Cart Items
                      ...cart.items.asMap().entries.map((e) {
                        final idx = e.key;
                        final item = e.value;
                        return _CartItemCard(
                          cartItem: item,
                          onIncrease: () =>
                              ref.read(cartProvider.notifier).increaseQuantity(
                                  item.item.id,
                                  variantLabel:
                                      item.selectedVariant?.label),
                          onDecrease: () =>
                              ref.read(cartProvider.notifier).decreaseQuantity(
                                  item.item.id,
                                  variantLabel:
                                      item.selectedVariant?.label),
                          onRemove: () =>
                              ref.read(cartProvider.notifier).removeItem(
                                  item.item.id,
                                  variantLabel:
                                      item.selectedVariant?.label),
                        ).animate().slideX(
                              begin: 0.1,
                              delay: Duration(milliseconds: idx * 60),
                              duration: 300.ms,
                            );
                      }),

                      const SizedBox(height: 16),

                      // Special Instruction
                      _buildSpecialInstruction(),

                      const SizedBox(height: 16),

                      // Bill Summary
                      _buildBillSummary(cart),

                      const SizedBox(height: 100),
                    ],
                  ),
                ),

                // Checkout Button
                _buildCheckoutButton(cart, context),
              ],
            ),
    );
  }

  Widget _buildTableInfo(String tableNumber) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.primarySurface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.primary.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.table_restaurant, color: AppColors.primary, size: 22),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Ordering for',
                style: GoogleFonts.inter(
                    fontSize: 12, color: AppColors.textSecondary),
              ),
              Text(
                tableNumber.isNotEmpty ? 'Table $tableNumber' : 'No table selected',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const Spacer(),
          TextButton(
            onPressed: () => context.push('/table-select'),
            child: Text(
              'Change',
              style: GoogleFonts.inter(
                  color: AppColors.primary, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecialInstruction() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '📝 Special Instructions',
          style: GoogleFonts.poppins(
              fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _instructionController,
          maxLines: 2,
          decoration: InputDecoration(
            hintText:
                'e.g. Less spicy, no onion, extra chutney...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.divider),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
          ),
          onChanged: (v) =>
              ref.read(cartProvider.notifier).setSpecialInstruction(v),
        ),
      ],
    );
  }

  Widget _buildBillSummary(CartState cart) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Bill Summary',
            style: GoogleFonts.poppins(
                fontSize: 15, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 14),
          _BillRow(
              label: 'Subtotal',
              value: AppFormatters.formatPrice(cart.subtotal)),
          const SizedBox(height: 8),
          _BillRow(
              label: 'GST (5%)',
              value: AppFormatters.formatPrice(cart.gst),
              isSubtle: true),
          const Divider(height: 20),
          _BillRow(
            label: 'Grand Total',
            value: AppFormatters.formatPrice(cart.total),
            isBold: true,
          ),
        ],
      ),
    );
  }

  Widget _buildCheckoutButton(CartState cart, BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, -2),
          )
        ],
      ),
      child: ElevatedButton(
        onPressed: cart.hasTable
            ? () => context.push('/payment')
            : () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please select a table first')),
                );
              },
        style: ElevatedButton.styleFrom(
          backgroundColor:
              cart.hasTable ? AppColors.primary : AppColors.textHint,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 52),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${cart.itemCount} items',
              style: GoogleFonts.inter(
                  fontSize: 13, fontWeight: FontWeight.w600),
            ),
            Text(
              'Proceed to Checkout →',
              style: GoogleFonts.poppins(
                  fontSize: 15, fontWeight: FontWeight.w700),
            ),
            Text(
              AppFormatters.formatPrice(cart.total),
              style: GoogleFonts.poppins(
                  fontSize: 15, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyCart(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('🛒', style: TextStyle(fontSize: 64))
              .animate()
              .scale(duration: 400.ms, curve: Curves.elasticOut),
          const SizedBox(height: 16),
          Text(
            'Your cart is empty',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ).animate().fade(delay: 200.ms),
          const SizedBox(height: 8),
          Text(
            'Add items from the menu to get started!',
            style: GoogleFonts.inter(
              color: AppColors.textHint,
              fontSize: 14,
            ),
          ).animate().fade(delay: 300.ms),
          const SizedBox(height: 28),
          ElevatedButton(
            onPressed: () => context.go('/home'),
            child: const Text('Browse Menu'),
          ).animate().slideY(begin: 0.3, delay: 400.ms),
        ],
      ),
    );
  }

  void _showClearConfirm(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Clear Cart?',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w700)),
        content: Text('All items will be removed.',
            style: GoogleFonts.inter()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(cartProvider.notifier).clearItems();
              Navigator.pop(ctx);
            },
            style:
                ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Cart Item Card
// ─────────────────────────────────────────────────────────────────────────────
class _CartItemCard extends StatelessWidget {
  final dynamic cartItem;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;
  final VoidCallback onRemove;

  const _CartItemCard({
    required this.cartItem,
    required this.onIncrease,
    required this.onDecrease,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
          )
        ],
      ),
      child: Row(
        children: [
          // Image
          ClipRRect(
            borderRadius:
                const BorderRadius.horizontal(left: Radius.circular(14)),
            child: CachedNetworkImage(
              imageUrl: cartItem.item.imageUrl,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              errorWidget: (_, __, ___) => Container(
                width: 80,
                height: 80,
                color: AppColors.primarySurface,
                child: const Icon(Icons.fastfood,
                    color: AppColors.primary),
              ),
            ),
          ),

          // Info
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cartItem.item.name +
                        (cartItem.selectedVariant != null
                            ? ' (${cartItem.selectedVariant!.label})'
                            : ''),
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppFormatters.formatPrice(cartItem.totalPrice),
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                      // Qty controls
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.primary),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            InkWell(
                              onTap: onDecrease,
                              child: const Padding(
                                padding: EdgeInsets.all(6),
                                child: Icon(Icons.remove,
                                    size: 14,
                                    color: AppColors.primary),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10),
                              child: Text(
                                '${cartItem.quantity}',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: onIncrease,
                              child: const Padding(
                                padding: EdgeInsets.all(6),
                                child: Icon(Icons.add,
                                    size: 14,
                                    color: AppColors.primary),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Remove button
          IconButton(
            onPressed: onRemove,
            icon: const Icon(Icons.delete_outline,
                color: AppColors.error, size: 20),
          ),
        ],
      ),
    );
  }
}

class _BillRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;
  final bool isSubtle;

  const _BillRow({
    required this.label,
    required this.value,
    this.isBold = false,
    this.isSubtle = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: isBold ? 15 : 13,
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w400,
            color: isSubtle ? AppColors.textSecondary : AppColors.textPrimary,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: isBold ? 16 : 13,
            fontWeight: isBold ? FontWeight.w800 : FontWeight.w600,
            color: isBold ? AppColors.primary : AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
