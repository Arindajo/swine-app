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
      activityLevel: json['activity_level'] ?? 'Unknown',
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {  // 👈 Added this
    return {
      'title': title,
      'content': content,
      'temperature': temperature,
      'activityLevel': activityLevel,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
