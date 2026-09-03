import '../models/food_item.dart';
import '../models/restaurant_table.dart';

class MenuData {
  // ────────────────────────────────
  //  CATEGORIES (9 Main Categories)
  // ────────────────────────────────
  static final List<FoodCategory> categories = [
    const FoodCategory(
      id: 'cat_main_course',
      name: 'Main Course',
      emoji: '🍛',
      imageUrl:
          'https://images.weserv.nl/?url=https://upload.wikimedia.org/wikipedia/commons/thumb/6/6f/Paneer_Butter_Masala_2.jpg/960px-Paneer_Butter_Masala_2.jpg&w=500&h=400&fit=cover',
      description: 'Rich gravies, paneer & seasonal curries',
      sortOrder: 0,
    ),
    const FoodCategory(
      id: 'cat_breads',
      name: 'Breads',
      emoji: '🫓',
      imageUrl:
          'https://images.weserv.nl/?url=https://upload.wikimedia.org/wikipedia/commons/thumb/2/29/Butter_Naan_2.jpg/960px-Butter_Naan_2.jpg&w=500&h=400&fit=cover',
      description: 'Tandoori, Naan & Fresh Tawa Rotis',
      sortOrder: 1,
    ),
    const FoodCategory(
      id: 'cat_paratha',
      name: 'Paratha',
      emoji: '🥞',
      imageUrl:
          'https://images.weserv.nl/?url=https://upload.wikimedia.org/wikipedia/commons/thumb/e/eb/%22Amazing_Aloo_Paratha_and_Lovely_Lassi%22.jpg/960px-%22Amazing_Aloo_Paratha_and_Lovely_Lassi%22.jpg&w=500&h=400&fit=cover',
      description: 'Stuffed North Indian special parathas',
      sortOrder: 2,
    ),
    const FoodCategory(
      id: 'cat_rice_biryani',
      name: 'Rice and Biryani',
      emoji: '🍚',
      imageUrl:
          'https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?w=500&h=400&fit=crop',
      description: 'Aromatic Dum Biryanis & Basmati Pulao',
      sortOrder: 3,
    ),
    const FoodCategory(
      id: 'cat_snacks',
      name: 'Snacks',
      emoji: '🥟',
      imageUrl:
          'https://images.weserv.nl/?url=https://upload.wikimedia.org/wikipedia/commons/thumb/c/c6/Butter_kulcha_-_paneer_chana.jpg/960px-Butter_kulcha_-_paneer_chana.jpg&w=500&h=400&fit=cover',
      description: 'Chole Kulcha, Vada Pav, Peanuts & more',
      sortOrder: 4,
    ),
    const FoodCategory(
      id: 'cat_accompaniments',
      name: 'Accompaniments',
      emoji: '🥗',
      imageUrl:
          'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=500&h=400&fit=crop',
      description: 'Fresh salads, chutneys, papad & sides',
      sortOrder: 5,
    ),
    const FoodCategory(
      id: 'cat_drinks',
      name: 'Drinks',
      emoji: '☕',
      imageUrl:
          'https://images.unsplash.com/photo-1576092768241-dec231879fc3?w=500&h=400&fit=crop',
      description: 'Tea, Coffee, Lassi, Chaas & Refreshers',
      sortOrder: 6,
    ),
    const FoodCategory(
      id: 'cat_breakfast',
      name: 'All Day Breakfast',
      emoji: '🍳',
      imageUrl:
          'https://images.unsplash.com/photo-1612927601601-6638404737ce?w=500&h=400&fit=crop',
      description: 'Maggi specials, Indori Poha & Upma',
      sortOrder: 7,
    ),
    const FoodCategory(
      id: 'cat_water',
      name: 'Mineral Water',
      emoji: '💧',
      imageUrl:
          'https://www.bisleri.com/on/demandware.static/-/Sites-Bis-Catalog/default/dw7c47d214/Product%20Images_Desktop/Bisleri/Bisleri1Litre/PDP/Bisleri_Ecom_Web_1L_01.png',
      description: 'Bisleri 100% pure packaged drinking water',
      sortOrder: 8,
    ),
  ];

