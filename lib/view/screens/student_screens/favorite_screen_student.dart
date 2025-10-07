import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dentaire/view/screens/student_screens/video_lecture_screen.dart';
import 'package:flutter/material.dart';
import 'package:dentaire/view/screens/student_screens/widgets/profile_header.dart';
import 'package:dentaire/view/screens/student_screens/widgets/search_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FavoritesContent extends StatelessWidget {
  const FavoritesContent({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return const Center(
        child: Text(
          "Veuillez vous connecter pour voir vos favoris.",
          style: TextStyle(color: Colors.white),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF4F9CB2), Color(0xff065464)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const ProfileHeader(),
              const SizedBox(height: 12),
              const SearchInput(),
              const SizedBox(height: 16),

              // 🔹 StreamBuilder pour récupérer les favoris
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('favorites')
                      .where('userId', isEqualTo: currentUser.uid)
                      //.orderBy('timestamp', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      );
                    }
                    if (snapshot.hasError) {
                      return Center(
                        child: Text("Erreur: ${snapshot.error}",
                            style: const TextStyle(color: Colors.white)),
                      );
                    }

                    final favorites = snapshot.data?.docs ?? [];

                    if (favorites.isEmpty) {
                      return const Center(
                        child: Text(
                          "Aucune vidéo en favori.",
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: favorites.length,
                      itemBuilder: (context, index) {
                        final fav = favorites[index];
                        final data = fav.data() as Map<String, dynamic>;

                        return InkWell(
                          onTap: () {
                            // 🔹 On ouvre la vidéo depuis VideoPlayerScreen
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => VideoPlayerScreen(
                                  videoTitle:
                                      data['videoTitle'] ?? 'Titre inconnu',
                                  moduleName:
                                      data['moduleName'] ?? 'Module inconnu',
                                  video: {
                                    'id': data['videoId'],
                                    'videoUrl': data['videoUrl'],
                                  },
                                ),
                              ),
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 15),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: const EdgeInsets.all(8),
                                  child: const Icon(Icons.play_arrow,
                                      color: Colors.black),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        data['videoTitle'] ?? 'Titre inconnu',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                      Text(
                                        data['moduleName'] ?? '',
                                        style: const TextStyle(
                                          color: Colors.white70,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete_outline,
                                    color: Colors.black,
                                  ),
                                  onPressed: () async {
                                    await fav.reference.delete();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content:
                                              Text("Supprimé des favoris.")),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
