import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class SensorData {
  final double magnitude;
  final String activityLevel;
  final String timestamp;

  SensorData({
    required this.magnitude,
    required this.activityLevel,
    required this.timestamp,
  });

  factory SensorData.fromJson(Map<String, dynamic> json) {
    return SensorData(
      magnitude: json['magnitude']?.toDouble() ?? 0.0,
      activityLevel: json['activity_level'] ?? "Unknown",
      timestamp: json['timestamp'] ?? "",
    );
  }
}

class ActivityGaugePage extends StatefulWidget {
  @override
  _ActivityGaugePageState createState() => _ActivityGaugePageState();
}

class _ActivityGaugePageState extends State<ActivityGaugePage> {
  Timer? _timer;
  SensorData? currentData;
  bool isLoading = true;
  String? error;

  Future<SensorData> fetchLatestData() async {
    final response = await http.get(
      Uri.parse('http://192.168.43.103:8000/api/sensordata/'),
      headers: {
        'Authorization': "Token YOUR_TOKEN_HERE", // Replace with your token
      },
    );

    if (response.statusCode == 200) {
      List jsonList = json.decode(response.body);
      if (jsonList.isNotEmpty) {
        final latest = jsonList.last;
        return SensorData.fromJson(latest);
      } else {
        throw Exception("No data available");
      }
    } else {
      throw Exception('Failed to load data');
    }
  }

  void fetchAndUpdate() async {
    try {
      final data = await fetchLatestData();
      setState(() {
        currentData = data;
        isLoading = false;
        error = null;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  Color getActivityColor(String level) {
    switch (level) {
      case "Low Activity":
        return Colors.green;
      case "Moderate Activity":
        return Colors.orange;
      case "High Activity":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  void initState() {
    super.initState();
    fetchAndUpdate();
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      fetchAndUpdate();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Activity Monitor")),
      body: Center(
        child: isLoading
            ? CircularProgressIndicator()
            : error != null
                ? Text("Error: $error")
                : currentData == null
                    ? Text("No data available")
                    : SfRadialGauge(
                        title: GaugeTitle(
                          text: '${currentData!.activityLevel} (${currentData!.magnitude.toStringAsFixed(2)})',
                          textStyle: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: getActivityColor(currentData!.activityLevel),
                          ),
                        ),
                        axes: <RadialAxis>[
                          RadialAxis(
                            minimum: 0,
                            maximum: 20,
                            ranges: <GaugeRange>[
                              GaugeRange(startValue: 0, endValue: 6, color: Colors.green),
                              GaugeRange(startValue: 6, endValue: 12, color: Colors.orange),
                              GaugeRange(startValue: 12, endValue: 20, color: Colors.red),
                            ],
                            pointers: <GaugePointer>[
                              NeedlePointer(value: currentData!.magnitude),
                            ],
                            annotations: <GaugeAnnotation>[
                              GaugeAnnotation(
                                widget: Text(
                                  '${currentData!.magnitude.toStringAsFixed(2)}',
                                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                                ),
                                angle: 90,
                                positionFactor: 0.5,
                              )
                            ],
                          ),
                        ],
                      ),
      ),
    );
  }
}
