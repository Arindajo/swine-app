//THE MODEL

class Report {
  final String title;
  final String content;
  final DateTime createdAt;

  Report({
    required this.title,
    required this.content,
    required this.createdAt,
  });

  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
      title: json['title'],
      content: json['content'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
