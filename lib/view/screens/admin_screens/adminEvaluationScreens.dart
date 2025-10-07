import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminEvaluationsScreen extends StatefulWidget {
  const AdminEvaluationsScreen({super.key});

  @override
  State<AdminEvaluationsScreen> createState() => _AdminEvaluationsScreenState();
}

class _AdminEvaluationsScreenState extends State<AdminEvaluationsScreen> {
  String _selectedRole = 'tous'; // Filtre par défaut

  @override
  Widget build(BuildContext context) {
    final query = _selectedRole == 'tous'
        ? FirebaseFirestore.instance
            .collection('app_evaluations')
            .orderBy('createdAt', descending: true)
        : FirebaseFirestore.instance
            .collection('app_evaluations')
            .where('userRole', isEqualTo: _selectedRole)
            .orderBy('createdAt', descending: true);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Évaluations de l'application"),
        backgroundColor: const Color(0xff065464),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) => setState(() => _selectedRole = value),
            itemBuilder: (context) => const [
              PopupMenuItem(value: 'tous', child: Text("Tous les rôles")),
              PopupMenuItem(value: 'etudiant', child: Text("Étudiants")),
              PopupMenuItem(value: 'enseignant', child: Text("Enseignants")),
            ],
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: query.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Erreur : ${snapshot.error}"));
          }

          final docs = snapshot.data?.docs ?? [];
          if (docs.isEmpty) {
            return const Center(child: Text("Aucune évaluation trouvée."));
          }

          double totalRating = 0;
          for (var doc in docs) {
            totalRating += (doc['rating'] ?? 0).toDouble();
          }
          double average = totalRating / docs.length;

          return Column(
            children: [
              Container(
                color: const Color(0xff065464),
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "⭐ Moyenne : ${average.toStringAsFixed(1)}/5",
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "${docs.length} avis",
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final data = docs[index].data() as Map<String, dynamic>;
                    return ListTile(
                      leading: Icon(Icons.star, color: Colors.amber[600]),
                      title: Text(
                        "${data['userEmail'] ?? 'Utilisateur inconnu'}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        data['comment'] ?? "Aucun commentaire",
                        style: const TextStyle(color: Colors.black54),
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("${data['rating']} ⭐"),
                          Text(
                            data['userRole'] ?? '',
                            style: const TextStyle(
                                fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
