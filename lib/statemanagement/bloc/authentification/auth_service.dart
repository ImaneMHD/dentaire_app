import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> signUpWithRole({
    required String email,
    required String password,
    required String role,
    required String name,
    String? specialite, // enseignants
    String? annee, // étudiants
    String? teacherId, // étudiants
  }) async {
    UserCredential userCredential;
    User? newUser;

    // 1. Création de l'utilisateur Firebase Auth
    try {
      userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      newUser = userCredential.user;
    } on FirebaseAuthException catch (e) {
      // Propagation des erreurs liées à l'authentification (mot de passe faible, email déjà utilisé, etc.)
      throw Exception('Erreur d\'authentification: ${e.message}');
    }

    if (newUser == null) {
      throw Exception("L'utilisateur n'a pas pu être créé.");
    }

    String uid = newUser.uid;
    String finalRole = role.toLowerCase(); // Utiliser le rôle en minuscules

    final userData = {
      "uid": uid,
      "email": email,
      "role":
          finalRole, // Utiliser la version en minuscules pour la vérification des règles
      "name": name,
      "createdAt": FieldValue.serverTimestamp(),
    };

    if (finalRole == "teacher" && specialite != null) {
      userData["specialite"] = specialite;
    } else if (finalRole == "etudiant" && annee != null) {
      userData["annee"] = annee;
      if (teacherId != null) userData["teacherId"] = teacherId;
    }

    // 2. Enregistrement des données Firestore (où les règles de sécurité s'appliquent)
    try {
      // Écriture 1: Collection Users (pour le rôle et les données de profil)
      await _firestore.collection("Users").doc(uid).set(userData);

      // Écriture 2: Si c'est un enseignant, on l'ajoute à la liste Enseignants
      // Ceci est nécessaire pour les listes et les règles d'administration
      if (finalRole == "teacher") {
        final teacherData = {
          "uid": uid,
          "name": name,
          "email": email,
          "specialite": specialite,
          "createdAt": FieldValue.serverTimestamp(),
        };
        await _firestore.collection("Enseignants").doc(uid).set(teacherData);
      }
    } catch (e) {
      // Si l'écriture échoue (ex: Permission Denied par les règles)
      // On tente de supprimer l'utilisateur créé dans Firebase Auth pour éviter les orphelins.
      await newUser.delete();
      if (e.toString().contains('PERMISSION_DENIED')) {
        // Cette erreur est spécifique au blocage des règles de sécurité
        throw Exception(
            "Échec de la création. Veuillez vérifier si vous êtes connecté en tant qu'administrateur.");
      }
      throw Exception('Erreur Firestore: $e. L\'utilisateur a été supprimé.');
    }
  }

  Future<User?> signIn({
    required String email,
    required String password,
  }) async {
    UserCredential userCredential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCredential.user;
  }

  Future<Map<String, dynamic>?> getCurrentUserWithRole() async {
    User? user = _auth.currentUser;
    if (user == null) return null;

    // Tentative de lecture du rôle dans Users
    DocumentSnapshot doc =
        await _firestore.collection("Users").doc(user.uid).get();

    // Si le document Users n'existe pas, l'utilisateur n'est pas encore initialisé
    if (!doc.exists) return null;

    return doc.data() as Map<String, dynamic>?;
  }

  Future<void> signOut() async => await _auth.signOut();

  // Fonction pour obtenir l'UID de l'utilisateur actuellement connecté
  String? getCurrentUserId() => _auth.currentUser?.uid;
}
