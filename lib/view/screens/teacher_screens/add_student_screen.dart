import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddStudentPage extends StatefulWidget {
  const AddStudentPage({super.key});

  @override
  State<AddStudentPage> createState() => _AddStudentPageState();
}

class _AddStudentPageState extends State<AddStudentPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController yearController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String _errorMessage = '';

  @override
  void dispose() {
    nameController.dispose();
    firstNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    yearController.dispose();
    super.dispose();
  }

  Future<void> _addStudent() async {
    // validation simple du formulaire
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      // 1) Créer l'utilisateur dans Firebase Auth en utilisant l'email et le mot de passe
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      final uid = credential.user!.uid;

      // 2) Sauvegarder le document dans Firestore
      final userDoc = {
        "uid": uid,
        "name":
            "${nameController.text.trim()} ${firstNameController.text.trim()}",
        "email": emailController.text.trim(),
        "annee": yearController.text.trim(),
        "role": "etudiant",
        // Lier à l'enseignant connecté
        "teacherId": FirebaseAuth.instance.currentUser?.uid ?? "",
        "createdAt": FieldValue.serverTimestamp(),
      };

      await FirebaseFirestore.instance
          .collection("Users")
          .doc(uid)
          .set(userDoc);
      await FirebaseFirestore.instance
          .collection("Etudiants")
          .doc(uid)
          .set(userDoc);

      // Succès : retourne true pour indiquer au parent que l'ajout s'est bien passé
      if (mounted) Navigator.pop(context, true);
    } on FirebaseAuthException catch (e) {
      // Gestion des erreurs d'authentification
      String msg = "Erreur d'authentification: ${e.message}";
      if (e.code == 'weak-password') {
        msg = "Le mot de passe est trop faible (min 6 caractères).";
      } else if (e.code == 'email-already-in-use') {
        msg = "Ce courriel est déjà utilisé.";
      } else if (e.code == 'invalid-email') {
        msg = "Adresse e-mail invalide.";
      }
      setState(() => _errorMessage = msg);
    } catch (e) {
      // Erreur générale
      try {
        // Tenter de supprimer l'utilisateur Auth si l'écriture Firestore a échoué
        final current = FirebaseAuth.instance.currentUser;
        if (current != null) {
          await current.delete();
        }
      } catch (_) {
        // ignore - suppression échouée
      }
      setState(() => _errorMessage = "Erreur lors de l'ajout: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  String? _validateNotEmpty(String? v) {
    if (v == null || v.trim().isEmpty) return "Champ requis";
    return null;
  }

  String? _validateEmail(String? v) {
    if (v == null || v.trim().isEmpty) return "Champ requis";
    if (!v.contains('@') || !v.contains('.')) return "Email invalide";
    return null;
  }

  String? _validatePassword(String? v) {
    if (v == null || v.isEmpty) return "Champ requis";
    if (v.length < 6) return "Mot de passe trop court (min 6 caractères)";
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ajouter un étudiant"),
        backgroundColor: const Color(0xFF1A6175),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Nom
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                      labelText: "Nom", border: OutlineInputBorder()),
                  validator: _validateNotEmpty,
                ),
                const SizedBox(height: 12),

                // Prénom
                TextFormField(
                  controller: firstNameController,
                  decoration: const InputDecoration(
                      labelText: "Prénom", border: OutlineInputBorder()),
                  validator: _validateNotEmpty,
                ),
                const SizedBox(height: 12),

                // Email
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                      labelText: "Email", border: OutlineInputBorder()),
                  keyboardType: TextInputType.emailAddress,
                  validator: _validateEmail,
                ),
                const SizedBox(height: 12),

                // Mot de passe (NOUVEAU CHAMP AJOUTÉ)
                TextFormField(
                  controller: passwordController,
                  decoration: const InputDecoration(
                      labelText: "Mot de passe", border: OutlineInputBorder()),
                  obscureText: true,
                  validator: _validatePassword,
                ),
                const SizedBox(height: 12),

                // Année
                TextFormField(
                  controller: yearController,
                  decoration: const InputDecoration(
                      labelText: "Année", border: OutlineInputBorder()),
                  validator: _validateNotEmpty,
                ),
                const SizedBox(height: 20),

                if (_errorMessage.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(_errorMessage,
                        style: const TextStyle(color: Colors.red)),
                  ),

                _isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _addStudent,
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                          backgroundColor: const Color(0xFF1A6175),
                        ),
                        child: const Text("Ajouter",
                            style: TextStyle(fontSize: 18)),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
