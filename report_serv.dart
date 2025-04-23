import 'dart:convert';
import 'package:http/http.dart' as http;
import 'report.dart'; // your Report model

class ReportService {
  static const String baseUrl = 'http://your-ip-or-domain/api/reports/';

  static Future<List<Report>> fetchReports() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final List reportsJson = json.decode(response.body)['reports'];
      return reportsJson.map((json) => Report.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load reports');
    }
  }
}
