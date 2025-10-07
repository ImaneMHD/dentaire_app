import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EvaluationAppScreen extends StatefulWidget {
  const EvaluationAppScreen({super.key});

  @override
  State<EvaluationAppScreen> createState() => _EvaluationAppScreenState();
}

class _EvaluationAppScreenState extends State<EvaluationAppScreen> {
  double _rating = 0;
  final TextEditingController _commentController = TextEditingController();
  bool _isSubmitting = false;
  String? _userRole;

  @override
  void initState() {
    super.initState();
    _fetchUserRole();
  }

  // 🔹 Récupère le rôle de l'utilisateur connecté depuis Firestore
  Future<void> _fetchUserRole() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(user.uid)
          .get();
      setState(() {
        _userRole = doc.data()?['role'] ?? 'etudiant'; // Valeur par défaut
      });
    }
  }

  // 🔹 Soumet l’évaluation dans Firestore
  Future<void> _submitEvaluation() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Veuillez vous connecter d'abord.")),
      );
      return;
    }

    if (_rating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Veuillez donner une note.")),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    await FirebaseFirestore.instance.collection('Evaluations').add({
      'userId': user.uid,
      'userEmail': user.email,
      'userRole': _userRole ?? 'etudiant',
      'rating': _rating,
      'comment': _commentController.text.trim(),
      'createdAt': FieldValue.serverTimestamp(),
    });

    setState(() {
      _isSubmitting = false;
      _rating = 0;
      _commentController.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Merci pour votre évaluation 💙")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Évaluer l'application"),
        backgroundColor: const Color(0xff065464),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              "Donnez votre avis sur DentSmart",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // ⭐ Sélection d’étoiles
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                final starIndex = index + 1;
                return IconButton(
                  icon: Icon(
                    Icons.star,
                    color: _rating >= starIndex ? Colors.amber : Colors.grey,
                    size: 36,
                  ),
                  onPressed: () {
                    setState(() => _rating = starIndex.toDouble());
                  },
                );
              }),
            ),

            const SizedBox(height: 20),

            // 💬 Commentaire
            TextField(
              controller: _commentController,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: "Votre commentaire (facultatif)",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 25),

            // 📨 Bouton d’envoi
            ElevatedButton.icon(
              onPressed: _isSubmitting ? null : _submitEvaluation,
              icon: const Icon(Icons.send),
              label: _isSubmitting
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Envoyer"),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff065464),
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
