import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:dentaire/view/screens/teacher_screens/ajoute_video.dart';
import 'package:dentaire/view/screens/teacher_screens/statistic_screen_teacher.dart';
import 'package:dentaire/view/components/custom_navigation_bar_curved.dart';
import 'package:dentaire/view/components/navigation_item.dart';
import 'package:dentaire/view/screens/teacher_screens/home_screen_teacher.dart';
import 'package:dentaire/view/screens/teacher_screens/widgets/profile_header.dart';
import 'package:dentaire/view/screens/teacher_screens/widgets/search_bar.dart';

class VideoListScreen extends StatefulWidget {
  final String moduleName;

  const VideoListScreen({Key? key, required this.moduleName}) : super(key: key);

  @override
  State<VideoListScreen> createState() => _VideoListScreenState();
}

class _VideoListScreenState extends State<VideoListScreen> {
  int _currentIndex = 0;
  final user = FirebaseAuth.instance.currentUser;

  Future<void> _deleteVideo(String videoId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Supprimer la vidéo"),
        content: const Text("Voulez-vous vraiment supprimer cette vidéo ?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Annuler"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
            child: const Text("Supprimer"),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await FirebaseFirestore.instance
          .collection('videos')
          .doc(videoId)
          .delete();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Vidéo supprimée avec succès")),
      );
    }
  }

  /// 🔹 Fonction pour compter les likes d’une vidéo
  Future<int> _countLikes(String videoId) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('likes')
        .where('videoid', isEqualTo: videoId)
        .get();
    return snapshot.size;
  }

  /// 🔹 Fonction pour compter les vues d’une vidéo
  Future<int> _countViews(String videoId) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('views')
        .where('videoid', isEqualTo: videoId)
        .get();
    return snapshot.size;
  }

  @override
  Widget build(BuildContext context) {
    final moduleName = widget.moduleName;
    final Size screenSize = MediaQuery.of(context).size;
    final double screenWidth = screenSize.width;
    final double screenHeight = screenSize.height;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF4F9CB2), Color(0xff065464)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // HEADER
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.04,
                  vertical: screenHeight * 0.01,
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Expanded(child: Center(child: ProfileHeader())),
                  ],
                ),
              ),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                child: const SearchInput(),
              ),
              SizedBox(height: screenHeight * 0.01),

              // 🔹 Liste des vidéos du module
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('videos')
                      .where('teacherId', isEqualTo: user?.uid)
                      .where('module', isEqualTo: moduleName)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(
                        child: Text('Erreur : ${snapshot.error}',
                            style: const TextStyle(color: Colors.white)),
                      );
                    }
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(
                        child: Text(
                          'Aucune vidéo trouvée pour ce module.',
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    }

                    final videos = snapshot.data!.docs;

                    return ListView.builder(
                      padding:
                          EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
                      itemCount: videos.length,
                      itemBuilder: (context, index) {
                        final video = videos[index];
                        final data = video.data() as Map<String, dynamic>;
                        final String videoId = data['videoid'] ?? video.id;

                        return FutureBuilder(
                          future: Future.wait([
                            _countLikes(videoId),
                            _countViews(videoId),
                          ]),
                          builder:
                              (context, AsyncSnapshot<List<int>> countSnap) {
                            if (!countSnap.hasData) {
                              return const SizedBox.shrink();
                            }
                            final likes = countSnap.data![0];
                            final views = countSnap.data![1];

                            return Card(
                              margin: EdgeInsets.symmetric(
                                  vertical: screenHeight * 0.008),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(screenWidth * 0.03),
                              ),
                              child: Container(
                                padding: EdgeInsets.all(screenWidth * 0.03),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFD9D9D9),
                                  borderRadius:
                                      BorderRadius.circular(screenWidth * 0.03),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ListTile(
                                      leading: Icon(Icons.play_circle,
                                          size: screenWidth * 0.1,
                                          color: Colors.black),
                                      title: Text(
                                        data['title'] ?? 'Titre inconnu',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: screenWidth * 0.045,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          // Modifier
                                          IconButton(
                                            icon: Icon(Icons.edit,
                                                color: Colors.black,
                                                size: screenWidth * 0.05),
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (_) => AddVideoPage(
                                                    videoId: video.id,
                                                    initialTitle: data['title'],
                                                    initialDescription:
                                                        data['description'],
                                                    initialModule:
                                                        data['module'],
                                                  ),
                                                ),
                                              );
                                            },
                                          ),

                                          // Statistiques
                                          IconButton(
                                            icon: Icon(Icons.bar_chart,
                                                color: Colors.black,
                                                size: screenWidth * 0.05),
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (_) =>
                                                      VideoStatistiquePage(
                                                    videoId: videoId,
                                                    videoTitle: data['title'] ??
                                                        'Titre inconnu',
                                                  ),
                                                ),
                                              );
                                            },
                                          ),

                                          // Supprimer
                                          IconButton(
                                            icon: Icon(Icons.delete,
                                                color: Colors.black,
                                                size: screenWidth * 0.05),
                                            onPressed: () =>
                                                _deleteVideo(video.id),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // 🔹 Ligne des statistiques
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: screenWidth * 0.04),
                                      child: Row(
                                        children: [
                                          Icon(Icons.visibility,
                                              color: Colors.grey[700],
                                              size: screenWidth * 0.045),
                                          SizedBox(width: 5),
                                          Text('$views'),
                                          SizedBox(width: 20),
                                          Icon(Icons.favorite,
                                              color: Colors.black,
                                              size: screenWidth * 0.045),
                                          SizedBox(width: 5),
                                          Text('$likes'),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
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

      // FAB Ajouter
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => AddVideoPage(moduleName: moduleName)),
          );
        },
        backgroundColor: Colors.black,
        child: Icon(Icons.add, size: screenWidth * 0.07),
      ),

      // 🔹 Barre de navigation
      bottomNavigationBar: CustomNavBarTheme.getNavigationBar(
        index: _currentIndex,
        onTap: (index) {
          setState(() => _currentIndex = index);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => HomeScreenTeacher(selectedIndex: index),
            ),
          );
        },
        itemsList: const [
          NavItem(icon: Icons.home, label: "Accueil"),
          NavItem(icon: Icons.school_rounded, label: "Étudiants"),
          NavItem(icon: Icons.bar_chart, label: "Stats"),
          NavItem(icon: Icons.settings, label: "Param"),
          NavItem(icon: Icons.person, label: "Profil"),
        ],
      ),
    );
  }
}
