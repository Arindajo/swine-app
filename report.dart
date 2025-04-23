class Report {
  final String title;
  final String content;
  final String createdAt;

  Report({required this.title, required this.content, required this.createdAt});

  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
      title: json['title'],
      content: json['content'],
      createdAt: json['created_at'],
    );
  }
}
