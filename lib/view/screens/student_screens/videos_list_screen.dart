import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dentaire/view/components/custom_navigation_bar_curved.dart';
import 'package:dentaire/view/components/navigation_item.dart';
import 'package:dentaire/view/screens/student_screens/home_screen_student.dart';
import 'package:dentaire/view/screens/student_screens/video_details_screen.dart';
import 'package:dentaire/view/screens/student_screens/widgets/search_bar.dart';
import 'package:flutter/material.dart';

class VideoListScreen extends StatefulWidget {
  final String? moduleName;
  const VideoListScreen({Key? key, this.moduleName}) : super(key: key);

  @override
  _VideoListScreenState createState() => _VideoListScreenState();
}

class _VideoListScreenState extends State<VideoListScreen> {
  int _currentIndex = 0;
  String moduleName = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as Map?;
    moduleName = args?['moduleName'] ?? widget.moduleName ?? 'Module inconnu';
  }

  void _onNavBarTap(int index) {
    if (index == _currentIndex) return;
    setState(() {
      _currentIndex = index;
    });
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => HomeScreenStudent(selectedIndex: index),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF4F9CB2), Color(0xff065464)],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.person, color: Colors.grey),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Hello Imane',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        Text(
                          'in $moduleName',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 14),
                        ),
                      ],
                    ),
                    const Spacer(),
                    const Icon(Icons.notifications_none, color: Colors.white),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: SearchInput(),
              ),
              const SizedBox(height: 20),

              // Liste des vidéos depuis Firestore
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('videos')
                      .where('module', isEqualTo: moduleName)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          "Erreur: ${snapshot.error}",
                          style: const TextStyle(color: Colors.white),
                        ),
                      );
                    }

                    final videos = snapshot.data?.docs ?? [];
                    if (videos.isEmpty) {
                      return const Center(
                        child: Text(
                          "Aucune vidéo disponible pour ce module.",
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: videos.length,
                      itemBuilder: (context, index) {
                        final video = videos[index];
                        final data = video.data() as Map<String, dynamic>;
                        final videoTitle = data['title'] ?? 'Titre inconnu';

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => VideoDetailScreen(
                                        videoId: video.id,
                                        moduleName: moduleName,
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(Icons.play_arrow,
                                      color: Colors.black),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  videoTitle,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              const Icon(Icons.folder, color: Colors.grey),
                            ],
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
        bottomNavigationBar: CustomNavBarTheme.getNavigationBar(
          index: _currentIndex,
          onTap: _onNavBarTap,
          itemsList: const [
            NavItem(icon: Icons.home, label: "Accueil"),
            NavItem(icon: Icons.list, label: "Modules"),
            NavItem(icon: Icons.favorite, label: "Favoris"),
            NavItem(icon: Icons.settings, label: "Param"),
            NavItem(icon: Icons.person, label: "Profile"),
          ],
        ),
      ),
    );
  }
}
