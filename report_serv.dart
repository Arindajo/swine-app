import 'dart:convert';
import 'package:http/http.dart' as http;
import 'report_model.dart';

class ReportService {
  static const String baseUrl = 'http://192.168.43.103:8000/api/reports/'; // Replace with actual API URL

  static Future<List<Report>> fetchReports() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      // Decode the response body into a Map
      final Map<String, dynamic> data = json.decode(response.body);

      // Assuming the reports are inside a 'results' key (adjust as needed)
      final List reportsJson = data['results'];  // Change this if the key is different in your API

      // Map the JSON data to a list of Report objects
      return reportsJson.map((json) => Report.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load reports');
    }
  }
}
