import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dentaire/data/models/user.dart';

class Admin extends AppUser {
  Admin({
    required String id,
    required String name,
    required String email,
  }) : super(id: id, name: name, email: email, role: 'admin');

  // Factory constructor to create an Admin from a Firestore DocumentSnapshot
  factory Admin.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Admin(
      id: doc.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
    );
  }
}
