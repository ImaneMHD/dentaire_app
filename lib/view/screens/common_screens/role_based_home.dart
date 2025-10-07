import 'package:dentaire/view/screens/admin_screens/home_screen_admi.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dentaire/view/screens/teacher_screens/home_screen_teacher.dart';
import 'package:dentaire/view/screens/student_screens/home_screen_student.dart'; // Créez ce fichier

class RoleBasedHome extends StatelessWidget {
  const RoleBasedHome({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // Si l'utilisateur n'est pas connecté, retournez à l'écran de connexion
      // C'est un cas de sécurité, car cette page ne doit être atteinte que si l'utilisateur est connecté.
      return const CircularProgressIndicator();
    }

    return FutureBuilder<DocumentSnapshot>(
      future:
          FirebaseFirestore.instance.collection('users').doc(user.uid).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError || !snapshot.hasData || !snapshot.data!.exists) {
          return const Scaffold(
            body: Center(
                child: Text("Erreur: Utilisateur non trouvé ou rôle inconnu.")),
          );
        }

        final userData = snapshot.data!.data() as Map<String, dynamic>;
        final role = userData['role'];

        switch (role) {
          case 'teacher':
            return const HomeScreenTeacher();
          case 'student':
            // TODO: Créez et retournez la page d'accueil de l'étudiant
            return const HomeScreenStudent();
          case 'admin':
            // TODO: Créez et retournez la page d'accueil de l'administrateur
            return const HomeScreenAdmin();
          default:
            return const Scaffold(
              body: Center(child: Text("Rôle d'utilisateur non valide.")),
            );
        }
      },
    );
  }
}
