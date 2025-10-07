import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditStudentPage extends StatefulWidget {
  final String studentId;
  final Map<String, dynamic> studentData;

  const EditStudentPage(
      {super.key, required this.studentId, required this.studentData});

  @override
  State<EditStudentPage> createState() => _EditStudentPageState();
}

class _EditStudentPageState extends State<EditStudentPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController yearController = TextEditingController();

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    nameController.text = widget.studentData['nom'] ?? '';
    firstNameController.text = widget.studentData['prenom'] ?? '';
    emailController.text = widget.studentData['email'] ?? '';
    yearController.text = widget.studentData['annee'] ?? '';
  }

  Future<void> _updateStudent() async {
    setState(() => isLoading = true);

    try {
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(widget.studentId)
          .update({
        "nom": nameController.text.trim(),
        "prenom": firstNameController.text.trim(),
        "email": emailController.text.trim(),
        "annee": yearController.text.trim(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Étudiant mis à jour avec succès !")),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur: $e")),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Modifier étudiant"),
        backgroundColor: const Color(0xFF065464),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSimpleField("Nom", nameController),
            _buildSimpleField("Prénom", firstNameController),
            _buildSimpleField("Email", emailController),
            _buildSimpleField("Année", yearController),
            const SizedBox(height: 20),
            isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _updateStudent,
                    child: const Text("Mettre à jour"),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildSimpleField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        TextField(controller: controller),
        const SizedBox(height: 12),
      ],
    );
  }
}
