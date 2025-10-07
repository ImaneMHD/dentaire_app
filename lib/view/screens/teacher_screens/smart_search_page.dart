import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SmartSearchPage extends StatefulWidget {
  const SmartSearchPage({super.key});

  @override
  State<SmartSearchPage> createState() => _SmartSearchPageState();
}

class _SmartSearchPageState extends State<SmartSearchPage> {
  String query = "";
  List<Map<String, dynamic>> searchResults = [];
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  void _onSearchChanged(String text) {
    setState(() => query = text);
    _searchFirestore(query);
  }

  Future<void> _searchFirestore(String query) async {
    if (query.isEmpty) {
      setState(() => searchResults = []);
      return;
    }

    final results = <Map<String, dynamic>>[];

    // 🔹 Rechercher vidéos
    final videosSnap = await _db.collection('Videos').get();
    for (var doc in videosSnap.docs) {
      if ((doc['title'] as String)
          .toLowerCase()
          .contains(query.toLowerCase())) {
        results.add({'type': 'Vidéo', 'name': doc['title'], 'doc': doc});
      }
    }

    // 🔹 Rechercher modules
    final modulesSnap = await _db.collection('Modules').get();
    for (var doc in modulesSnap.docs) {
      if ((doc['nom'] as String).toLowerCase().contains(query.toLowerCase())) {
        results.add({'type': 'Module', 'name': doc['nom'], 'doc': doc});
      }
    }

    // 🔹 Rechercher étudiants
    final studentsSnap =
        await _db.collection('Users').where('role', isEqualTo: 'student').get();
    for (var doc in studentsSnap.docs) {
      if ((doc['fullName'] as String)
          .toLowerCase()
          .contains(query.toLowerCase())) {
        results.add({'type': 'Étudiant', 'name': doc['fullName'], 'doc': doc});
      }
    }

    setState(() => searchResults = results);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Recherche intelligente"),
        backgroundColor: const Color(0xFF0f3a5f),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            // 🔹 Champ de recherche simple
            TextField(
              decoration: InputDecoration(
                hintText: "Rechercher vidéos, modules ou étudiants...",
                prefixIcon: const Icon(Icons.search),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onChanged: _onSearchChanged,
            ),
            const SizedBox(height: 12),

            // 🔹 Résultats de recherche en direct
            Expanded(
              child: searchResults.isEmpty
                  ? const Center(child: Text("Aucun résultat"))
                  : ListView.builder(
                      itemCount: searchResults.length,
                      itemBuilder: (_, index) {
                        final item = searchResults[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          child: ListTile(
                            leading: Icon(
                              item['type'] == "Vidéo"
                                  ? Icons.play_circle_fill
                                  : item['type'] == "Module"
                                      ? Icons.book
                                      : Icons.person,
                              color: Colors.blueGrey,
                            ),
                            title: Text(item['name']),
                            subtitle: Text(item['type']),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
