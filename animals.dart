import 'package:flutter/material.dart';
import 'pig_authservice.dart'; // 
import 'package:shared_preferences/shared_preferences.dart';

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
    showDialog(
      context: context,
      builder: (context) {
        final _nameController = TextEditingController();
        return AlertDialog(
          title: Text("Add New Pig"),
          content: TextField(
            controller: _nameController,
            decoration: InputDecoration(hintText: "Enter pig name"),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                if (_nameController.text.isNotEmpty) {
                  final token = await getToken();
                  await PigService().addPig(_nameController.text, token);

                  await _loadPigs(); // reload pigs from backend
                  Navigator.pop(context);
                }
              },
              child: Text("Add"),
            )
          ],
        );
      },
    );
  }

  void _deletePig(int index) {
    setState(() {
      pigs.removeAt(index);
      _filterPigs();
    });
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

class PigDetailsPage extends StatelessWidget {
  final Map<String, dynamic> pig;

  PigDetailsPage({required this.pig});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pig["name"]),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("🐖 ID: ${pig["id"]}", style: TextStyle(fontSize: 18)),
            Text("🌡️ Temperature: ${pig["temperature"]}", style: TextStyle(fontSize: 18)),
            Text("⚡ Activity: ${pig["activity"]}", style: TextStyle(fontSize: 18)),
            Text("📈 Growth: ${pig["growth"]}", style: TextStyle(fontSize: 18)),
            Text("❤️ Health Status: ${pig["health_status"]}", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
