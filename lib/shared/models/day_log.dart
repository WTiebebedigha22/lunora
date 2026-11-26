class DayLog {
  DayLog({
    List<String>? symptoms,
    this.severity = 3,
    String mood = '',
    this.notes = '',
    List<String>? meds,
    int? updatedAt,
  })  : symptoms = symptoms ?? const [],
        _mood = mood,
        meds = meds ?? const [],
        updatedAt = updatedAt ?? DateTime.now().millisecondsSinceEpoch;

  final List<String> symptoms;
  final int severity;
  // Nullable backing storage keeps pre-mood logs safe across hot reload.
  final String? _mood;
  String get mood => _mood ?? '';
  final String notes;
  final List<String> meds;
  final int updatedAt;

  bool get isEmpty => symptoms.isEmpty && notes.trim().isEmpty && meds.isEmpty && mood.isEmpty;

  DayLog copyWith({
    List<String>? symptoms,
    int? severity,
    String? mood,
    String? notes,
    List<String>? meds,
    int? updatedAt,
  }) {
    return DayLog(
      symptoms: symptoms ?? this.symptoms,
      severity: severity ?? this.severity,
      mood: mood ?? this.mood,
      notes: notes ?? this.notes,
      meds: meds ?? this.meds,
      updatedAt: updatedAt ?? DateTime.now().millisecondsSinceEpoch,
    );
  }

  Map<String, dynamic> toMap() => {
        'symptoms': symptoms,
        'severity': severity,
        'mood': mood,
        'notes': notes,
        'meds': meds,
        'updatedAt': updatedAt,
      };

  factory DayLog.fromMap(Map<dynamic, dynamic> m) {
    return DayLog(
      symptoms: List<String>.from((m['symptoms'] as List?) ?? const []),
      severity: (m['severity'] as num?)?.toInt() ?? 3,
      mood: (m['mood'] as String?) ?? '',
      notes: (m['notes'] as String?) ?? '',
      meds: List<String>.from((m['meds'] as List?) ?? const []),
      updatedAt: (m['updatedAt'] as num?)?.toInt() ??
          DateTime.now().millisecondsSinceEpoch,
    );
  }
}
