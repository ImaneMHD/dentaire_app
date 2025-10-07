import 'package:dentaire/view/screens/student_screens/home_screen_student.dart';
import 'package:flutter/material.dart';
import 'package:dentaire/view/components/custom_navigation_bar_curved.dart';
import 'package:dentaire/view/components/navigation_item.dart';
import 'package:dentaire/view/screens/student_screens/widgets/search_bar.dart';

class TrimestersModulesPage extends StatefulWidget {
  final String year;
  const TrimestersModulesPage({super.key, required this.year});

  @override
  State<TrimestersModulesPage> createState() => _TrimestersModulesPageState();
}

class _TrimestersModulesPageState extends State<TrimestersModulesPage> {
  int _currentIndex = 1;
  int selectedTrimester = 0;

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
                    Text(
                      "${widget.year} - DentSmart",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const Spacer(),
                    const Icon(Icons.notifications_none, color: Colors.white),
                  ],
                ),
              ),
              const SearchInput(),
              const SizedBox(height: 22),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: List.generate(3, (index) {
                          bool isSelected = index == selectedTrimester;
                          return ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isSelected
                                  ? const Color(0xFF0f3a5f)
                                  : const Color(0xFFe1eff7),
                              foregroundColor:
                                  isSelected ? Colors.white : Colors.black87,
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
                                Navigator.pushNamed(
                                  context,
                                  'videoslist',
                                  arguments: {'moduleName': moduleName},
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
      bottomNavigationBar: CustomNavBarTheme.getNavigationBar(
        index: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => HomeScreenStudent(selectedIndex: index),
            ),
          );
        },
        itemsList: const [
          NavItem(icon: Icons.home, label: "Acceuil"),
          NavItem(icon: Icons.list, label: "Modules"),
          NavItem(icon: Icons.favorite, label: "Favoris"),
          NavItem(icon: Icons.settings, label: "Param"),
          NavItem(icon: Icons.person, label: "Profile"),
        ],
      ),
    );
  }
}
