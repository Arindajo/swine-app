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
      title: json['title'] ?? 'No Title',  // Added default value if title is null
      content: json['content'] ?? 'No Content',  // Added default value if content is null
      temperature: (json['temperature'] ?? 0.0).toDouble(),  // Fallback to 0.0 if missing or null
      activityLevel: json['activity_level'] ?? 'Unknown',  // Default to 'Unknown' if missing
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),  // Default to current time if 'created_at' is null or invalid
    );
  }
}
