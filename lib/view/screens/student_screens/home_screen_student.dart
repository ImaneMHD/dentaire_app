import 'package:dentaire/view/screens/common_screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:dentaire/view/components/custom_navigation_bar_curved.dart';
import 'package:dentaire/view/components/navigation_item.dart';
import 'StudentHomeContent.dart';
import 'module_screens_student.dart';
import 'favorite_screen_student.dart';
import 'settings_screen_student.dart';

class HomeScreenStudent extends StatefulWidget {
  final int selectedIndex;

  const HomeScreenStudent({Key? key, this.selectedIndex = 0}) : super(key: key);

  @override
  _HomeScreenStudentState createState() => _HomeScreenStudentState();
}

class _HomeScreenStudentState extends State<HomeScreenStudent> {
  late int _currentIndex;

  final List<Widget> _screens = const [
    StudentHomeContent(),
    ModulesContent(),
    FavoritesContent(),
    SettingsScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.selectedIndex;
  }

  void _onNavBarTap(int index) {
    if (index == _currentIndex) return; // Pas de changement si même onglet

    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: CustomNavBarTheme.getNavigationBar(
        index: _currentIndex,
        onTap: _onNavBarTap,
        itemsList: const [
          NavItem(icon: Icons.home, label: "Accueil"),
          NavItem(icon: Icons.list, label: "Modules"),
          NavItem(icon: Icons.favorite, label: "Favoris"),
          NavItem(icon: Icons.settings, label: "Paramètres"),
          NavItem(icon: Icons.person, label: "Profil"),
        ],
      ),
    );
  }
}
