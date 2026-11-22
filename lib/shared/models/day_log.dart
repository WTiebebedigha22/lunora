class DayLog {
  DayLog({
    List<String>? symptoms,
    this.severity = 3,
    this.notes = '',
    List<String>? meds,
    int? updatedAt,
  })  : symptoms = symptoms ?? const [],
        meds = meds ?? const [],
        updatedAt = updatedAt ?? DateTime.now().millisecondsSinceEpoch;

  final List<String> symptoms;
  final int severity;
  final String notes;
  final List<String> meds;
  final int updatedAt;

  bool get isEmpty => symptoms.isEmpty && notes.trim().isEmpty && meds.isEmpty;

  DayLog copyWith({
    List<String>? symptoms,
    int? severity,
    String? notes,
    List<String>? meds,
    int? updatedAt,
  }) {
    return DayLog(
      symptoms: symptoms ?? this.symptoms,
      severity: severity ?? this.severity,
      notes: notes ?? this.notes,
      meds: meds ?? this.meds,
      updatedAt: updatedAt ?? DateTime.now().millisecondsSinceEpoch,
    );
  }

  Map<String, dynamic> toMap() => {
        'symptoms': symptoms,
        'severity': severity,
        'notes': notes,
        'meds': meds,
        'updatedAt': updatedAt,
      };

  factory DayLog.fromMap(Map<dynamic, dynamic> m) {
    return DayLog(
      symptoms: List<String>.from((m['symptoms'] as List?) ?? const []),
      severity: (m['severity'] as num?)?.toInt() ?? 3,
      notes: (m['notes'] as String?) ?? '',
      meds: List<String>.from((m['meds'] as List?) ?? const []),
      updatedAt: (m['updatedAt'] as num?)?.toInt() ??
          DateTime.now().millisecondsSinceEpoch,
    );
  }
}
