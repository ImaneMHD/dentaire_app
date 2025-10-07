import 'package:flutter/material.dart';

class NavItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const NavItem({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 30, color: Colors.white), // Icône
        SizedBox(height: 5), // Espacement
        Text(
          label,
          style: TextStyle(
              fontSize: 12, color: Colors.white), // Texte sous l'icône
        ),
      ],
    );
  }
}
