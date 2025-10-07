import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dentaire/data/models/user.dart';

class Teacher extends AppUser {
  Teacher({
    required String id,
    required String name,
    required String email,
  }) : super(id: id, name: name, email: email, role: 'teacher');

  // Factory constructor to create a Teacher from a Firestore DocumentSnapshot
  factory Teacher.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Teacher(
      id: doc.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
    );
  }
}
