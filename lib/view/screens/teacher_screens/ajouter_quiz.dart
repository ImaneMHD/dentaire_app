import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddQuizPage extends StatefulWidget {
  final String videoId;
  const AddQuizPage({super.key, required this.videoId});

  @override
  State<AddQuizPage> createState() => _AddQuizPageState();
}

class _AddQuizPageState extends State<AddQuizPage> {
  final _questionController = TextEditingController();
  final List<TextEditingController> _optionControllers =
      List.generate(4, (_) => TextEditingController());
  int _correctIndex = 0;
  final List<Map<String, dynamic>> _quizQuestions = [];
  static const mainColor = Color(0xFF0F5C77);

  void _addQuestionLocally() {
    if (_questionController.text.trim().isEmpty ||
        _optionControllers.any((c) => c.text.trim().isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Veuillez remplir tous les champs")));
      return;
    }

    setState(() {
      _quizQuestions.add({
        "question": _questionController.text.trim(),
        "options": _optionControllers.map((c) => c.text.trim()).toList(),
        "correctIndex": _correctIndex,
      });
    });

    _questionController.clear();
    for (var c in _optionControllers) c.clear();
    _correctIndex = 0;
  }

  Future<void> _saveQuiz() async {
    if (_quizQuestions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Ajoute au moins une question")));
      return;
    }

    final quizRef =
        FirebaseFirestore.instance.collection("quizzes").doc(widget.videoId);

    final batch = FirebaseFirestore.instance.batch();
    for (var question in _quizQuestions) {
      final questionRef = quizRef.collection("questions").doc();
      batch.set(questionRef, question);
    }

    await batch.commit();

    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Quiz enregistré ✅")));

    Navigator.pop(context, true);
  }

  void _removeQuestion(int index) =>
      setState(() => _quizQuestions.removeAt(index));

  Widget _buildQuestionCard(int index, Map<String, dynamic> q) {
    final options = (q["options"] as List<dynamic>? ?? [])
        .map((o) => o?.toString() ?? "")
        .toList();

    return Card(
      color: mainColor,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text("Question ${index + 1} :",
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(q["question"]?.toString() ?? "",
              style: const TextStyle(color: Colors.white)),
          const SizedBox(height: 12),
          ...List.generate(options.length, (i) {
            final isCorrect = i == (q["correctIndex"] ?? 0);
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 6),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: mainColor),
              ),
              child: Row(children: [
                Icon(
                    isCorrect
                        ? Icons.check_circle
                        : Icons.radio_button_unchecked,
                    color: isCorrect ? Colors.green : Colors.grey),
                const SizedBox(width: 10),
                Text(options[i]),
              ]),
            );
          }),
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
                icon: const Icon(Icons.delete, color: Colors.white),
                onPressed: () => _removeQuestion(index)),
          ),
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: mainColor,
        title: const Text("Ajouter un quiz"),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context, false)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            const Text("Question :",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            TextField(
                controller: _questionController,
                decoration:
                    const InputDecoration(hintText: "Entrer la question"),
                maxLines: null),
            const SizedBox(height: 12),
            const Text("Choix de réponse :",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ...List.generate(4, (i) {
              return Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Row(children: [
                  Expanded(
                      child: TextField(
                          controller: _optionControllers[i],
                          decoration:
                              InputDecoration(hintText: "Option ${i + 1}"))),
                  Radio<int>(
                      value: i,
                      groupValue: _correctIndex,
                      onChanged: (v) => setState(() => _correctIndex = v!)),
                ]),
              );
            }),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton.icon(
                onPressed: _addQuestionLocally,
                icon: const Icon(Icons.add),
                label: const Text("Ajouter la question"),
                style: ElevatedButton.styleFrom(backgroundColor: mainColor),
              ),
            ),
            const Divider(height: 32),
            const Text("Aperçu du quiz :",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            if (_quizQuestions.isEmpty)
              const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Text("Aucune question ajoutée.")),
            ..._quizQuestions
                .asMap()
                .entries
                .map((e) => _buildQuestionCard(e.key, e.value)),
            const SizedBox(height: 24),
            ElevatedButton(
                onPressed: _saveQuiz,
                child: const Text("Terminer le quiz"),
                style: ElevatedButton.styleFrom(backgroundColor: mainColor)),
          ],
        ),
      ),
    );
  }
}
