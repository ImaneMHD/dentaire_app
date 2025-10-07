import 'package:dentaire/view/screens/admin_screens/AdminProfilePage.dart';
import 'package:dentaire/view/screens/admin_screens/DshbordAdmin.dart';
import 'package:dentaire/view/screens/admin_screens/SetingsScrensAdmin.dart';
import 'package:dentaire/view/screens/admin_screens/UsersPage.dart';
import 'package:dentaire/view/screens/admin_screens/enseignantPage.dart';
import 'package:flutter/material.dart';
import 'package:dentaire/view/components/custom_navigation_bar_curved.dart';
import 'package:dentaire/view/components/navigation_item.dart';

class HomeScreenAdmin extends StatefulWidget {
  final int selectedIndex;
  const HomeScreenAdmin({super.key, this.selectedIndex = 0});

  @override
  State<HomeScreenAdmin> createState() => _HomeScreenAdminState();
}

class _HomeScreenAdminState extends State<HomeScreenAdmin> {
  late int _currentIndex;

  final List<Widget> _pages = const [
    AdminDashboardPage(),
    TeachersPage(),
    UsersPage(),
    SettingsScreenAdmin(),
    AdminProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.selectedIndex;
  }

  void _onNavBarTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: CustomNavBarTheme.getNavigationBar(
        index: _currentIndex,
        onTap: _onNavBarTap,
        itemsList: const [
          NavItem(icon: Icons.home, label: "Accueil"),
          NavItem(icon: Icons.school, label: "Enseignants"),
          NavItem(icon: Icons.people, label: "Utilisateurs"),
          NavItem(icon: Icons.settings, label: "Paramètres"),
          NavItem(icon: Icons.person, label: "Profil"),
        ],
      ),
    );
  }
}
