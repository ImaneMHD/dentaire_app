import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dentaire/view/screens/teacher_screens/add_student_screen.dart';
import 'package:dentaire/view/screens/teacher_screens/home_screen_teacher.dart';
import 'package:flutter/material.dart';
import 'package:dentaire/view/components/custom_navigation_bar_curved.dart';
import 'package:dentaire/view/components/navigation_item.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ListEtudiantsPage extends StatefulWidget {
  const ListEtudiantsPage({super.key});

  @override
  State<ListEtudiantsPage> createState() => _ListEtudiantsPageState();
}

class _ListEtudiantsPageState extends State<ListEtudiantsPage> {
  int _currentIndex = 1;

  Key _streamBuilderKey = UniqueKey();
  bool _isStreamBuilderVisible = true;

  void _forceRefresh() {
    setState(() {
      _isStreamBuilderVisible = false;
    });
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          _streamBuilderKey = UniqueKey();
          _isStreamBuilderVisible = true;
        });
      }
    });
  }

  String _formatError(Object? error) {
    String errorString = error.toString();
    if (errorString.contains('PERMISSION_DENIED')) {
      return "Erreur de permission. Vérifiez vos règles Firestore.";
    }
    return "Erreur : $errorString";
  }

  String _getStudentName(Map<String, dynamic> data) {
    if (data.containsKey("name") &&
        data["name"] != null &&
        data["name"].toString().isNotEmpty) {
      return data["name"];
    } else if (data.containsKey("nom") && data.containsKey("prenom")) {
      return "${data['nom']} ${data['prenom']}";
    }
    return "Nom inconnu";
  }

  Future<void> _deleteStudent(
      String studentId, String? userId, BuildContext context) async {
    final firestore = FirebaseFirestore.instance;

    try {
      // 1. Supprimer de la collection Etudiants
      await firestore.collection("Etudiants").doc(studentId).delete();

      // 2. Supprimer aussi de la collection Users si userId existe
      if (userId != null && userId.isNotEmpty) {
        await firestore.collection("Users").doc(userId).delete();
      }

      // 3. (Optionnel) supprimer aussi du Firebase Auth via Cloud Function

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Étudiant supprimé avec succès")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur lors de la suppression: $e")),
      );
    }
  }

  void _confirmDelete(String studentId, String? userId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirmer la suppression"),
        content: const Text(
            "Voulez-vous supprimer et désactiver définitivement ce compte étudiant ?"),
        actions: [
          TextButton(
            child: const Text("Annuler"),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Oui, supprimer"),
            onPressed: () {
              Navigator.pop(context); // Fermer la boîte
              _deleteStudent(studentId, userId, context);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentTeacherId = FirebaseAuth.instance.currentUser?.uid;
    if (currentTeacherId == null) {
      return const Scaffold(
        body: Center(
          child: Text(
            "Erreur d'authentification: ID enseignant introuvable.",
            style: TextStyle(color: Colors.red),
          ),
        ),
      );
    }

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF4F9CB2), Color(0xff065464)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // 🔹 Header
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        Navigator.pop(context, 0);
                      },
                    ),
                    const SizedBox(width: 5),
                    const Text(
                      "Liste des étudiants",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.person_add, color: Colors.white),
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const AddStudentPage()),
                        );
                        _forceRefresh();
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              // 🔹 Liste des étudiants
              Expanded(
                child: _isStreamBuilderVisible
                    ? StreamBuilder<QuerySnapshot>(
                        key: _streamBuilderKey,
                        stream: FirebaseFirestore.instance
                            .collection("Etudiants")
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(
                                  color: Colors.white),
                            );
                          }
                          if (snapshot.hasError) {
                            return Center(
                              child: Text(
                                _formatError(snapshot.error),
                                style: const TextStyle(color: Colors.red),
                              ),
                            );
                          }
                          if (!snapshot.hasData ||
                              snapshot.data!.docs.isEmpty) {
                            return const Center(
                              child: Text(
                                "Aucun étudiant assigné à vous.",
                                style: TextStyle(
                                    color: Colors.white70, fontSize: 18),
                              ),
                            );
                          }

                          final etudiants = snapshot.data!.docs;

                          return ListView.separated(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: etudiants.length,
                            separatorBuilder: (context, index) => const Divider(
                              color: Colors.white70,
                              thickness: 0.5,
                            ),
                            itemBuilder: (context, index) {
                              final doc = etudiants[index];
                              final data = doc.data() as Map<String, dynamic>;
                              final studentName = _getStudentName(data);
                              final studentAnnee =
                                  data["annee"] ?? "Année non définie";
                              final userId = data["userId"];

                              return ListTile(
                                leading: CircleAvatar(
                                  backgroundColor:
                                      const Color(0xFF1A6175).withOpacity(0.1),
                                  child: const Icon(Icons.person,
                                      color: Color(0xFF1A6175)),
                                ),
                                title: Text(
                                  studentName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
                                subtitle: Text(
                                  "Année: $studentAnnee",
                                  style: TextStyle(color: Colors.grey[200]),
                                ),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.black),
                                  onPressed: () =>
                                      _confirmDelete(doc.id, userId),
                                ),
                              );
                            },
                          );
                        },
                      )
                    : const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomNavBarTheme.getNavigationBar(
        index: _currentIndex,
        onTap: (index) {
          if (index != 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => HomeScreenTeacher(selectedIndex: index),
              ),
            );
          }
          setState(() => _currentIndex = index);
        },
        itemsList: const [
          NavItem(icon: Icons.home, label: "Accueil"),
          NavItem(icon: Icons.school_rounded, label: "Etudiants"),
          NavItem(icon: Icons.bar_chart, label: "Stats"),
          NavItem(icon: Icons.settings, label: "Param"),
          NavItem(icon: Icons.person, label: "Profile"),
        ],
      ),
    );
  }
}
