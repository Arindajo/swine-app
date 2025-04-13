import 'package:flutter/material.dart';

class ReportsAlertsPage extends StatelessWidget {
  // Example list of alerts; in a real app, this could be fetched from an API or local database.
  final List<Map<String, String>> alerts = [
    {
      "time": "10:30 AM",
      "message": "Pig A temperature is above normal",
    },
    {
      "time": "11:00 AM",
      "message": "Pig B activity is lower than expected",
    },
    {
      "time": "11:45 AM",
      "message": "Pig C breathing rate is irregular",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Reports & Alerts"),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Reports Section
              Text(
                "Reports",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    "Chart/Graph Placeholder",
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                ),
              ),

              SizedBox(height: 20),

              // Alerts Section
              Text(
                "Alerts",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),

              // List of Alerts
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: alerts.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 3,
                    margin: EdgeInsets.symmetric(vertical: 5),
                    child: ListTile(
                      leading: Icon(Icons.warning, color: Colors.blue),
                      title: Text(alerts[index]["message"]!),
                      subtitle: Text(alerts[index]["time"]!),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
