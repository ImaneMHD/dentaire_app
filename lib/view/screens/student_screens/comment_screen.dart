import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CommentaireField extends StatefulWidget {
  final Function(String) onSend;
  final String videoId; // ID de la vidéo concernée

  const CommentaireField({
    Key? key,
    required this.onSend,
    required this.videoId,
  }) : super(key: key);

  @override
  State<CommentaireField> createState() => _CommentaireFieldState();
}

class _CommentaireFieldState extends State<CommentaireField> {
  final TextEditingController _controller = TextEditingController();
  bool _isSending = false;

  Future<void> _sendComment() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Utilisateur non connecté.")),
      );
      return;
    }

    setState(() => _isSending = true);

    try {
      // 🔹 Enregistrer le commentaire dans Firestore
      await FirebaseFirestore.instance.collection('commentaire').add({
        'userId': user.uid,
        'videoid': widget.videoId,
        'commentaire': text,
        'timestamp': FieldValue.serverTimestamp(),
      });

      widget.onSend(text);
      _controller.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Commentaire ajouté ✅")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur : $e")),
      );
    } finally {
      setState(() => _isSending = false);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: 'Écrire un commentaire...',
                border: OutlineInputBorder(),
              ),
              minLines: 1,
              maxLines: 3,
            ),
          ),
          _isSending
              ? const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(),
                )
              : IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendComment,
                ),
        ],
      ),
    );
  }
}
