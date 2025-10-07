import 'package:flutter/material.dart';

class AddComment extends StatefulWidget {
  final Function(String) onSend;

  const AddComment({Key? key, required this.onSend}) : super(key: key);

  @override
  State<AddComment> createState() => _AddCommentState();
}

class _AddCommentState extends State<AddComment> {
  final TextEditingController _commentController = TextEditingController();

  void _sendComment() {
    final comment = _commentController.text.trim();
    if (comment.isNotEmpty) {
      widget.onSend(comment);
      _commentController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _commentController,
              decoration: InputDecoration(
                hintText: 'Écrire un commentaire...',
                filled: true,
                fillColor: Colors.white,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          IconButton(
            icon: const Icon(Icons.send, color: Colors.white),
            onPressed: _sendComment,
          ),
        ],
      ),
    );
  }
}
