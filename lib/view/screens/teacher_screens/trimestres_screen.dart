import 'package:dentaire/view/components/custom_navigation_bar_curved.dart';
import 'package:dentaire/view/components/navigation_item.dart';
import 'package:dentaire/view/screens/teacher_screens/home_screen_teacher.dart';
import 'package:dentaire/view/screens/teacher_screens/roundeed_screen.dart';
import 'package:dentaire/view/screens/teacher_screens/widgets/search_bar.dart';
import 'package:dentaire/view/screens/teacher_screens/video_liste_screens.dart';
import 'package:flutter/material.dart';

class TrimestersModulesPage extends StatefulWidget {
  final String year;

  const TrimestersModulesPage({super.key, required this.year});

  @override
  State<TrimestersModulesPage> createState() => _TrimestersModulesPageState();
}

class _TrimestersModulesPageState extends State<TrimestersModulesPage> {
  int _currentIndex = 0;
  int selectedTrimester = 0;
  bool _showStudentPanel = false;

  final List<List<String>> trimestersModules = [
    [
      'Anatomie Dentaire',
      'Pathologies Buccales',
      'Radiologie Dentaire',
      'Chirurgie Dentaire',
      'Prothèses Dentaires'
    ],
    ['Module7', 'Module8', 'Module9'],
    ['Module10', 'Module11'],
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
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
                  // Header
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 10),
                    child: Row(
                      children: [
                        IconButton(
                          icon:
                              const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          "${widget.year} - DentSmart",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const Spacer(),
                        const Icon(Icons.notifications_none,
                            color: Colors.white),
                      ],
                    ),
                  ),

                  // Search bar
                  const SearchInput(),

                  const SizedBox(height: 22),

                  // Carte blanche contenant les boutons de trimestres + modules
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.55,
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Trimestres
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: List.generate(3, (index) {
                              bool isSelected = index == selectedTrimester;
                              return ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: isSelected
                                      ? const Color(0xFF0f3a5f)
                                      : const Color(0xFFe1eff7),
                                  foregroundColor: isSelected
                                      ? Colors.white
                                      : Colors.black87,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                ),
                                onPressed: () {
                                  setState(() {
                                    selectedTrimester = index;
                                  });
                                },
                                child: Text('Trimestre ${index + 1}'),
                              );
                            }),
                          ),
                          const SizedBox(height: 16),

                          // Modules du trimestre sélectionné
                          Expanded(
                            child: GridView.builder(
                              itemCount:
                                  trimestersModules[selectedTrimester].length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 12,
                                crossAxisSpacing: 12,
                                childAspectRatio: 2.5,
                              ),
                              itemBuilder: (context, index) {
                                String moduleName =
                                    trimestersModules[selectedTrimester][index];
                                return ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF1A6175),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 4,
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => VideoListScreen(
                                            moduleName: moduleName),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    moduleName,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Panneau des étudiants affiché au-dessus
          if (_showStudentPanel)
            RoundedPanelScreen(
              onClose: () => setState(() => _showStudentPanel = false),
            ),
        ],
      ),
      bottomNavigationBar: CustomNavBarTheme.getNavigationBar(
        index: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });

          if (index == 1) {
            // Affiche le panneau sans changer de page
            setState(() {
              _showStudentPanel = true;
            });
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
          NavItem(icon: Icons.home, label: "Acceuil"),
          NavItem(icon: Icons.school_rounded, label: "Etudiants"),
          NavItem(icon: Icons.bar_chart, label: "Stats"),
          NavItem(icon: Icons.settings, label: "Param"),
          NavItem(icon: Icons.person, label: "Profile"),
        ],
      ),
    );
  }
}
