import 'package:dentaire/view/components/custom_navigation_bar_curved.dart';
import 'package:dentaire/view/components/navigation_item.dart';
import 'package:dentaire/view/screens/teacher_screens/home_screen_teacher.dart';
import 'package:flutter/material.dart';

class ListesVues extends StatefulWidget {
  const ListesVues({super.key});

  @override
  State<ListesVues> createState() => _ListesVuesState();
}

class _ListesVuesState extends State<ListesVues> {
  int _currentIndex = 0;

  final List<Map<String, dynamic>> vues = [
    {'nom': 'Vidéo 1', 'nbVues': 120},
    {'nom': 'Vidéo 2', 'nbVues': 95},
    {'nom': 'Vidéo 3', 'nbVues': 250},
    {'nom': 'Vidéo 4', 'nbVues': 45},
    {'nom': 'Vidéo 5', 'nbVues': 180},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              // Header
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 5),
                    const Text(
                      "Liste des vues",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                    const Spacer(),
                    const Icon(Icons.notifications_none, color: Colors.white),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              // Liste des vues
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: vues.length,
                  itemBuilder: (context, index) {
                    final vue = vues[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        "${vue['nom']} — ${vue['nbVues']} vues",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => const Divider(
                    color: Colors.white70,
                    thickness: 0.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
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
          NavItem(icon: Icons.school_rounded, label: "Etudiants"),
          NavItem(icon: Icons.bar_chart, label: "Stats"),
          NavItem(icon: Icons.settings, label: "Param"),
          NavItem(icon: Icons.person, label: "Profile"),
        ],
      ),
    );
  }
}
