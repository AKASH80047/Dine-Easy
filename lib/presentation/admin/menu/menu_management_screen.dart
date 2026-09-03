import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:uuid/uuid.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/models/food_item.dart';
import '../../../providers/menu_provider.dart';

class MenuManagementScreen extends ConsumerStatefulWidget {
  const MenuManagementScreen({super.key});

  @override
  ConsumerState<MenuManagementScreen> createState() =>
      _MenuManagementScreenState();
}

class _MenuManagementScreenState
    extends ConsumerState<MenuManagementScreen> {
  String? _selectedCategoryId;

  @override
  Widget build(BuildContext context) {
    final menu = ref.watch(menuProvider);
    final categories = menu.categories;
    final selectedCat = _selectedCategoryId ?? categories.first.id;
    final items = menu.getItemsByCategory(selectedCat);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Menu Management',
            style: GoogleFonts.poppins(
                color: Colors.white, fontWeight: FontWeight.w700)),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () => _showAddItemDialog(context, ref, selectedCat),
            icon: const Icon(Icons.add, color: Colors.white),
            tooltip: 'Add Item',
          ),
        ],
      ),
      body: Column(
        children: [
          // Category tabs
          Container(
            color: Colors.white,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                  horizontal: 12, vertical: 10),
              child: Row(
                children: categories.map((cat) {
                  final isSelected = cat.id == selectedCat;
                  return GestureDetector(
                    onTap: () =>
                        setState(() => _selectedCategoryId = cat.id),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.only(right: 10),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.background,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.divider,
                        ),
                      ),
                      child: Text(
                        '${cat.emoji} ${cat.name.split(' ').first}',
                        style: GoogleFonts.inter(
                          color: isSelected
                              ? Colors.white
                              : AppColors.textSecondary,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          // Items list
          Expanded(
            child: items.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('🍽️', style: TextStyle(fontSize: 48)),
                        const SizedBox(height: 12),
                        Text('No items in this category',
                            style: GoogleFonts.inter(
                                color: AppColors.textHint)),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () => _showAddItemDialog(
                              context, ref, selectedCat),
                          child: const Text('Add Item'),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: items.length,
                    itemBuilder: (ctx, i) {
                      final item = items[i];
                      return _AdminMenuCard(
                        item: item,
                        onEdit: () =>
                            _showEditItemDialog(context, ref, item),
                        onToggle: () {
                          ref.read(menuProvider.notifier).updateItem(
                                item.copyWith(
                                    isAvailable: !item.isAvailable),
                              );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _showAddItemDialog(
      BuildContext context, WidgetRef ref, String categoryId) {
    _showItemDialog(context, ref, null, categoryId);
  }

  void _showEditItemDialog(
      BuildContext context, WidgetRef ref, FoodItem item) {
    _showItemDialog(context, ref, item, item.categoryId);
  }

  void _showItemDialog(BuildContext context, WidgetRef ref,
      FoodItem? existing, String categoryId) {
    final nameCtrl =
        TextEditingController(text: existing?.name ?? '');
    final priceCtrl = TextEditingController(
        text: existing?.price.toString() ?? '');
    final descCtrl =
        TextEditingController(text: existing?.description ?? '');
    final imageCtrl =
        TextEditingController(text: existing?.imageUrl ?? '');
    bool isVeg = existing?.isVeg ?? true;
    bool isPopular = existing?.isPopular ?? false;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          title: Text(
            existing == null ? 'Add Food Item' : 'Edit Item',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w700),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(
                      labelText: 'Item Name *'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: priceCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Price (₹) *',
                    prefixText: '₹ ',
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: descCtrl,
                  maxLines: 2,
                  decoration:
                      const InputDecoration(labelText: 'Description'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: imageCtrl,
                  decoration:
                      const InputDecoration(labelText: 'Image URL'),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Text('Veg'),
                    Switch.adaptive(
                      value: isVeg,
                      onChanged: (v) => setState(() => isVeg = v),
                      activeColor: Colors.green,
                    ),
                    const Spacer(),
                    const Text('Popular'),
                    Switch.adaptive(
                      value: isPopular,
                      onChanged: (v) =>
                          setState(() => isPopular = v),
                      activeColor: AppColors.primary,
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                final name = nameCtrl.text.trim();
                final price = double.tryParse(priceCtrl.text.trim());
                if (name.isEmpty || price == null) return;

                if (existing == null) {
                  ref.read(menuProvider.notifier).addItem(
                        FoodItem(
                          id: const Uuid().v4(),
                          name: name,
                          categoryId: categoryId,
                          price: price,
                          description: descCtrl.text.trim(),
                          imageUrl: imageCtrl.text.trim(),
                          isVeg: isVeg,
                          isPopular: isPopular,
                        ),
                      );
                } else {
                  ref.read(menuProvider.notifier).updateItem(
                        existing.copyWith(
                          name: name,
                          price: price,
                          description: descCtrl.text.trim(),
                          imageUrl: imageCtrl.text.trim(),
                          isVeg: isVeg,
                          isPopular: isPopular,
                        ),
                      );
                }
                Navigator.pop(ctx);
              },
              child: Text(existing == null ? 'Add' : 'Save'),
            ),
          ],
        ),
      ),
    );
  }
}

class _AdminMenuCard extends StatelessWidget {
  final FoodItem item;
  final VoidCallback onEdit;
  final VoidCallback onToggle;

  const _AdminMenuCard({
    required this.item,
    required this.onEdit,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05), blurRadius: 6)
        ],
        border: item.isAvailable
            ? null
            : Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          // Image
          ClipRRect(
            borderRadius:
                const BorderRadius.horizontal(left: Radius.circular(14)),
            child: Opacity(
              opacity: item.isAvailable ? 1 : 0.5,
              child: CachedNetworkImage(
                imageUrl: item.imageUrl,
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
          ),

          // Info
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: item.isAvailable
                          ? AppColors.textPrimary
                          : AppColors.textHint,
                    ),
                  ),
                  Text(
                    AppFormatters.formatPrice(item.price),
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Actions
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Switch.adaptive(
                value: item.isAvailable,
                onChanged: (_) => onToggle(),
                activeColor: AppColors.primary,
              ),
              IconButton(
                onPressed: onEdit,
                icon: const Icon(Icons.edit_outlined,
                    color: AppColors.primary, size: 20),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
