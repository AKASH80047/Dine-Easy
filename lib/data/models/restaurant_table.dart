class RestaurantTable {
  final String id;
  final String number;
  final int capacity;
  final bool isOccupied;
  final bool isActive;
  final String? currentOrderId;

  const RestaurantTable({
    required this.id,
    required this.number,
    required this.capacity,
    this.isOccupied = false,
    this.isActive = true,
    this.currentOrderId,
  });

  String get qrData => 'TABLE_$number';
  String get displayName => 'Table $number';

  RestaurantTable copyWith({
    String? id,
    String? number,
    int? capacity,
    bool? isOccupied,
    bool? isActive,
    String? currentOrderId,
  }) {
    return RestaurantTable(
      id: id ?? this.id,
      number: number ?? this.number,
      capacity: capacity ?? this.capacity,
      isOccupied: isOccupied ?? this.isOccupied,
      isActive: isActive ?? this.isActive,
      currentOrderId: currentOrderId ?? this.currentOrderId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'number': number,
      'capacity': capacity,
      'isOccupied': isOccupied,
      'isActive': isActive,
      'currentOrderId': currentOrderId,
    };
  }

  factory RestaurantTable.fromMap(Map<String, dynamic> map) {
    return RestaurantTable(
      id: map['id'] as String,
      number: map['number'] as String,
      capacity: map['capacity'] as int? ?? 4,
      isOccupied: map['isOccupied'] as bool? ?? false,
      isActive: map['isActive'] as bool? ?? true,
      currentOrderId: map['currentOrderId'] as String?,
    );
  }
}