  // ────────────────────────────────
  //  1. MAIN COURSE
  // ────────────────────────────────
  static final List<FoodItem> _mainCourseItems = [
    const FoodItem(
      id: 'mc_001',
      categoryId: 'cat_main_course',
      name: 'Paneer Butter Masala',
      price: 160,
      description:
          'Cottage cheese cubes simmered in rich velvety tomato-butter gravy with aromatic spices.',
      imageUrl:
          'https://images.weserv.nl/?url=https://upload.wikimedia.org/wikipedia/commons/thumb/6/6f/Paneer_Butter_Masala_2.jpg/960px-Paneer_Butter_Masala_2.jpg&w=500&h=400&fit=cover',
      isPopular: true,
      isBestseller: true,
      tag: 'BESTSELLER',
      isVeg: true,
    ),
    const FoodItem(
      id: 'mc_002',
      categoryId: 'cat_main_course',
      name: 'Dal Makhani',
      price: 140,
      description:
          'Slow-cooked black lentils and kidney beans enriched with desi butter and fresh cream.',
      imageUrl:
          'https://images.weserv.nl/?url=https://upload.wikimedia.org/wikipedia/commons/thumb/3/3e/Dal_Makhani..JPG/960px-Dal_Makhani..JPG&w=500&h=400&fit=cover',
      isPopular: true,
      isBestseller: true,
      tag: 'POPULAR',
      isVeg: true,
    ),
    const FoodItem(
      id: 'mc_003',
      categoryId: 'cat_main_course',
      name: 'Shahi Paneer',
      price: 170,
      description:
          'Royal preparation of cottage cheese in a thick gravy of cream, tomatoes and mild spices.',
      imageUrl:
          'https://images.weserv.nl/?url=https://upload.wikimedia.org/wikipedia/commons/thumb/6/68/Naan_shahi_paneer.jpg/960px-Naan_shahi_paneer.jpg&w=500&h=400&fit=cover',
      isPopular: true,
      tag: 'CHEF\'S SPECIAL',
      isVeg: true,
    ),
    const FoodItem(
      id: 'mc_004',
      categoryId: 'cat_main_course',
      name: 'Kadai Paneer',
      price: 165,
      description:
          'Paneer cooked with crunchy bell peppers, onion and freshly ground kadai spices.',
      imageUrl:
          'https://images.weserv.nl/?url=https://upload.wikimedia.org/wikipedia/commons/a/aa/Kadai_Paneer.JPG&w=500&h=400&fit=cover',
      isPopular: false,
      tag: 'SPICY',
      isVeg: true,
    ),
    const FoodItem(
      id: 'mc_005',
      categoryId: 'cat_main_course',
      name: 'Mix Veg',
      price: 130,
      description:
          'Seasonal fresh vegetables cooked in homestyle spiced onion-tomato gravy.',
      imageUrl:
          'https://images.weserv.nl/?url=https://upload.wikimedia.org/wikipedia/commons/b/bf/South_Indian_Mixed_Vegetable_Curry.JPG&w=500&h=400&fit=cover',
      isVeg: true,
    ),
    const FoodItem(
      id: 'mc_006',
      categoryId: 'cat_main_course',
      name: 'Malai Kofta',
      price: 175,
      description:
          'Melt-in-mouth paneer dumplings stuffed with dry fruits in a luscious white cashew gravy.',
      imageUrl:
          'https://images.weserv.nl/?url=https://upload.wikimedia.org/wikipedia/commons/thumb/f/fa/Malai_Kofta.jpg/960px-Malai_Kofta.jpg&w=500&h=400&fit=cover',
      isPopular: true,
      tag: 'RECOMMENDED',
      isVeg: true,
    ),
    const FoodItem(
      id: 'mc_007',
      categoryId: 'cat_main_course',
      name: 'Dal Tadka',
      price: 120,
      description:
          'Yellow arhar lentils tempered with ghee, cumin seeds, garlic, onion and red chillies.',
      imageUrl:
          'https://images.weserv.nl/?url=https://upload.wikimedia.org/wikipedia/commons/thumb/f/f0/Dal_Tadka-Delhi.jpg/960px-Dal_Tadka-Delhi.jpg&w=500&h=400&fit=cover',
      isPopular: true,
      isVeg: true,
    ),
    const FoodItem(
      id: 'mc_008',
      categoryId: 'cat_main_course',
      name: 'Chana Masala',
      price: 130,
      description:
          'Authentic Punjabi style spiced chickpeas simmered in tangy onion-tomato gravy.',
      imageUrl:
          'https://images.weserv.nl/?url=https://upload.wikimedia.org/wikipedia/commons/thumb/c/c7/Chana_Ko_Tarkari.jpg/960px-Chana_Ko_Tarkari.jpg&w=500&h=400&fit=cover',
      isVeg: true,
    ),
    const FoodItem(
      id: 'mc_009',
      categoryId: 'cat_main_course',
      name: 'Kaju Curry',
      price: 190,
      description:
          'Roasted whole cashews cooked in an indulgent rich cashew-butter sauce.',
      imageUrl:
          'https://images.weserv.nl/?url=https://upload.wikimedia.org/wikipedia/commons/thumb/8/8e/Cashew_Curry.JPG/960px-Cashew_Curry.JPG&w=500&h=400&fit=cover',
      tag: 'PREMIUM',
      isVeg: true,
    ),
    const FoodItem(
      id: 'mc_010',
      categoryId: 'cat_main_course',
      name: 'Dum Aloo',
      price: 135,
      description:
          'Baby potatoes slow cooked in rich yoghurt and tomato based Kashmiri gravy.',
      imageUrl:
          'https://images.weserv.nl/?url=https://upload.wikimedia.org/wikipedia/commons/thumb/2/2d/Dum_Aloo_-_Indian_Sabji.JPG/960px-Dum_Aloo_-_Indian_Sabji.JPG&w=500&h=400&fit=cover',
      isVeg: true,
    ),
    const FoodItem(
      id: 'mc_011',
      categoryId: 'cat_main_course',
      name: 'Soya Chaap Masala',
      price: 150,
      description:
          'Tender soya chaap roasted and cooked in rich Punjabi spiced masala gravy.',
      imageUrl:
          'https://images.weserv.nl/?url=https://upload.wikimedia.org/wikipedia/commons/thumb/d/d7/Soya_Chaap_with_curry.jpg/960px-Soya_Chaap_with_curry.jpg&w=500&h=400&fit=cover',
      isPopular: true,
      tag: 'HOT',
      isVeg: true,
    ),
    const FoodItem(
      id: 'mc_012',
      categoryId: 'cat_main_course',
      name: 'Matar Paneer',
      price: 155,
      description:
          'Fresh green peas and soft paneer cubes in homestyle North Indian masala gravy.',
      imageUrl:
          'https://images.weserv.nl/?url=https://upload.wikimedia.org/wikipedia/commons/thumb/d/d0/Matar-Paneer.JPG/960px-Matar-Paneer.JPG&w=500&h=400&fit=cover',
      isVeg: true,
    ),
  ];

