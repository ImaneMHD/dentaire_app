import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dentaire/statemanagement/bloc/GestionVideos.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:dentaire/view/components/custom_navigation_bar_curved.dart';
import 'package:dentaire/view/components/navigation_item.dart';
import 'package:dentaire/view/screens/teacher_screens/home_screen_teacher.dart';
import 'package:dentaire/view/screens/teacher_screens/roundeed_screen.dart';
import 'package:dentaire/view/screens/teacher_screens/widgets/search_bar.dart';
import 'package:dentaire/view/screens/teacher_screens/videos_details.dart';

class GestionVideosPage extends StatefulWidget {
  const GestionVideosPage({Key? key}) : super(key: key);

  @override
  State<GestionVideosPage> createState() => _GestionVideosPageState();
}

class _GestionVideosPageState extends State<GestionVideosPage> {
  int _currentIndex = 0;
  bool _showStudentPanel = false;

  //final GestionVideos _gestionVideos = GestionVideos();

  final GestionVideos _gestionVideos = GestionVideos();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // ✅ Fond dégradé
          Container(
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
                  // ✅ Header avec flèche retour et titre
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    child: Row(
                      children: [
                        IconButton(
                          icon:
                              const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const SizedBox(width: 5),
                        const Text(
                          "Mes vidéos",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const Spacer(),
                        const Icon(Icons.notifications_none,
                            color: Colors.white),
                      ],
                    ),
                  ),

                  const SizedBox(height: 8),
                  const SearchInput(),
                  const SizedBox(height: 16),

                  // ✅ Liste des vidéos (Firestore)
                  Expanded(
                    child: FutureBuilder<List<Map<String, dynamic>>>(
                      future: _gestionVideos.getAllVideosForTeacher(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator(
                            color: Colors.white,
                          ));
                        }

                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return const Center(
                            child: Text(
                              "Aucune vidéo trouvée.",
                              style: TextStyle(color: Colors.white70),
                            ),
                          );
                        }

                        final videos = snapshot.data!;

                        return ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: videos.length,
                          itemBuilder: (context, index) {
                            final video = videos[index];
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        VideoDetailWithQuizScreen(
                                      videoTitle: video['title'],
                                      moduleName: video['module'],
                                      videoId: video['videoid'],
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
                                    // Icône lecture
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

                                    // Infos vidéo
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            video['title'],
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            video['module'],
                                            style: const TextStyle(
                                              color: Colors.white70,
                                              fontSize: 12,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Row(
                                            children: [
                                              const Icon(Icons.visibility,
                                                  color: Colors.white70,
                                                  size: 14),
                                              const SizedBox(width: 4),
                                              Text(
                                                "${video['views']} vues",
                                                style: const TextStyle(
                                                    color: Colors.white70,
                                                    fontSize: 12),
                                              ),
                                              const SizedBox(width: 10),
                                              const Icon(
                                                  Icons.folder_copy_outlined,
                                                  color: Colors.white70,
                                                  size: 14),
                                              const SizedBox(width: 4),
                                              Text(
                                                "${video['documents']} fichiers",
                                                style: const TextStyle(
                                                    color: Colors.white70,
                                                    fontSize: 12),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),

                                    // Icône favoris
                                    const Icon(Icons.video_library_outlined,
                                        color: Colors.white),
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

          // ✅ Panneau des étudiants
          if (_showStudentPanel)
            RoundedPanelScreen(
              onClose: () => setState(() => _showStudentPanel = false),
            ),
        ],
      ),

      // ✅ Barre de navigation
      bottomNavigationBar: CustomNavBarTheme.getNavigationBar(
        index: _currentIndex,
        onTap: (index) {
          setState(() => _currentIndex = index);

          if (index == 1) {
            setState(() => _showStudentPanel = true);
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HomeScreenTeacher(selectedIndex: index),
              ),
            );
          }
        },
        itemsList: const [
          NavItem(icon: Icons.home, label: "Accueil"),
          NavItem(icon: Icons.school_rounded, label: "Étudiants"),
          NavItem(icon: Icons.bar_chart, label: "Stats"),
          NavItem(icon: Icons.settings, label: "Paramètres"),
          NavItem(icon: Icons.person, label: "Profil"),
        ],
      ),
    );
  }
}
