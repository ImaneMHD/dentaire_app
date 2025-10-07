import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  String userName = 'Nom inconnu';
  String userEmail = 'Email inconnu';
  String userRole = 'Rôle inconnu';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = _auth.currentUser;
    if (user != null) {
      setState(() => userEmail = user.email ?? 'Email inconnu');

      final doc = await _db.collection('Users').doc(user.uid).get();
      if (doc.exists) {
        final data = doc.data();
        if (data != null) {
          if (data['name'] != null) {
            setState(() => userName = data['name']);
          }
          if (data['role'] != null) {
            setState(() => userRole = data['role']);
          }
        }
      }
    }
  }

  Future<void> _logout() async {
    await _auth.signOut();
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/welcomeScreen',
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF71C0D6), Color(0xff065464)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            // 🔹 Bandeau décoratif avec avatar
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                ClipPath(
                  clipper: ArtisticCurveClipper(),
                  child: Container(
                    height: 220,
                    color: Colors.white,
                  ),
                ),
                Positioned(
                  bottom: 10,
                  child: Container(
                    width: 130,
                    height: 130,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [Colors.blueAccent, Colors.white],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      border: Border.all(color: Colors.white, width: 4),
                    ),
                    child: const CircleAvatar(
                      radius: 60,
                      backgroundColor: Color(0xFFEFEFEF),
                      child: Icon(Icons.person, size: 60, color: Colors.grey),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 80),

            // 🔹 Nom
            Text(
              userName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),

            // 🔹 Email
            Text(
              userEmail,
              style: const TextStyle(color: Colors.white70, fontSize: 18),
            ),
            const SizedBox(height: 8),

            // 🔹 Rôle
            Text(
              "Rôle : $userRole",
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
            const SizedBox(height: 30),

            // 🔹 Bouton logout
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 20),
              child: ElevatedButton.icon(
                onPressed: _logout,
                icon: const Icon(Icons.logout, size: 22, color: Colors.white),
                label: const Text(
                  'Se déconnecter',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0A3F4D),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 🔹 Clip artistique pour l'en-tête
class ArtisticCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height * 0.6);
    path.cubicTo(
      size.width * 0.2,
      size.height * 0.45,
      size.width * 0.4,
      size.height * 0.75,
      size.width * 0.6,
      size.height * 0.6,
    );
    path.cubicTo(
      size.width * 0.8,
      size.height * 0.45,
      size.width * 0.95,
      size.height * 0.9,
      size.width,
      size.height * 0.5,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
