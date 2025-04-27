import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> sendTreatmentData(
  Map<String, dynamic> pig,
  String treatmentType,
  String notes,
  DateTime date,
) async {
  final url = 'http://your-api-endpoint-here/api/treatment/';  // Replace with actual API endpoint
  
  // Create the request body
  final Map<String, dynamic> requestBody = {
    'pig_id': pig['id'].toString(),
    'treatment_type': treatmentType,
    'notes': notes,
    'date': date.toIso8601String(),
  };

  // Make the API call
  final response = await http.post(
    Uri.parse(url),
    body: json.encode(requestBody),
    headers: {
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    // Successfully saved treatment data
    print('Treatment data saved successfully!');
  } else {
    throw Exception('Failed to save treatment data');
  }
}
