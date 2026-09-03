class FoodVariant {
  final String label; // e.g., "250ml", "500ml", "1L"
  final double price;

  const FoodVariant({required this.label, required this.price});

  FoodVariant copyWith({String? label, double? price}) {
    return FoodVariant(
      label: label ?? this.label,
      price: price ?? this.price,
    );
  }

  Map<String, dynamic> toMap() => {'label': label, 'price': price};

  factory FoodVariant.fromMap(Map<String, dynamic> map) {
    return FoodVariant(
      label: map['label'] as String,
      price: (map['price'] as num).toDouble(),
    );
  }
}

class FoodItem {
  final String id;
  final String name;
  final String categoryId;
  final double price;
  final String description;
  final String imageUrl;
  final bool isAvailable;
  final bool isPopular;
  final bool isBestseller;
  final String? tag; // "NEW", "HOT", "BESTSELLER", "CHEF'S SPECIAL"
  final bool isVeg;
  final List<FoodVariant>? variants;
  final String? brand; // e.g. "Bisleri"
  final String? volume; // e.g. "250ml", "500ml", "1 Litre"

  const FoodItem({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.price,
    required this.description,
    required this.imageUrl,
    this.isAvailable = true,
    this.isPopular = false,
    this.isBestseller = false,
    this.tag,
    this.isVeg = true,
    this.variants,
    this.brand,
    this.volume,
  });

  bool get hasVariants => variants != null && variants!.isNotEmpty;

  FoodItem copyWith({
    String? id,
    String? name,
    String? categoryId,
    double? price,
    String? description,
    String? imageUrl,
    bool? isAvailable,
    bool? isPopular,
    bool? isBestseller,
    String? tag,
    bool? isVeg,
    List<FoodVariant>? variants,
    String? brand,
    String? volume,
  }) {
    return FoodItem(
      id: id ?? this.id,
      name: name ?? this.name,
      categoryId: categoryId ?? this.categoryId,
      price: price ?? this.price,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      isAvailable: isAvailable ?? this.isAvailable,
      isPopular: isPopular ?? this.isPopular,
      isBestseller: isBestseller ?? this.isBestseller,
      tag: tag ?? this.tag,
      isVeg: isVeg ?? this.isVeg,
      variants: variants ?? this.variants,
      brand: brand ?? this.brand,
      volume: volume ?? this.volume,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'categoryId': categoryId,
      'price': price,
      'description': description,
      'imageUrl': imageUrl,
      'isAvailable': isAvailable,
      'isPopular': isPopular,
      'isBestseller': isBestseller,
      'tag': tag,
      'isVeg': isVeg,
      'variants': variants?.map((v) => v.toMap()).toList(),
      'brand': brand,
      'volume': volume,
    };
  }

  factory FoodItem.fromMap(Map<String, dynamic> map) {
    return FoodItem(
      id: map['id'] as String,
      name: map['name'] as String,
      categoryId: map['categoryId'] as String,
      price: (map['price'] as num).toDouble(),
      description: map['description'] as String? ?? '',
      imageUrl: map['imageUrl'] as String? ?? '',
      isAvailable: map['isAvailable'] as bool? ?? true,
      isPopular: map['isPopular'] as bool? ?? false,
      isBestseller: map['isBestseller'] as bool? ?? false,
      tag: map['tag'] as String?,
      isVeg: map['isVeg'] as bool? ?? true,
      variants: (map['variants'] as List?)
          ?.map((v) => FoodVariant.fromMap(v as Map<String, dynamic>))
          .toList(),
      brand: map['brand'] as String?,
      volume: map['volume'] as String?,
    );
  }
}

class FoodCategory {
  final String id;
  final String name;
  final String emoji;
  final String imageUrl;
  final String description;
  final int sortOrder;
  final bool isActive;

  const FoodCategory({
    required this.id,
    required this.name,
    required this.emoji,
    required this.imageUrl,
    required this.description,
    this.sortOrder = 0,
    this.isActive = true,
  });

  FoodCategory copyWith({
    String? id,
    String? name,
    String? emoji,
    String? imageUrl,
    String? description,
    int? sortOrder,
    bool? isActive,
  }) {
    return FoodCategory(
      id: id ?? this.id,
      name: name ?? this.name,
      emoji: emoji ?? this.emoji,
      imageUrl: imageUrl ?? this.imageUrl,
      description: description ?? this.description,
      sortOrder: sortOrder ?? this.sortOrder,
      isActive: isActive ?? this.isActive,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'emoji': emoji,
      'imageUrl': imageUrl,
      'description': description,
      'sortOrder': sortOrder,
      'isActive': isActive,
    };
  }

  factory FoodCategory.fromMap(Map<String, dynamic> map) {
    return FoodCategory(
      id: map['id'] as String,
      name: map['name'] as String,
      emoji: map['emoji'] as String? ?? '🍽️',
      imageUrl: map['imageUrl'] as String? ?? '',
      description: map['description'] as String? ?? '',
      sortOrder: map['sortOrder'] as int? ?? 0,
      isActive: map['isActive'] as bool? ?? true,
    );
  }
}
