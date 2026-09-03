import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/models/food_item.dart';
import '../../../providers/cart_provider.dart';
import '../../../providers/menu_provider.dart';

class ProductDetailScreen extends ConsumerStatefulWidget {
  final String foodId;
  const ProductDetailScreen({super.key, required this.foodId});

  @override
  ConsumerState<ProductDetailScreen> createState() =>
      _ProductDetailScreenState();
}

class _ProductDetailScreenState extends ConsumerState<ProductDetailScreen> {
  FoodVariant? _selectedVariant;
  int _quantity = 1;

  FoodItem? get _item {
    final menu = ref.read(menuProvider);
    try {
      return menu.allItems.firstWhere((i) => i.id == widget.foodId);
    } catch (_) {
      return null;
    }
  }

  double get _unitPrice =>
      _selectedVariant?.price ?? (_item?.price ?? 0);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final item = _item;
      if (item != null && item.hasVariants) {
        setState(() => _selectedVariant = item.variants!.first);
      }
    });
  }

  void _addToCart() {
    final item = _item;
    if (item == null) return;

    for (int i = 0; i < _quantity; i++) {
      ref.read(cartProvider.notifier).addItem(
        item,
        variant: _selectedVariant,
      );
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 8),
            Text(
              '$_quantity × ${item.name} added!',
              style: GoogleFonts.inter(color: Colors.white),
            ),
          ],
        ),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final item = _item;
    if (item == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('Item not found')),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // Food Image Header
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: AppColors.primary,
            leading: IconButton(
              onPressed: () => context.pop(),
              icon: Container(
                padding: const EdgeInsets.all(6),
                decoration:
                    const BoxDecoration(color: Colors.black26, shape: BoxShape.circle),
                child:
                    const Icon(Icons.arrow_back, color: Colors.white),
              ),
            ),
            actions: [
              IconButton(
                onPressed: () => context.push('/cart'),
                icon: Container(
                  padding: const EdgeInsets.all(6),
                  decoration:
                      const BoxDecoration(color: Colors.black26, shape: BoxShape.circle),
                  child: const Icon(Icons.shopping_cart_outlined,
                      color: Colors.white),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: item.brand != null
                    ? const Color(0xFFF0FDF4)
                    : Colors.transparent,
                padding: item.brand != null
                    ? const EdgeInsets.all(28)
                    : EdgeInsets.zero,
                child: CachedNetworkImage(
                  imageUrl: item.imageUrl,
                  width: double.infinity,
                  height: double.infinity,
                  fit: item.brand != null ? BoxFit.contain : BoxFit.cover,
                  errorWidget: (_, __, ___) => Container(
                    color: AppColors.primarySurface,
                    child: Icon(
                      item.brand != null ? Icons.water_drop : Icons.fastfood,
                      color: item.brand != null
                          ? const Color(0xFF00A389)
                          : AppColors.primary,
                      size: 80,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Details
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Brand & Volume highlight if available
                    if (item.brand != null) ...[
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFF00A389),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'BRAND: ${item.brand!.toUpperCase()}',
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                          if (item.volume != null) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE0F2F1),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                  color: const Color(0xFF00A389).withOpacity(0.3),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.water_drop,
                                      size: 13, color: Color(0xFF00A389)),
                                  const SizedBox(width: 4),
                                  Text(
                                    item.volume!,
                                    style: GoogleFonts.inter(
                                      color: const Color(0xFF00796B),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 12),
                    ],

                    // Name row
                    Row(
                      children: [
                        // Veg indicator
                        Container(
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: item.isVeg ? Colors.green : Colors.red,
                              width: 1.5,
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Icon(
                            Icons.circle,
                            size: 10,
                            color: item.isVeg ? Colors.green : Colors.red,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            item.name,
                            style: GoogleFonts.poppins(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        if (item.tag != null)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: item.isBestseller
                                  ? AppColors.accent
                                  : AppColors.primary,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              item.tag!,
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                      ],
                    ).animate().fade(duration: 300.ms),

                    const SizedBox(height: 8),

                    Text(
                      item.description,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                        height: 1.5,
                      ),
                    ).animate().fade(delay: 100.ms),

                    // Extra trust features for Bisleri water
                    if (item.brand != null) ...[
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0FDF4),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0xFF00A389).withOpacity(0.2),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildPurityFeature(Icons.verified, '10-Step\nPurification'),
                            _buildPurityFeature(Icons.eco, 'Essential\nMinerals'),
                            _buildPurityFeature(Icons.sanitizer, 'Contactless\nSealed'),
                          ],
                        ),
                      ),
                    ],

                    const Divider(height: 32),

                    // Price
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Price',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: AppColors.textHint,
                              ),
                            ),
                            Text(
                              AppFormatters.formatPrice(_unitPrice),
                              style: GoogleFonts.poppins(
                                fontSize: 26,
                                fontWeight: FontWeight.w800,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),

                        // Quantity Selector
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: AppColors.primary, width: 1.5),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  if (_quantity > 1) {
                                    setState(() => _quantity--);
                                  }
                                },
                                child: const Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Icon(Icons.remove,
                                      color: AppColors.primary, size: 20),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: Text(
                                  '$_quantity',
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () => setState(() => _quantity++),
                                child: const Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Icon(Icons.add,
                                      color: AppColors.primary, size: 20),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    // Variants (if any)
                    if (item.hasVariants) ...[
                      const SizedBox(height: 20),
                      Text(
                        'Choose Size',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 10,
                        children: item.variants!.map((v) {
                          final isSelected =
                              _selectedVariant?.label == v.label;
                          return GestureDetector(
                            onTap: () =>
                                setState(() => _selectedVariant = v),
                            child: AnimatedContainer(
                              duration: 200.ms,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.primary
                                    : Colors.white,
                                border: Border.all(
                                  color: isSelected
                                      ? AppColors.primary
                                      : AppColors.divider,
                                  width: 1.5,
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                '${v.label} — ${AppFormatters.formatPrice(v.price)}',
                                style: GoogleFonts.inter(
                                  color: isSelected
                                      ? Colors.white
                                      : AppColors.textPrimary,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],

                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, -3),
            )
          ],
        ),
        child: Row(
          children: [
            // Total
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Total',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: AppColors.textHint,
                    ),
                  ),
                  Text(
                    AppFormatters.formatPrice(_unitPrice * _quantity),
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 16),

            // Add to Cart button
            Expanded(
              flex: 2,
              child: ElevatedButton.icon(
                onPressed: _addToCart,
                icon: const Icon(Icons.add_shopping_cart),
                label: Text(
                  'Add to Cart',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPurityFeature(IconData icon, String label) {
    return Column(
      children: [
        Icon(icon, color: const Color(0xFF00A389), size: 22),
        const SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF00796B),
            height: 1.2,
          ),
        ),
      ],
    );
  }
}
