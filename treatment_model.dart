class Treatment {
  final int id;
  final String treatmentType;
  final String notes;
  final DateTime date;

  Treatment({
    required this.id,
    required this.treatmentType,
    required this.notes,
    required this.date,
  });

  factory Treatment.fromJson(Map<String, dynamic> json) {
    return Treatment(
      id: json['id'],
      treatmentType: json['treatment_type'],
      notes: json['notes'],
      date: DateTime.parse(json['date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'treatment_type': treatmentType,
      'notes': notes,
      'date': date.toIso8601String(),
    };
  }
}
