import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dentaire/view/screens/common_screens/profile_screen.dart';
import 'package:flutter/material.dart';

class ProfileHeader extends StatefulWidget {
  final String subtitle;
  final String? imagePath;

  const ProfileHeader({
    super.key,
    this.subtitle = "in DentSmart",
    this.imagePath,
  });

  @override
  State<ProfileHeader> createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends State<ProfileHeader> {
  String? userName;

  @override
  void initState() {
    super.initState();
    _fetchUserName();
  }

  Future<void> _fetchUserName() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final doc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(user.uid)
          .get();

      if (doc.exists) {
        final data = doc.data();
        setState(() {
          userName = data?['name'] ?? 'Utilisateur';
        });
      } else {
        setState(() {
          userName = 'Utilisateur';
        });
      }
    } catch (e) {
      setState(() {
        userName = 'Erreur';
      });
      debugPrint('Erreur lors de la récupération du nom: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfileScreen()),
              );
            },
            child: CircleAvatar(
              radius: 24,
              backgroundColor: Colors.white,
              backgroundImage: widget.imagePath != null
                  ? AssetImage(widget.imagePath!)
                  : null,
              child: widget.imagePath == null
                  ? const Icon(Icons.person, color: Colors.grey, size: 28)
                  : null,
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userName != null ? "Hello $userName" : "Hello...",
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
              Text(
                widget.subtitle,
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ],
          ),
          const Spacer(),
          const Icon(Icons.notifications_none, color: Colors.white, size: 28),
        ],
      ),
    );
  }
}
