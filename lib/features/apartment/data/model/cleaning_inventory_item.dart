class CleaningInventoryItem {
  final String id;
  final String name;
  final String category;
  final String unit;
  final double price;
  final int availableQuantity;
  final int usedQuantity;
  final String? imageUrl;
  final String? description;

  CleaningInventoryItem({
    required this.id,
    required this.name,
    required this.category,
    required this.unit,
    required this.price,
    required this.availableQuantity,
    this.usedQuantity = 0,
    this.imageUrl,
    this.description,
  });

  factory CleaningInventoryItem.fromJson(Map<String, dynamic> json) {
    return CleaningInventoryItem(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      category: json['category'] ?? '',
      unit: json['unit'] ?? '',
      price: (json['price'] ?? 0.0).toDouble(),
      availableQuantity: json['available_quantity'] ?? 0,
      usedQuantity: json['used_quantity'] ?? 0,
      imageUrl: json['image_url'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'unit': unit,
      'price': price,
      'available_quantity': availableQuantity,
      'used_quantity': usedQuantity,
      'image_url': imageUrl,
      'description': description,
    };
  }

  CleaningInventoryItem copyWith({
    String? id,
    String? name,
    String? category,
    String? unit,
    double? price,
    int? availableQuantity,
    int? usedQuantity,
    String? imageUrl,
    String? description,
  }) {
    return CleaningInventoryItem(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      unit: unit ?? this.unit,
      price: price ?? this.price,
      availableQuantity: availableQuantity ?? this.availableQuantity,
      usedQuantity: usedQuantity ?? this.usedQuantity,
      imageUrl: imageUrl ?? this.imageUrl,
      description: description ?? this.description,
    );
  }
} 