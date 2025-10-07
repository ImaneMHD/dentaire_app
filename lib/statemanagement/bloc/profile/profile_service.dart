import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dentaire/data/models/userPofile.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Récupère les données du profil de l'utilisateur courant depuis Firestore.
  Future<UserProfile> getUserProfile() async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('Utilisateur non authentifié.');
    }

    final doc =
        await _firestore.collection('user_profiles').doc(user.uid).get();

    if (!doc.exists) {
      // Crée un profil initial si l'utilisateur n'en a pas.
      final newProfile = UserProfile(uid: user.uid, email: user.email);
      await doc.reference.set(newProfile.toFirestore());
      return newProfile;
    }

    return UserProfile.fromFirestore(doc);
  }

  // Met à jour les données du profil de l'utilisateur.
  Future<void> updateProfile(UserProfile updatedProfile) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('Utilisateur non authentifié.');
    }

    await _firestore
        .collection('user_profiles')
        .doc(user.uid)
        .update(updatedProfile.toFirestore());
  }
}
