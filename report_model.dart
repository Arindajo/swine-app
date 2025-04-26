class Report {
  final String title;
  final String content;
  final double temperature;
  final String activityLevel;
  final DateTime createdAt;

  Report({
    required this.title,
    required this.content,
    required this.temperature,
    required this.activityLevel,
    required this.createdAt,
  });

  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
      title: json['title'],
      content: json['content'],
      temperature: (json['temperature'] ?? 0.0).toDouble(),
      activityLevel: json['activity_level'] ?? 'Unknown',  // Ensure 'activity_level' is correctly mapped
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
