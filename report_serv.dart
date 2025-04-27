import 'dart:convert';
import 'package:http/http.dart' as http;
import 'report_model.dart';

class ReportService {
  static const String baseUrl = 'http://192.168.43.103:8000/api/reports/'; // Replace with actual API URL

  static Future<List<Report>> fetchReports() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));

       print('Response Body: ${response.body}');


      if (response.statusCode == 200) {
        // Decode the response body into a Map
        final Map<String, dynamic> data = json.decode(response.body);

        // Ensure the 'results' key exists and is not null
        if (data['results'] != null && data['results'] is List) {
          final List reportsJson = data['results'];

          // Map the JSON data to a list of Report objects
          return reportsJson.map((json) => Report.fromJson(json)).toList();
        } else {
          // Return an empty list if 'results' is null or not a list
          return [];
        }
      } else {
        throw Exception('Failed to load reports: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching reports: $e');
      return []; // Return an empty list if an error occurs
    }
  }
}
