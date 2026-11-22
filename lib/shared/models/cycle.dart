class Cycle {
  Cycle({
    required this.id,
    required this.startDate,
    this.endDate,
    this.flow,
    int? createdAt,
    int? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now().millisecondsSinceEpoch,
        updatedAt = updatedAt ?? DateTime.now().millisecondsSinceEpoch;

  final String id;
  final String startDate; // 'YYYY-MM-DD'
  final String? endDate; // 'YYYY-MM-DD' or null = ongoing
  final String? flow; // 'light' | 'medium' | 'heavy' | null
  final int createdAt;
  final int updatedAt;

  bool get isOngoing => endDate == null;

  bool containsDate(DateTime d) {
    final ds = _fmt(d);
    if (ds.compareTo(startDate) < 0) return false;
    if (endDate == null) {
      final today = _fmt(DateTime.now());
      return ds.compareTo(today) <= 0;
    }
    return ds.compareTo(endDate!) <= 0;
  }

  int? get lengthDays {
    if (endDate == null) return null;
    final s = DateTime.parse(startDate);
    final e = DateTime.parse(endDate!);
    return e.difference(s).inDays + 1;
  }

  Cycle copyWith({
    String? endDate,
    String? flow,
    int? updatedAt,
  }) {
    return Cycle(
      id: id,
      startDate: startDate,
      endDate: endDate ?? this.endDate,
      flow: flow ?? this.flow,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now().millisecondsSinceEpoch,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'startDate': startDate,
        'endDate': endDate,
        'flow': flow,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
      };

  factory Cycle.fromMap(Map<dynamic, dynamic> m) {
    return Cycle(
      id: m['id'] as String,
      startDate: m['startDate'] as String,
      endDate: m['endDate'] as String?,
      flow: m['flow'] as String?,
      createdAt: (m['createdAt'] as num?)?.toInt() ?? 0,
      updatedAt: (m['updatedAt'] as num?)?.toInt() ?? 0,
    );
  }

  static String _fmt(DateTime d) => '${d.year.toString().padLeft(4, '0')}-'
      '${d.month.toString().padLeft(2, '0')}-'
      '${d.day.toString().padLeft(2, '0')}';
}
