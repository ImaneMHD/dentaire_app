import 'package:flutter/material.dart';
import 'package:dentaire/view/screens/student_screens/widgets/profile_header.dart';
import 'package:dentaire/view/screens/student_screens/widgets/search_bar.dart';
import 'package:dentaire/view/screens/student_screens/YearList.dart';

class StudentHomeContent extends StatelessWidget {
  const StudentHomeContent({super.key});

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
              const SizedBox(height: 12),
              const SearchInput(),
              const SizedBox(height: 16),

              // Ajout d'un Expanded pour que la ListView puisse s'afficher correctement
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
