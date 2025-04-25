import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'report_serv.dart';
import 'report_model.dart';

class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key});

  Color _activityColor(String activity) {
    switch (activity.toLowerCase()) {
      case 'high activity':
        return Colors.green;
      case 'moderate activity':
        return Colors.orange;
      case 'low activity':
      default:
        return Colors.red;
    }
  }

  IconData _activityIcon(String activity) {
    switch (activity.toLowerCase()) {
      case 'high activity':
        return Icons.directions_run;
      case 'moderate activity':
        return Icons.directions_walk;
      case 'low activity':
      default:
        return Icons.bedtime;
    }
  }

  List<FlSpot> _buildTemperatureData(List<Report> reports) {
    final spots = <FlSpot>[];
    for (int i = 0; i < reports.length; i++) {
      final report = reports[i];
      spots.add(FlSpot(i.toDouble(), report.temperature));
    }
    return spots;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pig Health Reports")),
      body: FutureBuilder<List<Report>>(
        future: ReportService.fetchReports(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No reports found."));
          }

          final reports = snapshot.data!;
          final temperatureData = _buildTemperatureData(reports);

          return ListView(
            padding: const EdgeInsets.all(8),
            children: [
              const Text(
                "Temperature Trend",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(
                height: 200,
                child: LineChart(
                  LineChartData(
                    titlesData: FlTitlesData(show: false),
                    borderData: FlBorderData(show: false),
                    lineBarsData: [
                      LineChartBarData(
                        spots: temperatureData,
                        isCurved: true,
                        barWidth: 3,
                        color:Colors.blue,
                        dotData: FlDotData(show: false),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ...reports.map((report) {
                final activity = report.activityLevel;
                final temperature = report.temperature.toString();

                return Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: CircleAvatar(
                      backgroundColor: _activityColor(activity),
                      child: Icon(_activityIcon(activity), color: Colors.white),
                    ),
                    title: Text(
                      report.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.thermostat, size: 16),
                            const SizedBox(width: 4),
                            Text("Temperature: $temperature °C"),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.insights, size: 16),
                            const SizedBox(width: 4),
                            Text("Activity Level: $activity"),
                          ],
                        ),
                      ],
                    ),
                    trailing: Text(
                      report.createdAt.toLocal().toString().split('.')[0],
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                );
              }).toList()
            ],
          );
        },
      ),
    );
  }
}
