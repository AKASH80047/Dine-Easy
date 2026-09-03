import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/local/menu_data.dart';
import '../../../data/models/food_item.dart';
import '../../../providers/cart_provider.dart';
import '../../../providers/table_provider.dart';
import '../../../providers/menu_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  int _heroBannerIndex = 0;
  double? _selectedBisleriPrice;
  String? _selectedCategoryFilter;

  static const _heroBanners = [
    {
      'image':
          'https://images.unsplash.com/photo-1631452180519-c014fe946bc7?w=800&h=400&fit=crop',
      'title': 'Welcome To\nPandey Foods!',
      'subtitle': '100% Pure Veg, Fresh & Delicious',
      'categoryId': 'cat_main_course',
    },
    {
      'image':
          'https://images.unsplash.com/photo-1567188040759-fb8a883dc6d8?w=800&h=400&fit=crop',
      'title': 'Authentic\nMumbai Taste',
      'subtitle': 'Try our Vada Pav & Pav Bhaji',
      'categoryId': 'cat_snacks',
    },
    {
      'image':
          'https://images.unsplash.com/photo-1630383249896-424e482df921?w=800&h=400&fit=crop',
      'title': 'Fresh All Day\nBreakfast',
      'subtitle': 'Hot Maggi, Indori Poha & Upma',
      'categoryId': 'cat_breakfast',
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cart = ref.watch(cartProvider);
    final table = ref.watch(tableProvider);
    final menu = ref.watch(menuProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(124),
        child: _buildAppBar(cart.itemCount, table.tableDisplay),
      ),
      body: _searchQuery.isNotEmpty
          ? _buildSearchResults(menu)
          : _buildMainContent(menu, cart),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (cart.itemCount > 0) _buildFloatingCartBar(cart),
          _buildBottomBar(cart.itemCount),
        ],
      ),
    );
  }

  Widget _buildAppBar(int cartCount, String tableDisplay) {
    return AppBar(
      toolbarHeight: 60,
      backgroundColor: AppColors.primary,
      elevation: 0,
      title: Row(
        children: [
          const Text('🍔', style: TextStyle(fontSize: 22)),
          const SizedBox(width: 8),
          Text(
            'Pandey Foods',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
          ),
        ],
      ),
      actions: [
        // Table indicator
        Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.table_restaurant, color: Colors.white, size: 14),
              const SizedBox(width: 4),
              Text(
                tableDisplay,
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),

        // Cart button
        Stack(
          alignment: Alignment.center,
          children: [
            IconButton(
              onPressed: () => context.push('/cart'),
              icon: const Icon(Icons.shopping_cart_outlined,
                  color: Colors.white, size: 26),
            ),
            if (cartCount > 0)
              Positioned(
                top: 6,
                right: 6,
                child: Container(
                  width: 18,
                  height: 18,
                  decoration: const BoxDecoration(
                    color: AppColors.accent,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '$cartCount',
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(width: 8),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(64),
        child: Container(
          color: AppColors.primary,
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
          child: TextField(
            controller: _searchController,
            onChanged: (v) => setState(() => _searchQuery = v),
            style: GoogleFonts.inter(fontSize: 14),
            decoration: InputDecoration(
              hintText: 'Search Paneer, Dal, Paratha, Biryani, Bisleri...',
              hintStyle: GoogleFonts.inter(color: AppColors.textHint),
              prefixIcon: const Icon(Icons.search, color: AppColors.textHint),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, color: AppColors.textHint),
                      onPressed: () {
                        _searchController.clear();
                        setState(() => _searchQuery = '');
                      },
                    )
                  : null,
              filled: true,
              fillColor: Colors.white,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingCartBar(CartState cart) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.4),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: Colors.white24,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.shopping_bag,
                    color: Colors.white, size: 18),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${cart.itemCount} ${cart.itemCount == 1 ? 'ITEM' : 'ITEMS'} ADDED',
                    style: GoogleFonts.inter(
                      color: Colors.white70,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                  Text(
                    AppFormatters.formatPrice(cart.total),
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
          ),
          InkWell(
            onTap: () => context.push('/cart'),
            child: Row(
              children: [
                Text(
                  'View Cart',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.arrow_forward_ios,
                    color: Colors.white, size: 14),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryTabs(MenuState menu) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            _buildCategoryTabChip(null, '🍽️ All Items'),
            ...menu.categories.map((c) =>
                _buildCategoryTabChip(c.id, '${c.emoji} ${c.name}')),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryTabChip(String? categoryId, String label) {
    final isSelected = _selectedCategoryFilter == categoryId;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategoryFilter = categoryId;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : const Color(0xFFF5F6F8),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey.shade300,
            width: 1.2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            color: isSelected ? Colors.white : AppColors.textPrimary,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildFilteredCategoryView(
      MenuState menu, CartState cart, String categoryId) {
    final cat = menu.categories.firstWhere(
      (c) => c.id == categoryId,
      orElse: () => menu.categories.first,
    );
    final items = menu.getItemsByCategory(categoryId);

    return ListView(
      padding: EdgeInsets.zero,
      children: [
        // Category Chips Bar
        _buildCategoryTabs(menu),

        // Header for selected category
        Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                AppColors.primary,
                AppColors.primaryDark,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Text(cat.emoji, style: const TextStyle(fontSize: 36)),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cat.name,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${items.length} items available',
                      style: GoogleFonts.inter(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              TextButton.icon(
                onPressed: () => setState(() => _selectedCategoryFilter = null),
                icon: const Icon(Icons.close, color: Colors.white, size: 16),
                label: Text(
                  'Show All',
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
                style: TextButton.styleFrom(
                  backgroundColor: Colors.white24,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ],
          ),
        ),

        // If Mineral Water, show dedicated Bisleri section
        if (categoryId == 'cat_water')
          _buildBisleriSection(menu, cart)
        else
          // 2-column Grid of Food items in this category
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: items.length,
            itemBuilder: (ctx, i) {
              final item = items[i];
              final qty = cart.getItemQuantity(item.id);
              return _FoodItemCard(
                item: item,
                quantity: qty,
                onAdd: () => ref.read(cartProvider.notifier).addItem(item),
                onIncrease: () =>
                    ref.read(cartProvider.notifier).increaseQuantity(item.id),
                onDecrease: () =>
                    ref.read(cartProvider.notifier).decreaseQuantity(item.id),
                onTap: () => context.push('/product/${item.id}'),
              );
            },
          ),

        const SizedBox(height: 100),
      ],
    );
  }

  Widget _buildMainContent(MenuState menu, CartState cart) {
    if (_selectedCategoryFilter != null) {
      return _buildFilteredCategoryView(menu, cart, _selectedCategoryFilter!);
    }

    return ListView(
      padding: EdgeInsets.zero,
      children: [
        // Category Chips Bar
        _buildCategoryTabs(menu),

        // Hero Banner
        _buildHeroBanner(),

        // Categories
        _buildSectionHeader('Explore Categories', null),
        _buildCategoryGrid(menu),

        // Offers
        _buildSectionHeader('🎉 Today\'s Offers', null),
        _buildOffersSection(),

        // 💧 Bisleri Mineral Water Grocery Section
        _buildBisleriSection(menu, cart),

        // Popular Items
        _buildSectionHeader('⭐ Popular Items', 'See All'),
        _buildPopularItems(menu, cart),

        const SizedBox(height: 100),
      ],
    );
  }

  Widget _buildHeroBanner() {
    return SizedBox(
      height: 200,
      child: PageView.builder(
        itemCount: _heroBanners.length,
        onPageChanged: (i) => setState(() => _heroBannerIndex = i),
        itemBuilder: (ctx, i) {
          final banner = _heroBanners[i];
          return Stack(
            children: [
              // Image
              SizedBox.expand(
                child: CachedNetworkImage(
                  imageUrl: banner['image']!,
                  fit: BoxFit.cover,
                  errorWidget: (_, __, ___) => Container(
                    color: AppColors.primaryLight,
                  ),
                ),
              ),
              // Gradient overlay
              Container(
                decoration: const BoxDecoration(
                  gradient: AppColors.heroBannerGradient,
                ),
              ),
              // Text
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      banner['title']!,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      banner['subtitle']!,
                      style: GoogleFonts.inter(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 14),
                    ElevatedButton(
                      onPressed: () =>
                          context.push('/category/${banner['categoryId']}'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        textStyle: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600, fontSize: 13),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                      ),
                      child: const Text('Order Now'),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title, String? action) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          if (action != null)
            TextButton(
              onPressed: () {},
              child: Text(
                action,
                style: GoogleFonts.inter(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCategoryGrid(MenuState menu) {
    return SizedBox(
      height: 118,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: menu.categories.length,
        itemBuilder: (ctx, i) {
          final cat = menu.categories[i];
          final displayName = cat.name == 'Rice and Biryani'
              ? 'Rice & Biryani'
              : cat.name == 'All Day Breakfast'
                  ? 'Breakfast'
                  : cat.name;
          return GestureDetector(
            onTap: () => context.push('/category/${cat.id}'),
            child: Container(
              width: 92,
              margin: const EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  )
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                      imageUrl: cat.imageUrl,
                      width: 52,
                      height: 52,
                      fit: BoxFit.cover,
                      errorWidget: (_, __, ___) => Container(
                        width: 52,
                        height: 52,
                        color: AppColors.primarySurface,
                        child: Center(
                          child: Text(cat.emoji,
                              style: const TextStyle(fontSize: 26)),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Text(
                      displayName,
                      style: GoogleFonts.inter(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                        height: 1.1,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            )
                .animate()
                .scale(
                  delay: Duration(milliseconds: i * 80),
                  duration: 300.ms,
                  curve: Curves.easeOut,
                )
                .fade(delay: Duration(milliseconds: i * 80)),
          );
        },
      ),
    );
  }

  Widget _buildOffersSection() {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: MenuData.offers.length,
        itemBuilder: (ctx, i) {
          final offer = MenuData.offers[i];
          return Container(
            width: 260,
            margin: const EdgeInsets.symmetric(horizontal: 6),
            decoration: BoxDecoration(
              color: Color(offer['color'] as int),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Color(offer['color'] as int).withOpacity(0.35),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Text(
                    offer['emoji'] as String,
                    style: const TextStyle(fontSize: 36),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          offer['title'] as String,
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                          maxLines: 2,
                        ),
                        Text(
                          offer['description'] as String,
                          style: GoogleFonts.inter(
                            color: Colors.white.withOpacity(0.85),
                            fontSize: 11,
                          ),
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBisleriPriceFilter(double? price, String label) {
    final isSelected = _selectedBisleriPrice == price;
    return GestureDetector(
      onTap: () => setState(() => _selectedBisleriPrice = price),
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF00A389) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFF00A389) : Colors.grey.shade300,
            width: 1.2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF00A389).withOpacity(0.25),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  )
                ]
              : null,
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            color: isSelected ? Colors.white : AppColors.textPrimary,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildBisleriSection(MenuState menu, CartState cart) {
    final allWater = menu.getItemsByCategory('cat_water');
    final displayWater = _selectedBisleriPrice != null
        ? allWater.where((item) => item.price == _selectedBisleriPrice).toList()
        : allWater;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title & Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: const Color(0xFF00A389).withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.water_drop,
                    color: Color(0xFF00A389),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Bisleri Mineral Water',
                            style: GoogleFonts.poppins(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFF00A389),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'PURE',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '100% Safe • Minerals Added • Sealed Purity',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: AppColors.textHint,
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () => context.push('/category/cat_water'),
                  child: Text(
                    'View All',
                    style: GoogleFonts.inter(
                      color: const Color(0xFF00A389),
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // Price Category Switcher Pills (₹10, ₹20, ₹30)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _buildBisleriPriceFilter(null, 'All Bottles'),
                _buildBisleriPriceFilter(10, '₹10 Bottle (250ml)'),
                _buildBisleriPriceFilter(20, '₹20 Bottle (500ml)'),
                _buildBisleriPriceFilter(30, '₹30 Bottle (1 Litre)'),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Horizontal Grocery Delivery Cards
          SizedBox(
            height: 235,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: displayWater.length,
              itemBuilder: (ctx, i) {
                final item = displayWater[i];
                final qty = cart.getItemQuantity(item.id);
                return _BisleriGroceryCard(
                  item: item,
                  quantity: qty,
                  onAdd: () => ref.read(cartProvider.notifier).addItem(item),
                  onTap: () => context.push('/product/${item.id}'),
                  onIncrease: () =>
                      ref.read(cartProvider.notifier).increaseQuantity(item.id),
                  onDecrease: () =>
                      ref.read(cartProvider.notifier).decreaseQuantity(item.id),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPopularItems(MenuState menu, CartState cart) {
    final popular = menu.popularItems.take(6).toList();
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: popular.length,
      itemBuilder: (ctx, i) {
        final item = popular[i];
        final qty = cart.getItemQuantity(item.id);
        return _FoodItemCard(
          item: item,
          quantity: qty,
          onAdd: () => ref.read(cartProvider.notifier).addItem(item),
          onIncrease: () =>
              ref.read(cartProvider.notifier).increaseQuantity(item.id),
          onDecrease: () =>
              ref.read(cartProvider.notifier).decreaseQuantity(item.id),
          onTap: () => context.push('/product/${item.id}'),
        ).animate().fade(
              delay: Duration(milliseconds: i * 80),
              duration: 300.ms,
            );
      },
    );
  }

  Widget _buildSearchResults(MenuState menu) {
    final results = menu.search(_searchQuery);
    if (results.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('🔍', style: TextStyle(fontSize: 48)),
            const SizedBox(height: 12),
            Text(
              'No results for "$_searchQuery"',
              style: GoogleFonts.inter(
                color: AppColors.textSecondary,
                fontSize: 15,
              ),
            ),
          ],
        ),
      );
    }
    final cart = ref.watch(cartProvider);
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: results.length,
      itemBuilder: (ctx, i) {
        final item = results[i];
        final qty = cart.getItemQuantity(item.id);
        return _FoodItemCard(
          item: item,
          quantity: qty,
          onAdd: () => ref.read(cartProvider.notifier).addItem(item),
          onIncrease: () =>
              ref.read(cartProvider.notifier).increaseQuantity(item.id),
          onDecrease: () =>
              ref.read(cartProvider.notifier).decreaseQuantity(item.id),
          onTap: () => context.push('/product/${item.id}'),
        );
      },
    );
  }

  void _showCategoriesBottomSheet(BuildContext context) {
    final menu = ref.read(menuProvider);
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'All Categories (9)',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Flexible(
                child: GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 0.9,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: menu.categories.length,
                  itemBuilder: (cCtx, i) {
                    final cat = menu.categories[i];
                    return GestureDetector(
                      onTap: () {
                        Navigator.pop(ctx);
                        setState(() => _selectedCategoryFilter = cat.id);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF9FAFB),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(cat.emoji,
                                style: const TextStyle(fontSize: 30)),
                            const SizedBox(height: 6),
                            Text(
                              cat.name,
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBottomBar(int cartCount) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
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
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _NavItem(
              icon: Icons.home_rounded,
              label: 'Home',
              isActive: _selectedCategoryFilter == null && _searchQuery.isEmpty,
              onTap: () {
                setState(() {
                  _selectedCategoryFilter = null;
                  _searchController.clear();
                  _searchQuery = '';
                });
              },
            ),
            _NavItem(
              icon: Icons.grid_view_rounded,
              label: 'Categories',
              isActive: _selectedCategoryFilter != null,
              onTap: () => _showCategoriesBottomSheet(context),
            ),
            _NavItem(
              icon: Icons.shopping_bag_outlined,
              label: 'Cart',
              badge: cartCount > 0 ? '$cartCount' : null,
              onTap: () => context.push('/cart'),
            ),
            _NavItem(
              icon: Icons.receipt_long_outlined,
              label: 'Orders',
              onTap: () => context.push('/cart'),
            ),
            _NavItem(
              icon: Icons.table_restaurant_outlined,
              label: 'Table',
              onTap: () => context.push('/table-select'),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Food Item Card Widget (with touch-friendly stepper)
// ─────────────────────────────────────────────────────────────────────────────
class _FoodItemCard extends StatelessWidget {
  final dynamic item;
  final int quantity;
  final VoidCallback onAdd;
  final VoidCallback onTap;
  final VoidCallback? onIncrease;
  final VoidCallback? onDecrease;

  const _FoodItemCard({
    required this.item,
    required this.quantity,
    required this.onAdd,
    required this.onTap,
    this.onIncrease,
    this.onDecrease,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.07),
              blurRadius: 10,
              offset: const Offset(0, 3),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(16)),
                    child: Container(
                      color: item.brand != null
                          ? const Color(0xFFF0FDF4)
                          : AppColors.primarySurface,
                      padding: item.brand != null
                          ? const EdgeInsets.all(8)
                          : EdgeInsets.zero,
                      child: CachedNetworkImage(
                        imageUrl: item.imageUrl,
                        width: double.infinity,
                        height: double.infinity,
                        fit: item.brand != null
                            ? BoxFit.contain
                            : BoxFit.cover,
                        errorWidget: (_, __, ___) => Container(
                          color: AppColors.primarySurface,
                          child: Center(
                            child: Icon(
                              item.brand != null
                                  ? Icons.water_drop
                                  : Icons.fastfood,
                              color: item.brand != null
                                  ? const Color(0xFF00A389)
                                  : AppColors.primary,
                              size: 40,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Brand & Volume badge OR Veg indicator
                  if (item.brand != null)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFF00A389),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          item.brand!.toUpperCase(),
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 8,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    )
                  else
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: item.isVeg ? Colors.green : Colors.red,
                            width: 1.5,
                          ),
                        ),
                        child: Icon(
                          Icons.circle,
                          color: item.isVeg ? Colors.green : Colors.red,
                          size: 8,
                        ),
                      ),
                    ),

                  // Volume or Tag
                  if (item.volume != null)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 4,
                            )
                          ],
                        ),
                        child: Text(
                          item.volume!,
                          style: GoogleFonts.inter(
                            color: const Color(0xFF00897B),
                            fontSize: 8,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    )
                  else if (item.tag != null)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: item.tag == 'BESTSELLER'
                              ? AppColors.accent
                              : item.tag == 'NEW'
                                  ? AppColors.primaryLight
                                  : Colors.red,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          item.tag!,
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 8,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Info
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppFormatters.formatPrice(item.price),
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                        quantity == 0
                            ? GestureDetector(
                                onTap: onAdd,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    '+ ADD',
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              )
                            : Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: AppColors.primary, width: 1.2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    InkWell(
                                      onTap: onDecrease,
                                      child: const Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 4, vertical: 3),
                                        child: Icon(Icons.remove,
                                            size: 14,
                                            color: AppColors.primary),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 4),
                                      child: Text(
                                        '$quantity',
                                        style: GoogleFonts.poppins(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: onIncrease ?? onAdd,
                                      child: const Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 4, vertical: 3),
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
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Bottom Nav Item
// ─────────────────────────────────────────────────────────────────────────────
class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final String? badge;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    this.isActive = false,
    this.badge,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(
                  icon,
                  color: isActive ? AppColors.primary : AppColors.textHint,
                  size: 24,
                ),
                if (badge != null)
                  Positioned(
                    top: -6,
                    right: -8,
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: const BoxDecoration(
                        color: AppColors.accent,
                        shape: BoxShape.circle,
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
                  ),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 10,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                color: isActive ? AppColors.primary : AppColors.textHint,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Bisleri Grocery Delivery Card Widget
// ─────────────────────────────────────────────────────────────────────────────
class _BisleriGroceryCard extends StatelessWidget {
  final FoodItem item;
  final int quantity;
  final VoidCallback onAdd;
  final VoidCallback onTap;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;

  const _BisleriGroceryCard({
    required this.item,
    required this.quantity,
    required this.onAdd,
    required this.onTap,
    required this.onIncrease,
    required this.onDecrease,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 155,
        margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFF00A389).withOpacity(0.25),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Image Box with Aqua Background & Badges
            Stack(
              children: [
                Container(
                  height: 115,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF0FDF4),
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(15)),
                  ),
                  padding: const EdgeInsets.all(10),
                  child: CachedNetworkImage(
                    imageUrl: item.imageUrl,
                    fit: BoxFit.contain,
                    errorWidget: (_, __, ___) => const Center(
                      child: Icon(Icons.water_drop,
                          color: Color(0xFF00A389), size: 40),
                    ),
                  ),
                ),
                // Brand Badge
                Positioned(
                  top: 6,
                  left: 6,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFF00A389),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      item.brand?.toUpperCase() ?? 'BISLERI',
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
                // Volume Badge
                if (item.volume != null)
                  Positioned(
                    top: 6,
                    right: 6,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 4,
                          )
                        ],
                      ),
                      child: Text(
                        item.volume!,
                        style: GoogleFonts.inter(
                          color: const Color(0xFF00897B),
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
              ],
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    'Added Minerals • Pure',
                    style: GoogleFonts.inter(
                      fontSize: 9,
                      color: AppColors.textHint,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppFormatters.formatPrice(item.price),
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF00796B),
                        ),
                      ),
                      quantity == 0
                          ? GestureDetector(
                              onTap: onAdd,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF00A389),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  '+ ADD',
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            )
                          : Container(
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: const Color(0xFF00A389)),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  InkWell(
                                    onTap: onDecrease,
                                    child: const Padding(
                                      padding: EdgeInsets.all(3),
                                      child: Icon(Icons.remove,
                                          size: 13, color: Color(0xFF00A389)),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 3),
                                    child: Text(
                                      '$quantity',
                                      style: GoogleFonts.poppins(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xFF00A389),
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: onIncrease,
                                    child: const Padding(
                                      padding: EdgeInsets.all(3),
                                      child: Icon(Icons.add,
                                          size: 13, color: Color(0xFF00A389)),
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
          ],
        ),
      ),
    );
  }
}