  // ────────────────────────────────
  //  2. BREADS
  // ────────────────────────────────
  static final List<FoodItem> _breadItems = [
    const FoodItem(
      id: 'br_001',
      categoryId: 'cat_breads',
      name: 'Tandoori Roti',
      price: 15,
      description: 'Traditional whole wheat flatbread baked crisp in clay tandoor.',
      imageUrl:
          'https://images.weserv.nl/?url=https://upload.wikimedia.org/wikipedia/commons/thumb/6/6b/Baked_rotis_on_towel_by_roti_maker.jpg/800px-Baked_rotis_on_towel_by_roti_maker.jpg&w=500&h=400&fit=cover',
      isVeg: true,
    ),
    const FoodItem(
      id: 'br_002',
      categoryId: 'cat_breads',
      name: 'Butter Tandoori Roti',
      price: 20,
      description: 'Crispy tandoori roti brushed with generous desi butter.',
      imageUrl:
          'https://images.weserv.nl/?url=https://upload.wikimedia.org/wikipedia/commons/thumb/7/7f/2012_%27Z%C3%BCrcher_Theater_Spektakel%27_-_Chapati_2012-08-25_17-46-31_%28P7000%29.JPG/960px-2012_%27Z%C3%BCrcher_Theater_Spektakel%27_-_Chapati_2012-08-25_17-46-31_%28P7000%29.JPG&w=500&h=400&fit=cover',
      isPopular: true,
      isVeg: true,
    ),
    const FoodItem(
      id: 'br_003',
      categoryId: 'cat_breads',
      name: 'Plain Naan',
      price: 35,
      description: 'Soft and pillowy leavened flatbread baked in traditional tandoor.',
      imageUrl:
          'https://images.weserv.nl/?url=https://upload.wikimedia.org/wikipedia/commons/thumb/c/c5/Garlic_Naan_and_Plain_Naan.jpg/960px-Garlic_Naan_and_Plain_Naan.jpg&w=500&h=400&fit=cover',
      isVeg: true,
    ),
    const FoodItem(
      id: 'br_004',
      categoryId: 'cat_breads',
      name: 'Butter Naan',
      price: 45,
      description: 'Classic soft naan topped with rich golden melted butter.',
      imageUrl:
          'https://images.weserv.nl/?url=https://upload.wikimedia.org/wikipedia/commons/thumb/2/29/Butter_Naan_2.jpg/960px-Butter_Naan_2.jpg&w=500&h=400&fit=cover',
      isPopular: true,
      isBestseller: true,
      tag: 'BESTSELLER',
      isVeg: true,
    ),
    const FoodItem(
      id: 'br_005',
      categoryId: 'cat_breads',
      name: 'Garlic Naan',
      price: 55,
      description: 'Fluffy naan infused with minced garlic and fresh coriander leaves.',
      imageUrl:
          'https://images.weserv.nl/?url=https://upload.wikimedia.org/wikipedia/commons/thumb/0/0a/Cheese_naan_and_Garlic_naan.jpg/960px-Cheese_naan_and_Garlic_naan.jpg&w=500&h=400&fit=cover',
      isPopular: true,
      tag: 'POPULAR',
      isVeg: true,
    ),
    const FoodItem(
      id: 'br_006',
      categoryId: 'cat_breads',
      name: 'Paneer Naan',
      price: 65,
      description: 'Leavened bread stuffed with spiced crumbled cottage cheese.',
      imageUrl:
          'https://images.weserv.nl/?url=https://upload.wikimedia.org/wikipedia/commons/thumb/c/c6/Butter_kulcha_-_paneer_chana.jpg/960px-Butter_kulcha_-_paneer_chana.jpg&w=500&h=400&fit=cover',
      tag: 'STUFFED',
      isVeg: true,
    ),
    const FoodItem(
      id: 'br_007',
      categoryId: 'cat_breads',
      name: 'Mirchi Naan',
      price: 50,
      description: 'Spicy tandoori naan topped with sliced green chillies and spices.',
      imageUrl:
          'https://images.weserv.nl/?url=https://upload.wikimedia.org/wikipedia/commons/thumb/a/a5/Chilli_Cheese_Naan_-_The_Druid_Garden%2C_Bangalore_-_Karnataka_-_PXL5502.jpg/960px-Chilli_Cheese_Naan_-_The_Druid_Garden%2C_Bangalore_-_Karnataka_-_PXL5502.jpg&w=500&h=400&fit=cover',
      tag: 'SPICY',
      isVeg: true,
    ),
    const FoodItem(
      id: 'br_008',
      categoryId: 'cat_breads',
      name: 'Missi Roti',
      price: 30,
      description: 'Gram flour and whole wheat flatbread flavored with ajwain and onion.',
      imageUrl:
          'https://images.weserv.nl/?url=https://upload.wikimedia.org/wikipedia/commons/5/53/Dough_for_missi_roti_%2827705533905%29.jpg&w=500&h=400&fit=cover',
      isVeg: true,
    ),
    const FoodItem(
      id: 'br_009',
      categoryId: 'cat_breads',
      name: 'Laccha Paratha',
      price: 40,
      description: 'Multi-layered flaky whole wheat bread cooked crisp in tandoor.',
      imageUrl:
          'https://images.weserv.nl/?url=https://upload.wikimedia.org/wikipedia/commons/thumb/7/70/Laccha_Paratha.JPG/960px-Laccha_Paratha.JPG&w=500&h=400&fit=cover',
      isPopular: true,
      isVeg: true,
    ),
    const FoodItem(
      id: 'br_010',
      categoryId: 'cat_breads',
      name: 'Tawa Roti',
      price: 12,
      description: 'Soft homestyle phulka cooked fresh on iron tawa.',
      imageUrl:
          'https://images.weserv.nl/?url=https://upload.wikimedia.org/wikipedia/commons/thumb/b/b2/Pathiree.JPG/960px-Pathiree.JPG&w=500&h=400&fit=cover',
      isVeg: true,
    ),
    const FoodItem(
      id: 'br_011',
      categoryId: 'cat_breads',
      name: 'Butter Tawa Roti',
      price: 16,
      description: 'Fresh hot tawa phulka brushed with desi butter.',
      imageUrl:
          'https://images.weserv.nl/?url=https://upload.wikimedia.org/wikipedia/commons/thumb/7/7f/2012_%27Z%C3%BCrcher_Theater_Spektakel%27_-_Chapati_2012-08-25_17-46-31_%28P7000%29.JPG/960px-2012_%27Z%C3%BCrcher_Theater_Spektakel%27_-_Chapati_2012-08-25_17-46-31_%28P7000%29.JPG&w=500&h=400&fit=cover',
      isVeg: true,
    ),
  ];

