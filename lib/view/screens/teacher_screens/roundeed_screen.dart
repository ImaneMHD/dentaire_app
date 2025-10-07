import 'package:dentaire/view/screens/teacher_screens/add_student_screen.dart';
import 'package:dentaire/view/screens/teacher_screens/lists_etudiants_screen.dart';
import 'package:dentaire/view/screens/teacher_screens/import_from_excel.dart'; // ⚡ Nouveau fichier à créer
import 'package:flutter/material.dart';

class RoundedPanelScreen extends StatelessWidget {
  final VoidCallback onClose;

  const RoundedPanelScreen({Key? key, required this.onClose}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.55,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 12,
              offset: Offset(0, -3),
            ),
          ],
        ),
        child: Column(
          children: [
            const SizedBox(height: 16),
            Container(
              width: 40,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Gestion des étudiants",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 30),

            // Boutons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1A6175),
                      minimumSize: const Size.fromHeight(50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      onClose();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ListEtudiantsPage(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.list_alt),
                    label: const Text("Liste des étudiants"),
                  ),
                  const SizedBox(height: 16),

                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1A6175),
                      minimumSize: const Size.fromHeight(50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      onClose();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddStudentPage(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.person_add),
                    label: const Text("Ajouter un étudiant"),
                  ),
                  const SizedBox(height: 16),

                  // ⚡ Nouveau bouton : Importer depuis Excel
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1A6175),
                      minimumSize: const Size.fromHeight(50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      onClose();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ImportFromExcelPage(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.file_upload),
                    label: const Text("Importer depuis Excel"),
                  ),

                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: onClose,
                    child: const Text("Fermer"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
