import 'dart:typed_data';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:csv/csv.dart';
import 'package:excel/excel.dart' as excel_pkg;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ImportFromExcelPage extends StatefulWidget {
  const ImportFromExcelPage({Key? key}) : super(key: key);

  @override
  _ImportFromExcelPageState createState() => _ImportFromExcelPageState();
}

class _ImportFromExcelPageState extends State<ImportFromExcelPage> {
  bool _isLoading = false;
  List<String> _resultMessages = [];

  // Transforme une ligne Excel (qui peut être nulle) en liste sécurisée de Strings
  List<String> _safeExcelRowValues(
      List<excel_pkg.Data?>? row, int expectedColumns) {
    if (row == null) {
      return List.generate(expectedColumns, (_) => "");
    }

    List<String> values = [];
    for (int i = 0; i < expectedColumns; i++) {
      if (i < row.length && row[i] != null) {
        var cellValue = row[i]!.value;
        if (cellValue != null) {
          values.add(cellValue.toString().trim());
        } else {
          values.add("");
        }
      } else {
        values.add("");
      }
    }
    return values;
  }

  // Transforme une ligne CSV (List<dynamic>) en liste sécurisée de Strings
  List<String> _safeCsvRowValues(List<dynamic> row, int expectedColumns) {
    List<String> values = [];
    for (int i = 0; i < expectedColumns; i++) {
      if (i < row.length && row[i] != null) {
        values.add(row[i].toString().trim());
      } else {
        values.add("");
      }
    }
    return values;
  }

  Future<void> _importStudents() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final String? currentTeacherId = auth.currentUser?.uid;

    if (currentTeacherId == null) {
      setState(() {
        _resultMessages
            .add("Erreur d'authentification : Veuillez vous reconnecter.");
        _isLoading = false;
      });
      return;
    }

    try {
      setState(() {
        _isLoading = true;
        _resultMessages.clear();
        _resultMessages.add("Démarrage de l'importation...");
      });

      // 1. Sélection du fichier
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx', 'csv'],
        withData: true,
      );

      if (result == null) {
        setState(() {
          _isLoading = false;
          _resultMessages.add("Import annulé");
        });
        return;
      }

      final file = result.files.single;
      Uint8List? fileBytes = file.bytes;
      final fileName = file.name.toLowerCase();

      if (fileBytes == null) {
        setState(() {
          _isLoading = false;
          _resultMessages
              .add("Impossible de lire le contenu du fichier (octets nuls).");
        });
        return;
      }

      List<List<String>> allRows = [];
      String fileType = "";

      // 2. Détection et lecture du format de fichier
      if (fileName.endsWith('.csv')) {
        fileType = "CSV";
        _resultMessages.add("Fichier détecté : CSV. Lecture en cours...");
        try {
          final String csvString = utf8.decode(fileBytes);
          // NOTE: Nous utilisons le délimiteur par défaut (virgule, ',')
          List<List<dynamic>> csvTable =
              const CsvToListConverter().convert(csvString);

          for (var row in csvTable) {
            allRows.add(_safeCsvRowValues(row, 6));
          }
        } catch (e) {
          // Si une erreur survient lors du décodage CSV
          setState(() {
            _isLoading = false;
            _resultMessages.add(
                "❌ Erreur critique de lecture CSV. Le fichier est peut-être corrompu ou l'encodage n'est pas UTF-8. Détail: $e");
          });
          return;
        }
      } else if (fileName.endsWith('.xlsx')) {
        fileType = "XLSX";
        _resultMessages.add("Fichier détecté : XLSX. Lecture en cours...");
        try {
          // --- Traitement XLSX ---
          var excel = excel_pkg.Excel.decodeBytes(fileBytes);

          if (excel.tables.isEmpty) {
            throw Exception("Aucune feuille de calcul trouvée.");
          }

          final sheetName = excel.tables.keys.first;
          final sheet = excel.tables[sheetName];

          if (sheet != null) {
            for (var row in sheet.rows) {
              allRows.add(_safeExcelRowValues(row, 6));
            }
          }
        } catch (e) {
          // Si une erreur survient lors de l'ouverture d'Excel
          setState(() {
            _isLoading = false;
            _resultMessages.add(
                "❌ Erreur critique de lecture XLSX. Le fichier Excel est peut-être corrompu, protégé par mot de passe, ou utilise un format non supporté. Détail: $e");
          });
          return;
        }
      } else {
        setState(() {
          _isLoading = false;
          _resultMessages.add(
              "Erreur: Format de fichier non supporté. Seuls .xlsx et .csv sont acceptés.");
        });
        return;
      }

      // 3. Vérification des données lues
      if (allRows.length <= 1) {
        // Vérifie qu'il y a au moins l'en-tête + une ligne de données
        setState(() {
          _isLoading = false;
          _resultMessages.add(
              "Erreur: Le fichier est vide ou la feuille de calcul n'a pas pu être lue correctement.");
        });
        return;
      }

      // 4. Traitement des lignes et ajout à Firestore
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      int importedCount = 0;
      int totalRows = allRows.length - 1;

