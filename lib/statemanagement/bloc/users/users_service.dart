import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dentaire/data/models/User.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionName = 'users';

  Stream<List<AppUser>> getUsers() {
    return _firestore.collection(_collectionName).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => AppUser.fromFirestore(doc)).toList();
    });
  }

  Future<void> addUser(AppUser user) async {
    await _firestore.collection(_collectionName).add(user.toJson());
  }

  Future<void> updateUser(AppUser user) async {
    await _firestore
        .collection(_collectionName)
        .doc(user.id)
        .update(user.toJson());
  }

  Future<void> deleteUser(String userId) async {
    await _firestore.collection(_collectionName).doc(userId).delete();
  }
}
