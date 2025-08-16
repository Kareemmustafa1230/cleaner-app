class CleaningService {
  final String id;
  final String apartmentId;
  final double servicePrice;
  final String serviceType; // 'basic', 'deep', 'daily'
  final DateTime? serviceDate;
  final String? notes;
  final String status; // 'pending', 'in_progress', 'completed'
  final List<String> usedItems; // قائمة معرفات العناصر المستخدمة

  CleaningService({
    required this.id,
    required this.apartmentId,
    required this.servicePrice,
    required this.serviceType,
    this.serviceDate,
    this.notes,
    required this.status,
    this.usedItems = const [],
  });

  factory CleaningService.fromJson(Map<String, dynamic> json) {
    return CleaningService(
      id: json['id'] ?? '',
      apartmentId: json['apartment_id'] ?? '',
      servicePrice: (json['service_price'] ?? 0.0).toDouble(),
      serviceType: json['service_type'] ?? '',
      serviceDate: json['service_date'] != null 
          ? DateTime.parse(json['service_date']) 
          : null,
      notes: json['notes'],
      status: json['status'] ?? '',
      usedItems: List<String>.from(json['used_items'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'apartment_id': apartmentId,
      'service_price': servicePrice,
      'service_type': serviceType,
      'service_date': serviceDate?.toIso8601String(),
      'notes': notes,
      'status': status,
      'used_items': usedItems,
    };
  }

  CleaningService copyWith({
    String? id,
    String? apartmentId,
    double? servicePrice,
    String? serviceType,
    DateTime? serviceDate,
    String? notes,
    String? status,
    List<String>? usedItems,
  }) {
    return CleaningService(
      id: id ?? this.id,
      apartmentId: apartmentId ?? this.apartmentId,
      servicePrice: servicePrice ?? this.servicePrice,
      serviceType: serviceType ?? this.serviceType,
      serviceDate: serviceDate ?? this.serviceDate,
      notes: notes ?? this.notes,
      status: status ?? this.status,
      usedItems: usedItems ?? this.usedItems,
    );
  }
} 