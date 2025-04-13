import 'package:flutter/material.dart';

class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Swine-Health Dashboard"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DashboardCard(
  title: "Local Weather",
  value: "29°C • Humid",
  icon: Icons.cloud,
  color: Colors.blueGrey,
),

            DashboardCard(
              title: "Average Temperature",
              value: "38.5°C",
              icon: Icons.thermostat,
              color: Colors.blue,
            ),
            DashboardCard(
              title: "Activity Level",
              value: "Moderate",
              icon: Icons.analytics,
              color: Colors.blue,
            ),
            DashboardCard(
              title: "Number of Pigs",
              value: "20",
              icon: Icons.calculate,
              color: Colors.blue,
            ),
            DashboardCard(
              title: "Growth Progress",
              value: "75% of Target",
              icon: Icons.bar_chart,
              color: Colors.orange,
            ),
          ],
        ),
      ),
      
        
        
      
    );
  }
}

class DashboardCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const DashboardCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(icon, color: color, size: 40),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(value, style: TextStyle(fontSize: 18)),
      ),
    );
  }
}