  // ────────────────────────────────
  //  3. PARATHA
  // ────────────────────────────────
  static final List<FoodItem> _parathaItems = [
    const FoodItem(
      id: 'pr_001',
      categoryId: 'cat_paratha',
      name: 'Plain Tawa Paratha',
      price: 25,
      description: 'Golden crisp whole wheat triangle paratha made with desi ghee.',
      imageUrl:
          'https://images.weserv.nl/?url=https://upload.wikimedia.org/wikipedia/commons/thumb/4/40/A_Handful_of_Southern_India_Cusine.jpg/960px-A_Handful_of_Southern_India_Cusine.jpg&w=500&h=400&fit=cover',
      isVeg: true,
    ),
    const FoodItem(
      id: 'pr_002',
      categoryId: 'cat_paratha',
      name: 'Aloo Paratha',
      price: 50,
      description: 'Hearty whole wheat flatbread stuffed with spiced mashed potatoes.',
      imageUrl:
          'https://images.weserv.nl/?url=https://upload.wikimedia.org/wikipedia/commons/thumb/e/eb/%22Amazing_Aloo_Paratha_and_Lovely_Lassi%22.jpg/960px-%22Amazing_Aloo_Paratha_and_Lovely_Lassi%22.jpg&w=500&h=400&fit=cover',
      isPopular: true,
      isBestseller: true,
      tag: 'BESTSELLER',
      isVeg: true,
    ),
    const FoodItem(
      id: 'pr_003',
      categoryId: 'cat_paratha',
      name: 'Aloo Pyaaz Paratha',
      price: 60,
      description: 'Stuffed paratha with seasoned potato, crunchy onions and herbs.',
      imageUrl:
          'https://images.weserv.nl/?url=https://upload.wikimedia.org/wikipedia/commons/thumb/6/64/Tandoori_Aloo_Pyaz_Parantha.jpg/960px-Tandoori_Aloo_Pyaz_Parantha.jpg&w=500&h=400&fit=cover',
      isPopular: true,
      isVeg: true,
    ),
    const FoodItem(
      id: 'pr_004',
      categoryId: 'cat_paratha',
      name: 'Cheese Paratha',
      price: 80,
      description: 'Crisp paratha loaded with gooey melted cheese filling.',
      imageUrl:
          'https://images.weserv.nl/?url=https://upload.wikimedia.org/wikipedia/commons/thumb/d/d2/Cheese_Aloo_Mutter_Paratha_-_Mum%27s_Cafe%2C_Vadodara_-_Gujarat_-_02.jpg/960px-Cheese_Aloo_Mutter_Paratha_-_Mum%27s_Cafe%2C_Vadodara_-_Gujarat_-_02.jpg&w=500&h=400&fit=cover',
      isPopular: true,
      tag: 'NEW',
      isVeg: true,
    ),
    const FoodItem(
      id: 'pr_005',
      categoryId: 'cat_paratha',
      name: 'Paneer Paratha',
      price: 75,
      description: 'Generously stuffed with spiced fresh paneer, coriander and spices.',
      imageUrl:
          'https://images.weserv.nl/?url=https://upload.wikimedia.org/wikipedia/commons/3/3f/Awadhi_palak_paneer_paratha_dahi.jpg&w=500&h=400&fit=cover',
      isPopular: true,
      isBestseller: true,
      tag: 'POPULAR',
      isVeg: true,
    ),
    const FoodItem(
      id: 'pr_006',
      categoryId: 'cat_paratha',
      name: 'Paneer Cheese Paratha',
      price: 95,
      description: 'Rich fusion of crumbled paneer and melted mozzarella cheese.',
      imageUrl:
          'https://images.weserv.nl/?url=https://upload.wikimedia.org/wikipedia/commons/thumb/8/8d/Cheese_Paratha.JPG/960px-Cheese_Paratha.JPG&w=500&h=400&fit=cover',
      tag: 'CHEF\'S SPECIAL',
      isVeg: true,
    ),
    const FoodItem(
      id: 'pr_007',
      categoryId: 'cat_paratha',
      name: 'Mewa Dry Fruit Paratha',
      price: 120,
      description: 'Royal sweet paratha filled with roasted cashews, almonds and mawa.',
      imageUrl:
          'https://images.weserv.nl/?url=https://upload.wikimedia.org/wikipedia/commons/thumb/7/76/Coconut_holige.jpg/960px-Coconut_holige.jpg&w=500&h=400&fit=cover',
      tag: 'ROYAL',
      isVeg: true,
    ),
    const FoodItem(
      id: 'pr_008',
      categoryId: 'cat_paratha',
      name: 'Paneer Schezwan Paratha',
      price: 85,
      description: 'Spicy fusion paratha stuffed with paneer tossed in fiery Schezwan.',
      imageUrl:
          'https://images.weserv.nl/?url=https://upload.wikimedia.org/wikipedia/commons/thumb/0/04/Kathi_Roll.jpg/960px-Kathi_Roll.jpg&w=500&h=400&fit=cover',
      tag: 'SPICY',
      isVeg: true,
    ),
  ];

