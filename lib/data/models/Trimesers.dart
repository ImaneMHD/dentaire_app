import 'package:cloud_firestore/cloud_firestore.dart';

class Trimestre {
  final String id;
  final String nom; // "Trimestre 1", "Trimestre 2", etc.

  Trimestre({required this.id, required this.nom});

  factory Trimestre.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Trimestre(
      id: doc.id,
      nom: data['nom'] ?? '',
    );
  }
}
