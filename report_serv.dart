import 'dart:convert';
import 'package:http/http.dart' as http;
import 'report_model.dart';

class ReportService {
  static const String baseUrl = 'http://192.168.43.103:8000/api/reports/'; // Replace with actual

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