      _resultMessages.add("Total des étudiants à traiter : $totalRows.");

      for (int rowIndex = 1; rowIndex < allRows.length; rowIndex++) {
        List<String> cells = allRows[rowIndex];

        // S'assurer d'avoir la bonne taille pour éviter RangeError plus tard
        while (cells.length < 6) {
          cells.add("");
        }

        // Lignes vides
        if (cells.every((cell) => cell.isEmpty)) {
          _resultMessages
              .add("Ligne ${rowIndex + 1} ignorée : Ligne entièrement vide");
          continue;
        }

        // 0: Compte, 1: Nom, 2: Prénom, 3: Email, 4: Password, 5: Année
        String compte = cells[0].isNotEmpty ? cells[0] : "undefined";
        String nom = cells[1];
        String prenom = cells[2];
        String email = cells[3].toLowerCase();
        String password =
            cells[4].isNotEmpty && cells[4].length >= 6 ? cells[4] : "123456";
        String annee = cells[5].isNotEmpty ? cells[5] : "1";

        // Validation des champs
        if (email.isEmpty || !email.contains('@')) {
          _resultMessages.add(
              "❌ Ligne ${rowIndex + 1} ignorée : Email invalide ou vide ($email)");
          continue;
        }
        if (nom.isEmpty || prenom.isEmpty) {
          _resultMessages
              .add("❌ Ligne ${rowIndex + 1} ignorée : Nom ou Prénom manquant");
          continue;
        }

        try {
          // Création utilisateur FirebaseAuth et Firestore
          UserCredential userCredential =
              await auth.createUserWithEmailAndPassword(
            email: email,
            password: password,
          );
          String uid = userCredential.user!.uid;

          await firestore.collection("Users").doc(uid).set({
            "uid": uid,
            "compte": compte,
            "nom": nom,
            "prenom": prenom,
            "name": "$nom $prenom",
            "email": email,
            "role": "etudiant",
            "annee": annee,
            "teacherId": currentTeacherId,
            "createdAt": FieldValue.serverTimestamp(),
          });

          // Stockage dans "Etudiants"

          await firestore.collection("Etudiants").doc(uid).set({
            "uid": uid,
            "compte": compte,
            "nom": nom,
            "prenom": prenom,
            "name": "$nom $prenom",
            "email": email,
            "annee": annee,
            "teacherId": currentTeacherId,
            "createdAt": FieldValue.serverTimestamp(),
          });

          importedCount++;
          _resultMessages
              .add("✅ Ligne ${rowIndex + 1} ($nom $prenom) ajoutée.");
        } on FirebaseAuthException catch (e) {
          String errorMsg = e.code == 'email-already-in-use'
              ? "Email déjà utilisé. Aucune modification effectuée."
              : "Erreur Auth: ${e.code}";
          _resultMessages.add("❌ Ligne ${rowIndex + 1} ($email) : $errorMsg");
        } catch (e) {
          _resultMessages.add(
              "❌ Ligne ${rowIndex + 1} ($email) : Erreur interne (Firestore) : $e");
        }

        if (mounted) setState(() {});
      }

      setState(() {
        _isLoading = false;
        _resultMessages.add("---");
        _resultMessages.add(
            "Import terminé : $importedCount étudiants sur $totalRows lignes traitées.");
      });
    } catch (e) {
      // Ce catch attrape toutes les erreurs non prévues par les catches précédents
      setState(() {
        _isLoading = false;
        _resultMessages.add("---");
        _resultMessages.add("❌ ERREUR MAJEURE D'IMPORTATION. Détail: $e");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Importer des étudiants"),
        backgroundColor: const Color(0xFF1A6175),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                  color: Colors.blueGrey[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blueGrey.shade200)),
              child: const Text(
                "Le fichier doit être au format **.xlsx** ou **.csv** et contenir les colonnes suivantes dans cet ordre (la première ligne sera ignorée comme en-tête) :\n1. Compte (optionnel)\n2. Nom\n3. Prénom\n4. Email (obligatoire)\n5. Mot de passe (min 6 caractères, '123456' par défaut)\n6. Année (ex: 1)",
                style: TextStyle(fontSize: 12),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1A6175),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: _isLoading ? null : _importStudents,
              icon: _isLoading
                  ? const SizedBox(
                      width: 15,
                      height: 15,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2),
                    )
                  : const Icon(Icons.file_upload),
              label: Text(_isLoading
                  ? "Importation en cours..."
                  : "Importer le fichier Étudiants"),
            ),
            const SizedBox(height: 20),
            // Affichage des messages
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ListView.builder(
                  itemCount: _resultMessages.length,
                  itemBuilder: (context, index) {
                    final message = _resultMessages[index];
                    Color color = message.startsWith('❌')
                        ? Colors.red.shade700
                        : (message.startsWith('✅')
                            ? Colors.green.shade700
                            : Colors.black87);
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Text(message,
                          style: TextStyle(color: color, fontSize: 13)),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
