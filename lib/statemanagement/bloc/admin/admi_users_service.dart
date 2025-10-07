import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dentaire/data/models/User.dart'; // Assurez-vous que le chemin vers votre modèle AppUser est correct

class AdminUserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // Nom de la collection dans Firestore (par défaut 'users')
  final String _collectionName = 'users';

  /// Récupère la liste des utilisateurs ayant le rôle 'teacher' en temps réel.
  /// Cette méthode utilise une requête filtrée (where) pour exclure les étudiants et les admins.
  Stream<List<AppUser>> getTeachers() {
    // Requête Firestore pour récupérer tous les documents de la collection 'users'
    // où le champ 'role' est strictement égal à 'teacher'.
    return _firestore
        .collection(_collectionName)
        .where('role', isEqualTo: 'teacher')
        .snapshots() // Écoute les changements en temps réel
        .map((snapshot) {
      // Convertit chaque DocumentSnapshot en objet AppUser
      return snapshot.docs.map((doc) => AppUser.fromFirestore(doc)).toList();
    });
  }

  // --- Méthodes de modification (pour l'administration) ---

  /// Ajoute un nouvel utilisateur à la collection.
  Future<void> addUser(AppUser user) async {
    // Ajoute un document avec un ID généré automatiquement par Firestore
    await _firestore.collection(_collectionName).add(user.toJson());
  }

  /// Met à jour les données d'un utilisateur existant.
  Future<void> updateUser(AppUser user) async {
    // Utilise l'ID de l'utilisateur (user.id) pour cibler le document à mettre à jour
    await _firestore
        .collection(_collectionName)
        .doc(user.id)
        .update(user.toJson());
  }

  /// Supprime un utilisateur de la collection.
  Future<void> deleteUser(String userId) async {
    await _firestore.collection(_collectionName).doc(userId).delete();
  }

  /// Méthode pour récupérer tous les utilisateurs (Admin, Teacher, Student)
  /// si jamais l'administrateur en a besoin.
  Stream<List<AppUser>> getAllUsers() {
    return _firestore.collection(_collectionName).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => AppUser.fromFirestore(doc)).toList();
    });
  }
}
