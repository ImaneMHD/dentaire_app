import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dentaire/data/models/videoWithQuiz.dart';
import 'package:dentaire/view/components/custom_navigation_bar_curved.dart';
import 'package:dentaire/view/components/navigation_item.dart';
import 'package:dentaire/view/screens/teacher_screens/home_screen_teacher.dart';

class VideoDetailWithQuizScreen extends StatefulWidget {
  final String videoId;
  final String videoTitle;
  final String moduleName;

  const VideoDetailWithQuizScreen({
    super.key,
    required this.videoId,
    required this.videoTitle,
    required this.moduleName,
  });

  @override
  State<VideoDetailWithQuizScreen> createState() =>
      _VideoDetailWithQuizScreenState();
}

class _VideoDetailWithQuizScreenState extends State<VideoDetailWithQuizScreen> {
  int _currentIndex = 0;
  VideoWithQuiz? _video;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadVideo();
  }

  /// 🔹 Charge la vidéo + quiz depuis Firestore
  Future<void> _loadVideo() async {
    final doc = await FirebaseFirestore.instance
        .collection("videos")
        .doc(widget.videoId)
        .get();

    if (!doc.exists) return;

    final data = doc.data()!;
    final quizId = data['quizId'] as String?;

    List<QuizQuestion> questions = [];
    if (quizId != null) {
      final quizSnapshot = await FirebaseFirestore.instance
          .collection("quizzes")
          .doc(quizId)
          .collection("questions")
          .get();

      questions = quizSnapshot.docs.map((q) {
        final qData = q.data();
        return QuizQuestion(
          question: qData['question'] ?? '',
          options: List<String>.from(qData['options'] ?? []),
          correctOptionIndex: qData['correctIndex'] ?? 0,
        );
      }).toList();
    }

    setState(() {
      _video = VideoWithQuiz(
        id: widget.videoId,
        title: data['title'] ?? '',
        description: data['description'] ?? '',
        videoUrl: data['videoUrl'] ?? '',
        module: data['module'] ?? '',
        files:
            List<String>.from(data['documents']?.map((d) => d['name']) ?? []),
        quiz: questions,
      );
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final video = _video!;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff065464),
        title: Text(widget.videoTitle,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF4F9CB2), Color(0xff065464)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Aperçu vidéo
            Container(
              width: double.infinity,
              height: 220,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Center(
                child:
                    Icon(Icons.play_circle_fill, size: 80, color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),

            // Description
            _buildSectionTitle("📄 Description"),
            const SizedBox(height: 8),
            _buildCard(
              child: Text(video.description,
                  style: const TextStyle(color: Colors.black, fontSize: 16)),
            ),

            const SizedBox(height: 20),

            // Fichiers
            _buildSectionTitle("📁 Fichiers"),
            const SizedBox(height: 8),
            if (video.files.isEmpty)
              const Text("Aucun fichier ajouté",
                  style: TextStyle(color: Colors.white70))
            else
              ...video.files.map(
                (file) => _buildCard(
                  child: ListTile(
                    leading: const Icon(Icons.folder, color: Colors.black),
                    title: Text(file,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500)),
                    trailing: IconButton(
                      icon: const Icon(Icons.download, color: Colors.black),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Téléchargement de $file...')),
                        );
                      },
                    ),
                  ),
                ),
              ),

            const SizedBox(height: 20),

            // Quiz
            _buildSectionTitle("❓ Quiz"),
            const SizedBox(height: 8),
            if (video.quiz.isEmpty)
              const Text("Aucune question pour ce quiz",
                  style: TextStyle(color: Colors.white70))
            else
              ...video.quiz.map((q) => _buildCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          q.question,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        ...q.options.map((opt) => Padding(
                              padding: const EdgeInsets.only(bottom: 6),
                              child: Row(
                                children: [
                                  const Icon(Icons.circle_outlined,
                                      size: 16, color: Colors.grey),
                                  const SizedBox(width: 8),
                                  Text(opt,
                                      style: const TextStyle(fontSize: 14)),
                                ],
                              ),
                            )),
                      ],
                    ),
                  )),
          ],
        ),
      ),
      bottomNavigationBar: CustomNavBarTheme.getNavigationBar(
        index: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => HomeScreenTeacher(selectedIndex: index),
            ),
          );
        },
        itemsList: const [
          NavItem(icon: Icons.home, label: "Accueil"),
          NavItem(icon: Icons.school_rounded, label: "Etudiants"),
          NavItem(icon: Icons.bar_chart, label: "Stats"),
          NavItem(icon: Icons.settings, label: "Paramètres"),
          NavItem(icon: Icons.person, label: "Profil"),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFD9D9D9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: child,
    );
  }
}