  // ────────────────────────────────
  //  4. RICE AND BIRYANI
  // ────────────────────────────────
  static final List<FoodItem> _riceBiryaniItems = [
    const FoodItem(
      id: 'rb_001',
      categoryId: 'cat_rice_biryani',
      name: 'Plain Rice',
      price: 80,
      description: 'Steamed long-grain aromatic Basmati rice, light and fluffy.',
      imageUrl:
          'https://images.unsplash.com/photo-1516684732162-798a0062be99?w=500&h=400&fit=crop',
      isVeg: true,
    ),
    const FoodItem(
      id: 'rb_002',
      categoryId: 'cat_rice_biryani',
      name: 'Jeera Rice',
      price: 100,
      description: 'Basmati rice tempered with aromatic cumin seeds and desi ghee.',
      imageUrl:
          'https://images.unsplash.com/photo-1536304993881-ff6e9eefa2a6?w=500&h=400&fit=crop',
      isPopular: true,
      isVeg: true,
    ),
    const FoodItem(
      id: 'rb_003',
      categoryId: 'cat_rice_biryani',
      name: 'Veg Pulao',
      price: 120,
      description: 'Fragrant Basmati rice cooked with fresh seasonal vegetables and whole spices.',
      imageUrl:
          'https://images.unsplash.com/photo-1596797038530-2c107229654b?w=500&h=400&fit=crop',
      isPopular: true,
      isVeg: true,
    ),
    const FoodItem(
      id: 'rb_004',
      categoryId: 'cat_rice_biryani',
      name: 'Veg Dum Pukht Biryani',
      price: 150,
      description: 'Layered basmati rice and vegetables slow-cooked under dum with saffron & mint.',
      imageUrl:
          'https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?w=500&h=400&fit=crop',
      isPopular: true,
      isBestseller: true,
      tag: 'BESTSELLER',
      isVeg: true,
    ),
    const FoodItem(
      id: 'rb_005',
      categoryId: 'cat_rice_biryani',
      name: 'Tandoori Soya Chaap Biryani',
      price: 170,
      description: 'Smoky marinated soya chaap pieces layered with spiced dum biryani rice.',
      imageUrl:
          'https://images.unsplash.com/photo-1589302168068-964664d93dc0?w=500&h=400&fit=crop',
      isPopular: true,
      tag: 'HOT',
      isVeg: true,
    ),
    const FoodItem(
      id: 'rb_006',
      categoryId: 'cat_rice_biryani',
      name: 'Punjabi Zaika Special Subz Biryani',
      price: 180,
      description: 'Chef special signature biryani loaded with dry fruits, paneer and exotic vegetables.',
      imageUrl:
          'https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?w=500&h=400&fit=crop',
      tag: 'SPECIAL',
      isVeg: true,
    ),
  ];

  // ────────────────────────────────
  //  5. SNACKS
  // ────────────────────────────────
  static final List<FoodItem> _snackItems = [
    const FoodItem(
      id: 'sn_001',
      categoryId: 'cat_snacks',
      name: 'Chole Poori',
      price: 80,
      description: 'Piping hot fluffy pooris served with spicy Amritsari chole and pickle.',
      imageUrl:
          'https://images.unsplash.com/photo-1626074353765-517a681e40be?w=500&h=400&fit=crop',
      isPopular: true,
      isBestseller: true,
      tag: 'BESTSELLER',
      isVeg: true,
    ),
    const FoodItem(
      id: 'sn_002',
      categoryId: 'cat_snacks',
      name: 'Chole with 2 Butter Kulcha',
      price: 90,
      description: 'Two soft buttered kulchas served with authentic Punjabi chole and onions.',
      imageUrl:
          'https://images.weserv.nl/?url=https://upload.wikimedia.org/wikipedia/commons/thumb/c/c6/Butter_kulcha_-_paneer_chana.jpg/960px-Butter_kulcha_-_paneer_chana.jpg&w=500&h=400&fit=cover',
      isPopular: true,
      tag: 'POPULAR',
      isVeg: true,
    ),
    const FoodItem(
      id: 'sn_003',
      categoryId: 'cat_snacks',
      name: 'Masala Paneer Kulcha',
      price: 85,
      description: 'Tandoor-baked kulcha stuffed with spiced paneer masala and butter.',
      imageUrl:
          'https://images.weserv.nl/?url=https://upload.wikimedia.org/wikipedia/commons/thumb/4/47/Aaloo_Kucha.jpg/960px-Aaloo_Kucha.jpg&w=500&h=400&fit=cover',
      isVeg: true,
    ),
    const FoodItem(
      id: 'sn_004',
      categoryId: 'cat_snacks',
      name: 'Extra Kulcha',
      price: 25,
      description: 'Single freshly baked tandoori butter kulcha.',
      imageUrl:
          'https://images.weserv.nl/?url=https://upload.wikimedia.org/wikipedia/commons/thumb/c/c6/Butter_kulcha_-_paneer_chana.jpg/960px-Butter_kulcha_-_paneer_chana.jpg&w=500&h=400&fit=cover',
      isVeg: true,
    ),
    const FoodItem(
      id: 'sn_005',
      categoryId: 'cat_snacks',
      name: 'Peri Peri Peanut Masala',
      price: 60,
      description: 'Crunchy roasted peanuts tossed with fiery peri peri seasoning, onions & lemon.',
      imageUrl:
          'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=500&h=400&fit=crop',
      tag: 'SNACK',
      isVeg: true,
    ),
    const FoodItem(
      id: 'sn_006',
      categoryId: 'cat_snacks',
      name: 'Peanut Masala',
      price: 50,
      description: 'Classic chaat of roasted peanuts, onions, tomatoes, coriander and lime.',
      imageUrl:
          'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=500&h=400&fit=crop',
      isVeg: true,
    ),
    const FoodItem(
      id: 'sn_007',
      categoryId: 'cat_snacks',
      name: 'Bombay Vada Pav',
      price: 30,
      description: 'Mumbai iconic batata vada inside pav with spicy garlic chutney and fried chilli.',
      imageUrl:
          'https://images.unsplash.com/photo-1606491956689-2ea866880c84?w=500&h=400&fit=crop',
      isPopular: true,
      isBestseller: true,
      tag: 'BESTSELLER',
      isVeg: true,
    ),
    const FoodItem(
      id: 'sn_008',
      categoryId: 'cat_snacks',
      name: 'Pav Bhaji',
      price: 60,
      description: 'Buttered pav served with rich spiced mashed vegetable curry and lemon.',
      imageUrl:
          'https://images.unsplash.com/photo-1567188040759-fb8a883dc6d8?w=500&h=400&fit=crop',
      isPopular: true,
      tag: 'POPULAR',
      isVeg: true,
    ),
  ];

