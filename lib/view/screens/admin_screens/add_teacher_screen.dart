import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddTeacherPage extends StatefulWidget {
  const AddTeacherPage({super.key});

  @override
  State<AddTeacherPage> createState() => _AddTeacherPageState();
}

class _AddTeacherPageState extends State<AddTeacherPage> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String _firstName = '';
  String _lastName = '';
  String _email = '';
  String _password = '';
  String _specialite = '';
  bool _isLoading = false;

  // Structure pour stocker les modules par année et trimestre
  Map<int, Map<int, List<TextEditingController>>> _modulesControllers = {};

  // Liste des années et trimestres
  final List<int> years = [1, 2, 3, 4, 5];
  final List<int> trimesters = [1, 2, 3];

  @override
  void initState() {
    super.initState();
    // Initialisation des contrôleurs
    for (var year in years) {
      _modulesControllers[year] = {};
      for (var trimester in trimesters) {
        _modulesControllers[year]![trimester] = [TextEditingController()];
      }
    }
  }

  @override
  void dispose() {
    // Dispose tous les controllers
    for (var yearControllers in _modulesControllers.values) {
      for (var trimesterControllers in yearControllers.values) {
        for (var ctrl in trimesterControllers) {
          ctrl.dispose();
        }
      }
    }
    super.dispose();
  }

  Future<void> _addTeacher() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    setState(() => _isLoading = true);

    try {
      // 1️⃣ Création du compte Auth
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: _email,
        password: _password,
      );
      final uid = userCredential.user!.uid;
      final fullName = '$_firstName $_lastName';

      // 2️⃣ Ajouter dans Users
      await FirebaseFirestore.instance.collection('Users').doc(uid).set({
        'uid': uid,
        'name': fullName,
        'email': _email,
        'role': 'teacher',
        'lastLogin': Timestamp.now(),
      });

      // 3️⃣ Ajouter dans Enseignants

      await FirebaseFirestore.instance.collection('enseignants').doc(uid).set({
        'uid': uid,
        'name': fullName,
        'email': _email,
        'specialite': _specialite,
        'createdAt': Timestamp.now(),
      });

      // 4️⃣ Ajouter les modules
      for (var yearEntry in _modulesControllers.entries) {
        int year = yearEntry.key;
        for (var trimesterEntry in yearEntry.value.entries) {
          int trimester = trimesterEntry.key;
          for (var ctrl in trimesterEntry.value) {
            String moduleName = ctrl.text.trim();
            if (moduleName.isEmpty) continue;
            await FirebaseFirestore.instance.collection('Modules').add({
              'moduleName': moduleName,
              'teacherId': uid,
              'year': year,
              'trimester': trimester,
              'createdAt': Timestamp.now(),
            });
          }
        }
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Enseignant et modules ajoutés avec succès !')),
        );
        Navigator.pop(context);
      }
    } on FirebaseAuthException catch (e) {
      String message;
      if (e.code == 'weak-password') {
        message = 'Le mot de passe fourni est trop faible.';
      } else if (e.code == 'email-already-in-use') {
        message = 'Un compte existe déjà pour cet email.';
      } else {
        message = 'Erreur d\'authentification : ${e.message}';
      }
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(message)));
      }
    } on FirebaseException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erreur Firestore: ${e.message}')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Erreur inattendue : $e')));
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // Widget pour saisir les modules par année et trimestre
  Widget _buildModuleInput() {
    return Column(
      children: years.map((year) {
        return ExpansionTile(
          title: Text('Année $year',
              style: const TextStyle(fontWeight: FontWeight.bold)),
          children: trimesters.map((trimester) {
            return ExpansionTile(
              title: Text('Trimestre $trimester'),
              children: [
                ..._modulesControllers[year]![trimester]!.map((ctrl) {
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    child: TextFormField(
                      controller: ctrl,
                      decoration: const InputDecoration(
                        labelText: 'Nom du module',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  );
                }).toList(),
                TextButton.icon(
                  onPressed: () {
                    setState(() {
                      _modulesControllers[year]![trimester]!
                          .add(TextEditingController());
                    });
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Ajouter un module'),
                ),
              ],
            );
          }).toList(),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajouter un nouvel enseignant'),
        backgroundColor: const Color(0xFF1A6175),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Prénom'),
                onSaved: (val) => _firstName = val ?? '',
                validator: (val) => val!.isEmpty ? 'Entrez le prénom' : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Nom'),
                onSaved: (val) => _lastName = val ?? '',
                validator: (val) => val!.isEmpty ? 'Entrez le nom' : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                onSaved: (val) => _email = val ?? '',
                validator: (val) => val!.isEmpty || !val.contains('@')
                    ? 'Email invalide'
                    : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Mot de passe'),
                obscureText: true,
                onSaved: (val) => _password = val ?? '',
                validator: (val) {
                  if (val == null || val.isEmpty)
                    return 'Entrez un mot de passe';
                  if (val.length < 6) return 'Minimum 6 caractères';
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Spécialité'),
                onSaved: (val) => _specialite = val ?? '',
                validator: (val) =>
                    val!.isEmpty ? 'Entrez la spécialité' : null,
              ),
              const SizedBox(height: 16),
              const Text(
                'Ajouter des modules par année et trimestre',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              _buildModuleInput(),
              const SizedBox(height: 20),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _addTeacher,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1A6175),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text('Ajouter',
                          style: TextStyle(color: Colors.white)),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
