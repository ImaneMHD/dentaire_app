import 'package:cloud_firestore/cloud_firestore.dart';

class Annee {
  final String id;
  final String nom; // "Année 1", "Année 2", etc.

  Annee({required this.id, required this.nom});

  factory Annee.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Annee(
      id: doc.id,
      nom: data['nom'] ?? '',
    );
  }
}
