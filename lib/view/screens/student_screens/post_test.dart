import 'package:dentaire/view/screens/student_screens/video_lecture_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dentaire/view/screens/student_screens/videos_list_screen.dart';

class PostQuizScreen extends StatefulWidget {
  final String videoTitle;
  final String moduleName;
  final dynamic video;

  const PostQuizScreen({
    Key? key,
    required this.videoTitle,
    required this.moduleName,
    required this.video,
  }) : super(key: key);

  @override
  _PostQuizScreenState createState() => _PostQuizScreenState();
}

class _PostQuizScreenState extends State<PostQuizScreen> {
  List<Map<String, dynamic>> questions = [];
  List<int?> selectedOptions = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchQuiz();
  }

  /// 🔹 Charger les questions du quiz Firestore
  Future<void> _fetchQuiz() async {
    try {
      final quizRef = FirebaseFirestore.instance
          .collection('quizzes')
          .doc(widget.video['videoid']); // ⚠️ attention au bon champ !

      final questionsSnapshot = await quizRef.collection('questions').get();

      if (questionsSnapshot.docs.isEmpty) {
        setState(() {
          questions = [];
          isLoading = false;
        });
        return;
      }

      final data = questionsSnapshot.docs.map((doc) => doc.data()).toList();

      setState(() {
        questions = List<Map<String, dynamic>>.from(data);
        selectedOptions = List.filled(questions.length, null);
        isLoading = false;
      });
    } catch (e) {
      print('Erreur chargement quiz: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  /// 🔹 Soumettre les réponses
  Future<void> _submitQuiz() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    // Vérifie que toutes les questions ont une réponse

    // Créer la liste des réponses
    final responses = List.generate(
      questions.length,
      (index) => {
        'question': questions[index]['question'],
        'selectedOption': selectedOptions[index],
        'correctOption': questions[index]['correctOptionIndex'],
      },
    );

    // Enregistrer dans Firestore
    await FirebaseFirestore.instance.collection('QuizResultat').add({
      'userId': user.uid,
      'videoId': widget.video['id'],
      'videoTitle': widget.videoTitle,
      'moduleName': widget.moduleName,
      'quizType': 'post-test',
      'responses': responses,
      'timestamp': FieldValue.serverTimestamp(),
    });

    // ✅ Retour à la vidéo
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => VideoListScreen(moduleName: widget.moduleName),
        //VideoPlayerScreen(
        //videoTitle: widget.videoTitle,
        // moduleName: widget.moduleName,
        // video: widget.video,
        //),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const mainColor = Color(0xFF0F5C77);

    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: mainColor,
          title: Text(widget.videoTitle),
        ),
        body: const Center(
          child: Text("Aucun quiz post-test disponible pour cette vidéo."),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainColor,
        title: Text(widget.videoTitle),
      ),
      backgroundColor: const Color(0xffD9D9D9),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: questions.length,
                itemBuilder: (context, qIndex) {
                  final question = questions[qIndex];
                  final options = List<String>.from(question['options'] ?? []);

                  return Card(
                    color: mainColor,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Question ${qIndex + 1}:",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            question['question'] ?? '',
                            style: const TextStyle(color: Colors.white),
                          ),
                          const SizedBox(height: 12),
                          ...List.generate(options.length, (optIndex) {
                            bool isSelected =
                                selectedOptions[qIndex] == optIndex;
                            return InkWell(
                              onTap: () {
                                setState(() {
                                  selectedOptions[qIndex] = optIndex;
                                });
                              },
                              child: Container(
                                margin: const EdgeInsets.symmetric(vertical: 6),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.grey[200],
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: isSelected
                                        ? mainColor
                                        : Colors.grey.shade300,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      isSelected
                                          ? Icons.radio_button_checked
                                          : Icons.radio_button_unchecked,
                                      color:
                                          isSelected ? mainColor : Colors.grey,
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      options[optIndex],
                                      style: TextStyle(
                                        color: isSelected
                                            ? mainColor
                                            : Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: _submitQuiz,
              style: ElevatedButton.styleFrom(
                backgroundColor: mainColor,
                padding:
                    const EdgeInsets.symmetric(vertical: 14, horizontal: 32),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: const Text(
                'Envoyer',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
