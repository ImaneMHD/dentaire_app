import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddDocumentPage extends StatefulWidget {
  @override
  _AddDocumentPageState createState() => _AddDocumentPageState();
}

class _AddDocumentPageState extends State<AddDocumentPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _urlController = TextEditingController();

  Future<void> _saveDocument() async {
    if (_formKey.currentState!.validate()) {
      DocumentReference doc =
          await FirebaseFirestore.instance.collection('documents').add({
        'title': _titleController.text,
        'url': _urlController.text,
        'createdAt': FieldValue.serverTimestamp(),
      });

      Navigator.pop(context, doc.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Ajouter un Document")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: "Titre du document"),
                validator: (value) => value!.isEmpty ? "Entrez un titre" : null,
              ),
              TextFormField(
                controller: _urlController,
                decoration: InputDecoration(labelText: "URL du document"),
                validator: (value) => value!.isEmpty ? "Entrez une URL" : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveDocument,
                child: Text("Enregistrer Document"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
