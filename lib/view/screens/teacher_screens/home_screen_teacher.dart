import 'package:dentaire/view/components/custom_navigation_bar_curved.dart';
import 'package:dentaire/view/components/navigation_item.dart';
import 'package:dentaire/view/screens/common_screens/profile_screen.dart';
import 'package:dentaire/view/screens/teacher_screens/TeacherHomeContent.dart';
import 'package:dentaire/view/screens/teacher_screens/settings_screen_teacher.dart';
import 'package:dentaire/view/screens/teacher_screens/stat_screen_teacher.dart';
import 'package:flutter/material.dart';
import 'roundeed_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreenTeacher extends StatefulWidget {
  final int selectedIndex;

  const HomeScreenTeacher({Key? key, this.selectedIndex = 0}) : super(key: key);

  @override
  _HomeScreenTeacherState createState() => _HomeScreenTeacherState();
}

class _HomeScreenTeacherState extends State<HomeScreenTeacher> {
  late int _currentIndex;
  String currentTeacherId = '';

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.selectedIndex;
    // Récupération de l'ID du teacher connecté
    currentTeacherId = FirebaseAuth.instance.currentUser?.uid ?? '';
  }

  void _onNavBarTap(int index) {
    if (index == 1) {
      // Ouvrir le panneau flottant Étudiants
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return RoundedPanelScreen(
            onClose: () => Navigator.pop(context),
          );
        },
      );
    } else {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Liste des écrans, corrigée pour GlobalStatsPage
    final List<Widget> _screens = [
      const Center(child: TeacherHomeContent()),
      Center(child: Text("Étudiants")), // placeholder, remplacé par panel
      currentTeacherId.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Center(child: GlobalStatsPage(teacherId: currentTeacherId)),
      const Center(child: SettingsScreenTeacher()),
      const Center(child: ProfileScreen()),
    ];

    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: CustomNavBarTheme.getNavigationBar(
        index: _currentIndex,
        onTap: _onNavBarTap,
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
