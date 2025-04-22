import 'package:flutter/material.dart';
import 'pig_authservice.dart'; // 
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'pig_authservice.dart';
import 'not.dart'; // Add this import

class PigsPage extends StatefulWidget {
  @override
  _PigsPageState createState() => _PigsPageState();
}

class _PigsPageState extends State<PigsPage> {
  List<Map<String, dynamic>> pigs = [];
  List<Map<String, dynamic>> filteredPigs = [];
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadPigs();
    _searchController.addListener(_filterPigs);
  }

  Future<void> _loadPigs() async {
    final token = await getToken();
    try {
      final fetchedPigs = await PigService().fetchPigs(token);
      setState(() {
        pigs = fetchedPigs;
        filteredPigs = fetchedPigs;
      });
    } catch (e) {
      print("Error fetching pigs: $e");
    }
  }

  Future<void> _addPig() async {
  final _nameController = TextEditingController();
  final _breedController = TextEditingController();
  final _genderController = TextEditingController();
  final _dobController = TextEditingController();
  final _weightController = TextEditingController();
  final _healthController = TextEditingController();
  final _notesController = TextEditingController();

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text("Add New Pig"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(controller: _nameController, decoration: InputDecoration(labelText: "Name")),
              TextField(controller: _breedController, decoration: InputDecoration(labelText: "Breed")),
              TextField(controller: _genderController, decoration: InputDecoration(labelText: "Gender")),
              TextField(controller: _dobController, decoration: InputDecoration(labelText: "Date of Birth (YYYY-MM-DD)")),
              TextField(controller: _weightController, decoration: InputDecoration(labelText: "Weight (kg)")),
              TextField(controller: _healthController, decoration: InputDecoration(labelText: "Health Status")),
              TextField(controller: _notesController, decoration: InputDecoration(labelText: "Notes")),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              final token = await getToken();
              final pigData = {
                "name": _nameController.text,
                "breed": _breedController.text,
                "gender": _genderController.text,
                "date_of_birth": _dobController.text,
                "weight": double.tryParse(_weightController.text) ?? 0.0,
                "health_status": _healthController.text,
                "notes": _notesController.text,
              };

              try {
                await PigService().addPig(pigData, token);
                await _loadPigs(); // refresh
                Navigator.pop(context);
              } catch (e) {
                print("Error adding pig: $e");
              }
            },
            child: Text("Add"),
          )
        ],
      );
    },
  );
}

  void _deletePig(int index) async {
  final token = await getToken();
  final pigId = pigs[index]['id'];

  try {
    await PigService().deletePig(pigId, token);
    setState(() {
      pigs.removeAt(index);
      _filterPigs();
    });
  } catch (e) {
    print("Error deleting pig: $e");
  }
}


  void _filterPigs() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredPigs = pigs.where((pig) {
        final name = pig['name'].toString().toLowerCase();
        return name.contains(query);
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: "Search pigs...",
            labelText: 'Search',
            prefixIcon: Icon(Icons.search),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
          ),
        ),
      ),
      body: filteredPigs.isEmpty
          ? Center(child: Text("No pigs available."))
          : ListView.builder(
              itemCount: filteredPigs.length,
              itemBuilder: (context, index) {
                final pig = filteredPigs[index];
                return Dismissible(
                  key: Key(pig["id"].toString()),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    color: Colors.red,
                    child: Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (_) => _deletePig(index),
                  child: Card(
                    elevation: 4,
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: ListTile(
                      leading: Icon(Icons.pets, color: Colors.brown),
                      title: Text(pig["name"], style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text("Health: ${pig["health_status"]}"),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deletePig(index),
                          ),
                          Icon(Icons.arrow_forward_ios),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PigDetailsPage(pig: pig),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addPig,
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }
}



class PigDetailsPage extends StatefulWidget {
  final Map<String, dynamic> pig;

  PigDetailsPage({required this.pig});

  @override
  _PigDetailsPageState createState() => _PigDetailsPageState();
}

class _PigDetailsPageState extends State<PigDetailsPage> {
  Timer? _timer;
  double temperature = 0.0;
  double activityMagnitude = 0.0;
  String activityLevel = "Loading...";
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _fetchSensorData();
    _timer = Timer.periodic(Duration(seconds: 5), (_) => _fetchSensorData());
  }

Future<void> _fetchSensorData() async {
  try {
    final pigId = widget.pig['id']; // Add this if not already available
    final response = await http.get(
      Uri.parse('http://30.30.196.64:8000/api/sensordata/$pigId/'),
      headers: {
        'Authorization': "Token ${await getToken()}",
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final newActivityMagnitude = data['magnitude']?.toDouble() ?? 0.0;
      final newActivityLevel = data['activity_level'] ?? "Unknown";
      final newTemperature = data['temperature']?.toDouble() ?? 0.0;

      if (newActivityLevel == "High Activity") {
        await showNotification(
          title: "⚠️ High Activity Alert",
          body: "${widget.pig['name']} is very active. Check for abnormal behavior.",
        );
      }

      if (newTemperature > 39.0) {
        await showNotification(
          title: "🌡️ High Temperature Alert",
          body: "${widget.pig['name']} has a temperature of ${newTemperature.toStringAsFixed(1)} °C",
        );
      }

      setState(() {
        activityMagnitude = newActivityMagnitude;
        activityLevel = newActivityLevel;
        temperature = newTemperature;
        isLoading = false;
        error = null;
      });
    } else {
      throw Exception('Failed to load sensor data');
    }
  } catch (e) {
    setState(() {
      error = e.toString();
      isLoading = false;
    });
  }
}


  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
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
  Widget build(BuildContext context) {
    final pig = widget.pig;

    return Scaffold(
      appBar: AppBar(
        title: Text(pig['name']),
        backgroundColor: Colors.blue,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : error != null
              ? Center(child: Text("Error: $error"))
              : SingleChildScrollView(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SfRadialGauge(
                        title: GaugeTitle(
                          text:
                              '$activityLevel (${activityMagnitude.toStringAsFixed(2)})',
                          textStyle: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: getActivityColor(activityLevel),
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
                              NeedlePointer(value: activityMagnitude),
                            ],
                            annotations: <GaugeAnnotation>[
                              GaugeAnnotation(
                                widget: Text(
                                  '${activityMagnitude.toStringAsFixed(2)}',
                                  style: TextStyle(
                                      fontSize: 25, fontWeight: FontWeight.bold),
                                ),
                                angle: 90,
                                positionFactor: 0.5,
                              )
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 24),
                      Card(
                        elevation: 4,
                        shape:
                            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: ListTile(
                          leading: Icon(Icons.thermostat, color: Colors.redAccent),
                          title: Text("Temperature"),
                          subtitle: Text(
                            "${temperature.toStringAsFixed(1)} °C",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      Card(
                        elevation: 4,
                        shape:
                            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: ListTile(
                          leading: Icon(Icons.info_outline, color: Colors.brown),
                          title: Text("Breed"),
                          subtitle: Text(pig['breed']),
                        ),
                      ),
                      SizedBox(height: 16),
                      Card(
                        elevation: 4,
                        shape:
                            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: ListTile(
                          leading: Icon(Icons.health_and_safety, color: Colors.green),
                          title: Text("Health Status"),
                          subtitle: Text(pig['health_status']),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}

// Helper method to get token (can be moved to a separate file)
Future<String> getToken() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('token') ?? '';
}