  // ────────────────────────────────
  //  6. ACCOMPANIMENTS
  // ────────────────────────────────
  static final List<FoodItem> _accompanimentItems = [
    const FoodItem(
      id: 'ac_001',
      categoryId: 'cat_accompaniments',
      name: 'Pudina Chutney',
      price: 20,
      description: 'Refreshing homemade chutney made with fresh mint leaves and green chillies.',
      imageUrl:
          'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?w=500&h=400&fit=crop',
      isVeg: true,
    ),
    const FoodItem(
      id: 'ac_002',
      categoryId: 'cat_accompaniments',
      name: 'Tomato Salad',
      price: 40,
      description: 'Slices of juicy fresh ripe tomatoes sprinkled with chaat masala and lemon.',
      imageUrl:
          'https://images.unsplash.com/photo-1540420773420-3366772f4999?w=500&h=400&fit=crop',
      isVeg: true,
    ),
    const FoodItem(
      id: 'ac_003',
      categoryId: 'cat_accompaniments',
      name: 'Green Salad',
      price: 50,
      description: 'Crisp cucumbers, tomatoes, carrots, sliced onions and lemon wedges.',
      imageUrl:
          'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=500&h=400&fit=crop',
      isPopular: true,
      isVeg: true,
    ),
    const FoodItem(
      id: 'ac_004',
      categoryId: 'cat_accompaniments',
      name: 'Masala Laccha Onion Special Salad',
      price: 45,
      description: 'Crisp onion rings tossed with Kashmiri red chilli, chaat masala and lime.',
      imageUrl:
          'https://images.unsplash.com/photo-1540420773420-3366772f4999?w=500&h=400&fit=crop',
      tag: 'POPULAR',
      isVeg: true,
    ),
    const FoodItem(
      id: 'ac_005',
      categoryId: 'cat_accompaniments',
      name: 'Mirchi Tikari',
      price: 30,
      description: 'Traditional crushed spicy green chilli pickle with garlic and spices.',
      imageUrl:
          'https://images.unsplash.com/photo-1589302168068-964664d93dc0?w=500&h=400&fit=crop',
      isVeg: true,
    ),
    const FoodItem(
      id: 'ac_006',
      categoryId: 'cat_accompaniments',
      name: 'Fried Mirchi',
      price: 20,
      description: 'Salted and spiced fried green chillies, the essential meal companion.',
      imageUrl:
          'https://images.unsplash.com/photo-1589302168068-964664d93dc0?w=500&h=400&fit=crop',
      isVeg: true,
    ),
    const FoodItem(
      id: 'ac_007',
      categoryId: 'cat_accompaniments',
      name: 'Mint Chutney',
      price: 25,
      description: 'Creamy yoghurt and mint condiment with roasted cumin spices.',
      imageUrl:
          'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?w=500&h=400&fit=crop',
      isVeg: true,
    ),
    const FoodItem(
      id: 'ac_008',
      categoryId: 'cat_accompaniments',
      name: 'Fried Papad Churi',
      price: 35,
      description: 'Crushed crispy papad tossed in pure desi ghee and roasted cumin masala.',
      imageUrl:
          'https://images.weserv.nl/?url=https://upload.wikimedia.org/wikipedia/commons/thumb/7/70/Laccha_Paratha.JPG/960px-Laccha_Paratha.JPG&w=500&h=400&fit=cover',
      isVeg: true,
    ),
    const FoodItem(
      id: 'ac_009',
      categoryId: 'cat_accompaniments',
      name: 'Masala Papad',
      price: 40,
      description: 'Crisp roasted papad topped with spicy onion-tomato salad and sev.',
      imageUrl:
          'https://images.unsplash.com/photo-1565557623262-b51c2513a641?w=500&h=400&fit=crop',
      isPopular: true,
      isVeg: true,
    ),
    const FoodItem(
      id: 'ac_010',
      categoryId: 'cat_accompaniments',
      name: 'Lehsun Chutney',
      price: 30,
      description: 'Spicy and tangy Rajasthani style garlic and red chilli chutney.',
      imageUrl:
          'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?w=500&h=400&fit=crop',
      isVeg: true,
    ),
  ];

