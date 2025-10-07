import 'package:dentaire/view/screens/student_screens/videos_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:dentaire/view/screens/student_screens/widgets/profile_header.dart';
import 'package:dentaire/view/screens/student_screens/widgets/search_bar.dart';

class ModulesContent extends StatelessWidget {
  const ModulesContent({super.key});

  static const List<Map<String, String>> modulesCourses = [
    {'title': 'Anatomie Dentaire', 'videos': '12', 'files': '8'},
    {'title': 'Pathologies Buccales', 'videos': '9', 'files': '6'},
    {'title': 'Radiologie Dentaire', 'videos': '4', 'files': '3'},
    {'title': 'Chirurgie Dentaire', 'videos': '10', 'files': '7'},
    {'title': 'Prothèses Dentaires', 'videos': '5', 'files': '4'},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
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
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                physics: const BouncingScrollPhysics(),
                itemCount: modulesCourses.length,
                itemBuilder: (context, index) {
                  final course = modulesCourses[index];
                  return InkWell(
                    splashColor: Colors.white24,
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VideoListScreen(
                            moduleName: course['title']!,
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.all(8),
                            child: const Icon(
                              Icons.book,
                              color: Colors.black,
                              semanticLabel: 'Module Icon',
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  course['title']!,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    const Icon(Icons.play_circle_fill,
                                        color: Colors.white70, size: 16),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${course['videos']} vidéos',
                                      style: const TextStyle(
                                          color: Colors.white70, fontSize: 12),
                                    ),
                                    const SizedBox(width: 12),
                                    const Icon(Icons.folder,
                                        color: Colors.white70, size: 16),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${course['files']} fichiers',
                                      style: const TextStyle(
                                          color: Colors.white70, fontSize: 12),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
