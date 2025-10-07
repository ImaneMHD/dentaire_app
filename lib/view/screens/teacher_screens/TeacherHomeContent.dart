import 'package:flutter/material.dart';
import 'package:dentaire/view/screens/teacher_screens/widgets/profile_header.dart';
import 'package:dentaire/view/screens/teacher_screens/widgets/search_bar.dart';
import 'package:dentaire/view/screens/teacher_screens/widgets/listes_annee.dart';
import 'package:dentaire/view/screens/teacher_screens/smart_search_page.dart'; // <-- Ajouter

class TeacherHomeContent extends StatelessWidget {
  const TeacherHomeContent({super.key});

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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ProfileHeader(),
              const SizedBox(height: 16),

              // <-- Ici on remplace l'appel direct par une navigation vers SmartSearchPage
              SearchInput(
                onChanged: (text) {
                  if (text.isNotEmpty) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const SmartSearchPage(),
                      ),
                    );
                  }
                },
              ),

              const SizedBox(height: 16),

              const Expanded(
                child: YearList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