  // ────────────────────────────────
  //  7. DRINKS
  // ────────────────────────────────
  static final List<FoodItem> _drinkItems = [
    const FoodItem(
      id: 'dr_001',
      categoryId: 'cat_drinks',
      name: 'Special Masala Tea',
      price: 20,
      description: 'Hot freshly brewed tea with ginger, cardamom, cloves and milk.',
      imageUrl:
          'https://images.unsplash.com/photo-1576092768241-dec231879fc3?w=500&h=400&fit=crop',
      isPopular: true,
      isBestseller: true,
      tag: 'BESTSELLER',
      isVeg: true,
    ),
    const FoodItem(
      id: 'dr_002',
      categoryId: 'cat_drinks',
      name: 'Hot Filter Coffee',
      price: 35,
      description: 'South Indian style aromatic freshly brewed filter coffee with froth.',
      imageUrl:
          'https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd?w=500&h=400&fit=crop',
      isPopular: true,
      isVeg: true,
    ),
    const FoodItem(
      id: 'dr_003',
      categoryId: 'cat_drinks',
      name: 'Chilled Cold Coffee',
      price: 50,
      description: 'Thick creamy blended cold coffee served with chocolate dusting.',
      imageUrl:
          'https://images.unsplash.com/photo-1517701550927-30cf4ba1dba5?w=500&h=400&fit=crop',
      isPopular: true,
      tag: 'REFRESHING',
      isVeg: true,
    ),
    const FoodItem(
      id: 'dr_004',
      categoryId: 'cat_drinks',
      name: 'Fresh Nimbu Pani',
      price: 30,
      description: 'Freshly squeezed lemon water with mint leaves and black salt.',
      imageUrl:
          'https://images.unsplash.com/photo-1513558161293-cdaf765ed2fd?w=500&h=400&fit=crop',
      isVeg: true,
    ),
    const FoodItem(
      id: 'dr_005',
      categoryId: 'cat_drinks',
      name: 'Masala Lemon Soda',
      price: 40,
      description: 'Chilled bubbly soda spiked with fresh lemon and chatpata spices.',
      imageUrl:
          'https://images.unsplash.com/photo-1551024709-8f23befc6f87?w=500&h=400&fit=crop',
      isPopular: true,
      isVeg: true,
    ),
    const FoodItem(
      id: 'dr_006',
      categoryId: 'cat_drinks',
      name: 'Chilled Masala Chaas',
      price: 30,
      description: 'Traditional spiced buttermilk with roasted cumin seeds and coriander.',
      imageUrl:
          'https://images.unsplash.com/photo-1556881286-fc6915169721?w=500&h=400&fit=crop',
      isPopular: true,
      tag: 'HEALTHY',
      isVeg: true,
    ),
    const FoodItem(
      id: 'dr_007',
      categoryId: 'cat_drinks',
      name: 'Punjabi Sweet Lassi',
      price: 50,
      description: 'Thick and creamy sweet yoghurt shake topped with rich malai.',
      imageUrl:
          'https://images.unsplash.com/photo-1553530666-ba11a7da3888?w=500&h=400&fit=crop',
      isPopular: true,
      isBestseller: true,
      tag: 'POPULAR',
      isVeg: true,
    ),
  ];

  // ────────────────────────────────
  //  8. ALL DAY BREAKFAST
  // ────────────────────────────────
  static final List<FoodItem> _breakfastItems = [
    const FoodItem(
      id: 'bf_001',
      categoryId: 'cat_breakfast',
      name: 'Classic Indian Maggi',
      price: 40,
      description: 'All-time favorite instant Maggi noodles with authentic tastemaker.',
      imageUrl:
          'https://images.unsplash.com/photo-1612927601601-6638404737ce?w=500&h=400&fit=crop',
      isPopular: true,
      isBestseller: true,
      tag: 'BESTSELLER',
      isVeg: true,
    ),
    const FoodItem(
      id: 'bf_002',
      categoryId: 'cat_breakfast',
      name: 'Veg Masala Maggi',
      price: 50,
      description: 'Maggi tossed with fresh green peas, onions, carrots and special spices.',
      imageUrl:
          'https://images.unsplash.com/photo-1569718212165-3a8278d5f624?w=500&h=400&fit=crop',
      isPopular: true,
      tag: 'POPULAR',
      isVeg: true,
    ),
    const FoodItem(
      id: 'bf_003',
      categoryId: 'cat_breakfast',
      name: 'Paneer Cheese Maggi',
      price: 70,
      description: 'Loaded Maggi noodles with succulent paneer chunks and melted cheese.',
      imageUrl:
          'https://images.unsplash.com/photo-1612927601601-6638404737ce?w=500&h=400&fit=crop',
      isPopular: true,
      tag: 'CHEESY',
      isVeg: true,
    ),
    const FoodItem(
      id: 'bf_004',
      categoryId: 'cat_breakfast',
      name: 'Schezwan Maggi',
      price: 55,
      description: 'Fiery street-style noodles tossed in spicy Schezwan sauce and veggies.',
      imageUrl:
          'https://images.unsplash.com/photo-1569718212165-3a8278d5f624?w=500&h=400&fit=crop',
      tag: 'SPICY',
      isVeg: true,
    ),
    const FoodItem(
      id: 'bf_005',
      categoryId: 'cat_breakfast',
      name: 'Maggi Bhel Chaat',
      price: 60,
      description: 'Crunchy roasted Maggi tossed with chopped onions, tomatoes, chutneys & sev.',
      imageUrl:
          'https://images.unsplash.com/photo-1567188040759-fb8a883dc6d8?w=500&h=400&fit=crop',
      tag: 'SPECIAL',
      isVeg: true,
    ),
    const FoodItem(
      id: 'bf_006',
      categoryId: 'cat_breakfast',
      name: 'Indori Poha',
      price: 35,
      description: 'Steamed flattened rice tempered with mustard, fennel seeds, peanuts and ratlami sev.',
      imageUrl:
          'https://images.unsplash.com/photo-1630383249896-424e482df921?w=500&h=400&fit=crop',
      isPopular: true,
      isBestseller: true,
      tag: 'BESTSELLER',
      isVeg: true,
    ),
    const FoodItem(
      id: 'bf_007',
      categoryId: 'cat_breakfast',
      name: 'Paneer Poha',
      price: 50,
      description: 'Light and fluffy poha tossed with pan-seared paneer cubes and herbs.',
      imageUrl:
          'https://images.unsplash.com/photo-1630383249896-424e482df921?w=500&h=400&fit=crop',
      isVeg: true,
    ),
    const FoodItem(
      id: 'bf_008',
      categoryId: 'cat_breakfast',
      name: 'Veg Upma',
      price: 40,
      description: 'Traditional roasted semolina porridge cooked with curry leaves, cashews and vegetables.',
      imageUrl:
          'https://images.weserv.nl/?url=https://upload.wikimedia.org/wikipedia/commons/thumb/4/40/A_Handful_of_Southern_India_Cusine.jpg/960px-A_Handful_of_Southern_India_Cusine.jpg&w=500&h=400&fit=cover',
      isVeg: true,
    ),
  ];

