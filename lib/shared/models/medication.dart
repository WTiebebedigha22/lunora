class Medication {
  Medication({
    required this.id,
    required this.name,
    this.dose = '',
    int? createdAt,
  }) : createdAt = createdAt ?? DateTime.now().millisecondsSinceEpoch;

  final String id;
  final String name;
  final String dose;
  final int createdAt;

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'dose': dose,
        'createdAt': createdAt,
      };

  factory Medication.fromMap(Map<dynamic, dynamic> m) {
    return Medication(
      id: m['id'] as String,
      name: (m['name'] as String?) ?? '',
      dose: (m['dose'] as String?) ?? '',
      createdAt: (m['createdAt'] as num?)?.toInt() ?? 0,
    );
  }
}
