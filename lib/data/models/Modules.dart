import 'package:cloud_firestore/cloud_firestore.dart';

class Module {
  final String id;
  final String nom; // "Pathologie Buccale", etc.
  final String annee;
  final String Trimestre;

  Module(
      {required this.id,
      required this.nom,
      required this.annee,
      required this.Trimestre});

  factory Module.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Module(
      id: doc.id,
      nom: data['nom'] ?? '',
      annee: data['annee'],
      Trimestre: data['trimestre'],
    );
  }
}
