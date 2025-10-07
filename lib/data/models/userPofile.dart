import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  final String uid;
  final String? email;
  final String? name;
  final String? profileImageUrl;

  UserProfile({
    required this.uid,
    this.email,
    this.name,
    this.profileImageUrl,
  });

  // Convertit un document Firestore en objet UserProfile.
  factory UserProfile.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;
    return UserProfile(
      uid: doc.id,
      email: data?['email'],
      name: data?['name'],
      profileImageUrl: data?['profileImageUrl'],
    );
  }

  // Convertit un objet UserProfile en Map pour Firestore.
  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'name': name,
      'profileImageUrl': profileImageUrl,
    };
  }
}
