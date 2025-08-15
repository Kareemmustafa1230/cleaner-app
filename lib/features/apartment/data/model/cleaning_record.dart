class CleaningRecord {
  final String id;
  final String apartmentId;
  final DateTime cleaningDate;
  final double totalCost;
  final double laborCost;
  final double inventoryCost;
  final String status; // 'completed', 'in_progress', 'pending'
  final List<UsedInventoryItem> usedItems;
  final String? notes;

  CleaningRecord({
    required this.id,
    required this.apartmentId,
    required this.cleaningDate,
    required this.totalCost,
    required this.laborCost,
    required this.inventoryCost,
    required this.status,
    required this.usedItems,
    this.notes,
  });

  factory CleaningRecord.fromJson(Map<String, dynamic> json) {
    return CleaningRecord(
      id: json['id'] ?? '',
      apartmentId: json['apartment_id'] ?? '',
      cleaningDate: DateTime.parse(json['cleaning_date']),
      totalCost: (json['total_cost'] ?? 0.0).toDouble(),
      laborCost: (json['labor_cost'] ?? 0.0).toDouble(),
      inventoryCost: (json['inventory_cost'] ?? 0.0).toDouble(),
      status: json['status'] ?? '',
      usedItems: (json['used_items'] as List<dynamic>?)
          ?.map((item) => UsedInventoryItem.fromJson(item))
          .toList() ?? [],
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'apartment_id': apartmentId,
      'cleaning_date': cleaningDate.toIso8601String(),
      'total_cost': totalCost,
      'labor_cost': laborCost,
      'inventory_cost': inventoryCost,
      'status': status,
      'used_items': usedItems.map((item) => item.toJson()).toList(),
      'notes': notes,
    };
  }
}

class UsedInventoryItem {
  final String id;
  final String name;
  final String category;
  final String unit;
  final double unitPrice;
  final int quantity;
  final double totalPrice;

  UsedInventoryItem({
    required this.id,
    required this.name,
    required this.category,
    required this.unit,
    required this.unitPrice,
    required this.quantity,
    required this.totalPrice,
  });

  factory UsedInventoryItem.fromJson(Map<String, dynamic> json) {
    return UsedInventoryItem(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      category: json['category'] ?? '',
      unit: json['unit'] ?? '',
      unitPrice: (json['unit_price'] ?? 0.0).toDouble(),
      quantity: json['quantity'] ?? 0,
      totalPrice: (json['total_price'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'unit': unit,
      'unit_price': unitPrice,
      'quantity': quantity,
      'total_price': totalPrice,
    };
  }
} 