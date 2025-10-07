import 'package:dentaire/statemanagement/bloc/Cloudinary/cloudinaru_service.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dentaire/view/screens/teacher_screens/home_screen_teacher.dart';
import 'package:dentaire/view/screens/teacher_screens/settings_screen_teacher.dart';
import 'package:dentaire/view/screens/common_screens/profile_screen.dart';
import 'package:dentaire/view/screens/teacher_screens/ajouter_quiz.dart';
import 'package:dentaire/view/components/custom_navigation_bar_curved.dart';
import 'package:dentaire/view/components/navigation_item.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';

class AddVideoPage extends StatefulWidget {
  final String? initialTitle;
  final String? initialDescription;
  final String? videoId;
  final String? moduleName;
  final String? initialModule;

  const AddVideoPage({
    super.key,
    this.initialTitle,
    this.initialDescription,
    this.videoId,
    this.moduleName,
    this.initialModule,
  });

  @override
  State<AddVideoPage> createState() => _AddVideoPageState();
}

class _AddVideoPageState extends State<AddVideoPage> {
  int _currentIndex = 0;

  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _urlController;

  late String videoId; // ID unique de la vidéo
  String? _quizId; // ID du quiz associé
  List<Map<String, String>> _documents = [];

  bool _isLoading = false;
  static const mainColor = Color(0xFF0F5C77);

  @override
  void initState() {
    super.initState();

    // Génération de l'ID unique dès le départ
    videoId = widget.videoId ??
        FirebaseFirestore.instance.collection("videos").doc().id;

    _titleController = TextEditingController(text: widget.initialTitle ?? '');
    _descriptionController =
        TextEditingController(text: widget.initialDescription ?? '');
    _urlController = TextEditingController();
  }

  void _onNavBarTap(int index) {
    if (index == _currentIndex) return;
    setState(() => _currentIndex = index);

    switch (index) {
      case 0:
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (_) => const HomeScreenTeacher(selectedIndex: 0)));
        break;
      case 2:
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Stats en cours de développement.")));
        break;
      case 3:
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (_) => const SettingsScreenTeacher()));
        break;
      case 4:
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const ProfileScreen()));
        break;
    }
  }

  Future<void> _addDocumentFromUrl() async {
    final nameController = TextEditingController();
    final urlController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Ajouter un document"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Nom du document"),
            ),
            TextField(
              controller: urlController,
              decoration: const InputDecoration(labelText: "URL du document"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Annuler"),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty &&
                  urlController.text.isNotEmpty) {
                setState(() {
                  _documents.add({
                    "name": nameController.text,
                    "url": urlController.text,
                  });
                });
                Navigator.pop(context);
              }
            },
            child: const Text("Ajouter"),
          ),
        ],
      ),
    );
  }

  Future<void> _addQuiz() async {
    if (_titleController.text.isEmpty ||
        _urlController.text.isEmpty ||
        _descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Remplis d'abord les champs de la vidéo !")));
      return;
    }

    // Passer le videoId déjà généré
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => AddQuizPage(videoId: videoId)),
    );

    if (result == true) {
      setState(() {
        _quizId = videoId; // même ID pour la vidéo et le quiz
      });
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Quiz ajouté avec succès !")));
    }
  }

  Future<void> _saveVideo() async {
    if (_titleController.text.isEmpty ||
        _urlController.text.isEmpty ||
        _descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Veuillez remplir tous les champs")));
      return;
    }

    if (_quizId == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Ajoute un quiz avant d'enregistrer la vidéo !")));
      return;
    }

    setState(() => _isLoading = true);
    final firestore = FirebaseFirestore.instance;
    final User? currentUser = FirebaseAuth.instance.currentUser;

    try {
      // Sauvegarde de la vidéo avec le videoId fixe
      await firestore.collection("videos").doc(videoId).set({
        "videoid": videoId,
        "title": _titleController.text,
        "description": _descriptionController.text,
        "videoUrl": _urlController.text,
        "module": widget.moduleName ?? "Général",
        "quizId": _quizId,
        "likes": 0,
        "views": 0,
        "favorites": 0,
        "comments": 0,
        "documents": _documents,
        "createdAt": FieldValue.serverTimestamp(),
        "teacherId": currentUser?.uid, // ✅ l’UID de l’enseignant connecté
      });

      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Vidéo enregistrée avec succès !")));

      Navigator.pop(context, true); // Retour à la liste
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Erreur : $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.initialTitle != null;
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [Color(0xFF4F9CB2), Color(0xff065464)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context)),
                    Text(isEditing ? 'Modifier la vidéo' : 'Ajouter une vidéo',
                        style:
                            const TextStyle(color: Colors.white, fontSize: 18)),
                    const Icon(Icons.notifications_none, color: Colors.white),
                  ],
                ),
                const SizedBox(height: 16),
                TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                        hintText: 'Titre',
                        filled: true,
                        fillColor: Colors.white)),
                const SizedBox(height: 16),
                TextField(
                    controller: _urlController,
                    decoration: const InputDecoration(
                        hintText: 'URL de la vidéo',
                        filled: true,
                        fillColor: Colors.white)),
                const SizedBox(height: 16),
                Container(
                    height: 100,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8)),
                    child:
                        const Center(child: Icon(Icons.play_circle, size: 40))),
                const SizedBox(height: 16),
                TextField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                        hintText: 'Description',
                        filled: true,
                        fillColor: Colors.white),
                    maxLines: 3),
                const SizedBox(height: 16),

                // Boutons quiz et documents
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton.icon(
                      onPressed: _addQuiz,
                      icon: const Icon(Icons.quiz),
                      label: const Text("Ajouter Quiz"),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0f3a5f)),
                    ),
                    ElevatedButton.icon(
                      onPressed: _addDocumentFromUrl,
                      icon: const Icon(Icons.attach_file),
                      label: const Text("Ajouter Document"),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0f3a5f)),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Affichage documents
                if (_documents.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _documents
                        .map((doc) => Text(doc["name"] ?? "",
                            style: const TextStyle(color: Colors.white)))
                        .toList(),
                  ),

                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _saveVideo,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0f3a5f),
                      padding: const EdgeInsets.symmetric(vertical: 14)),
                  child: Text(
                      isEditing ? "Modifier la vidéo" : "Enregistrer la vidéo"),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomNavBarTheme.getNavigationBar(
        index: _currentIndex,
        onTap: _onNavBarTap,
        itemsList: const [
          NavItem(icon: Icons.home, label: "Accueil"),
          NavItem(icon: Icons.school_rounded, label: "Etudiants"),
          NavItem(icon: Icons.bar_chart, label: "Stats"),
          NavItem(icon: Icons.settings, label: "Param"),
          NavItem(icon: Icons.person, label: "Profil"),
        ],
      ),
    );
  }
}
