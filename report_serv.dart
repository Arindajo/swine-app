import 'dart:convert';
import 'package:http/http.dart' as http;
import 'report.dart';

Future<List<Report>> fetchReports() async {
  final response = await http.get(Uri.parse("http://<your-server-ip>:8000/api/reports/"));

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body)['reports'];
    return List<Report>.from(data.map((item) => Report.fromJson(item)));
  } else {
    throw Exception("Failed to load reports");
  }
}
