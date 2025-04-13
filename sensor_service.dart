// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'sensor_data.dart';

// class SensorService {
//   final String apiUrl = 'http://30.30.196.64:8000/api/sensordata/'; // use your IP

//   Future<List<SensorDataModel>> fetchSensorData(String token) async {
//     final response = await http.get(
//       Uri.parse(apiUrl),
//       headers: {
//         'Authorization': 'Token $token',
//       },
//     );

//     if (response.statusCode == 200) {
//       List<dynamic> data = json.decode(response.body);
//       return data.map((item) => SensorDataModel.fromJson(item)).toList();
//     } else {
//       throw Exception('Failed to load sensor data');
//     }
//   }
// }