  // ────────────────────────────────
  //  9. MINERAL WATER (Bisleri Sections)
  // ────────────────────────────────
  static final List<FoodItem> _waterItems = [
    const FoodItem(
      id: 'wt_001',
      categoryId: 'cat_water',
      name: 'Bisleri Water Bottle',
      brand: 'Bisleri',
      volume: '250 ml',
      price: 10,
      description:
          'Compact 250ml pocket bottle with essential minerals. 10-step purification process for pure & safe drinking water.',
      imageUrl:
          'https://www.bisleri.com/on/demandware.static/-/Sites-Bis-Catalog/default/dwe1a6e391/Product%20Images_Desktop/Bisleri/Bisleri250ml/288/PDP/Bisleri_Ecom_Web_250ml_01.png',
      isPopular: true,
      tag: '₹10 PACK',
      isVeg: true,
    ),
    const FoodItem(
      id: 'wt_002',
      categoryId: 'cat_water',
      name: 'Bisleri Water Bottle',
      brand: 'Bisleri',
      volume: '500 ml',
      price: 20,
      description:
          'Refreshing 500ml mineral water bottle. Enriched with minerals like Potassium and Magnesium for active hydration.',
      imageUrl:
          'https://www.bisleri.com/on/demandware.static/-/Sites-Bis-Catalog/default/dwd78b6fa8/Product%20Images_Desktop/Bisleri/Bisleri500ml/PDP/Bisleri_Ecom_Web_500ml_01.png',
      isPopular: true,
      isBestseller: true,
      tag: 'BESTSELLER',
      isVeg: true,
    ),
    const FoodItem(
      id: 'wt_003',
      categoryId: 'cat_water',
      name: 'Bisleri Water Bottle',
      brand: 'Bisleri',
      volume: '1 Litre',
      price: 30,
      description:
          'Standard 1 Litre dining table water pack. Ozonated purity with vital minerals, trusted by millions.',
      imageUrl:
          'https://www.bisleri.com/on/demandware.static/-/Sites-Bis-Catalog/default/dw7c47d214/Product%20Images_Desktop/Bisleri/Bisleri1Litre/PDP/Bisleri_Ecom_Web_1L_01.png',
      isPopular: true,
      isBestseller: true,
      tag: 'POPULAR',
      isVeg: true,
    ),
    const FoodItem(
      id: 'wt_004',
      categoryId: 'cat_water',
      name: 'Bisleri Water Bottle',
      brand: 'Bisleri',
      volume: '2 Litre',
      price: 50,
      description:
          'Jumbo 2 Litres packaged mineral water bottle — ideal for families & group meals at the table.',
      imageUrl:
          'https://www.bisleri.com/on/demandware.static/-/Sites-Bis-Catalog/default/dw9d757265/Product%20Images_Desktop/Bisleri/Bisleri2Litre/PDP/Bisleri_Ecom_Web_2L_01.png',
      isPopular: false,
      tag: 'FAMILY PACK',
      isVeg: true,
    ),
  ];

  // ────────────────────────────────
  //  ALL ITEMS (combined)
  // ────────────────────────────────
  static List<FoodItem> get allItems => [
        ..._mainCourseItems,
        ..._breadItems,
        ..._parathaItems,
        ..._riceBiryaniItems,
        ..._snackItems,
        ..._accompanimentItems,
        ..._drinkItems,
        ..._breakfastItems,
        ..._waterItems,
      ];

  static List<FoodItem> getItemsByCategory(String categoryId) {
    return allItems
        .where((item) => item.categoryId == categoryId && item.isAvailable)
        .toList();
  }

  static List<FoodItem> get popularItems =>
      allItems.where((item) => item.isPopular && item.isAvailable).toList();

  static List<FoodItem> get bestsellers =>
      allItems.where((item) => item.isBestseller && item.isAvailable).toList();

  static FoodItem? getItemById(String id) {
    try {
      return allItems.firstWhere((item) => item.id == id);
    } catch (_) {
      return null;
    }
  }

  static List<FoodItem> searchItems(String query) {
    final q = query.toLowerCase();
    return allItems
        .where((item) =>
            item.name.toLowerCase().contains(q) ||
            item.description.toLowerCase().contains(q))
        .toList();
  }

  // ────────────────────────────────
  //  TABLES
  // ────────────────────────────────
  static final List<RestaurantTable> defaultTables = List.generate(
    12,
    (i) => RestaurantTable(
      id: 'table_${i + 1}',
      number: '${i + 1}',
      capacity: (i % 3 == 0) ? 2 : (i % 3 == 1) ? 4 : 6,
    ),
  );

  // ────────────────────────────────
  //  OFFERS
  // ────────────────────────────────
  static const List<Map<String, dynamic>> offers = [
    {
      'id': 'offer_1',
      'title': '15% OFF on Main Course! 🍛',
      'description': 'Valid on Paneer & Dal Makhani orders.',
      'color': 0xFF1B5E20,
      'emoji': '🍛',
    },
    {
      'id': 'offer_2',
      'title': 'Chole Poori + Lassi Combo!',
      'description': 'Enjoy fresh breakfast combo at ₹110 only.',
      'color': 0xFFFF6F00,
      'emoji': '🥟',
    },
    {
      'id': 'offer_3',
      'title': 'Special Tea & Snacks Hour ☕',
      'description': 'Fresh samosa / pakoda with Masala Chai.',
      'color': 0xFF1976D2,
      'emoji': '☕',
    },
  ];
}
