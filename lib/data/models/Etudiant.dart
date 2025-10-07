import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dentaire/data/models/user.dart';

class Student extends AppUser {
  final String studentId;
  final String year; // 'Année 1', 'Année 2', etc.

  Student({
    required String id,
    required String name,
    required String email,
    required this.studentId,
    required this.year,
  }) : super(id: id, name: name, email: email, role: 'student');

  // Factory constructor to create a Student from a Firestore DocumentSnapshot
  factory Student.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Student(
      id: doc.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      studentId: data['studentId'] ?? '',
      year: data['year'] ?? '',
    );
  }
}
