import 'package:dentaire/statemanagement/bloc/authentification/auth_service.dart';
import 'package:dentaire/view/screens/admin_screens/home_screen_admi.dart';
import 'package:dentaire/view/screens/student_screens/home_screen_student.dart';
import 'package:dentaire/view/screens/teacher_screens/home_screen_teacher.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  String _errorMessage = '';
  bool _obscurePassword = true; // <-- bool pour afficher/cacher le mot de passe

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      // Connexion
      await AuthService().signIn(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Récupérer utilisateur + rôle
      final currentUser = await AuthService().getCurrentUserWithRole();

      if (currentUser != null && mounted) {
        final role = currentUser["role"];
        if (role == "admin") {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const HomeScreenAdmin()),
            (Route<dynamic> route) => false,
          );
        } else if (role == "teacher") {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const HomeScreenTeacher()),
            (Route<dynamic> route) => false,
          );
        } else if (role == "etudiant") {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const HomeScreenStudent()),
            (Route<dynamic> route) => false,
          );
        } else {
          setState(() {
            _errorMessage = "Rôle inconnu : $role";
          });
        }
      } else {
        setState(() {
          _errorMessage = "Impossible de récupérer le rôle de l'utilisateur.";
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = "Erreur : $e";
      });
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0f3a5f),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF4F9CB2), Color(0xff065464)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 50,
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 60, color: Colors.grey),
              ),
              const SizedBox(height: 40),
              TextFormField(
                controller: _emailController,
                validator: (val) =>
                    val!.contains('@') ? null : "Email invalide",
                decoration: InputDecoration(
                  hintText: 'Email',
                  prefixIcon: const Icon(Icons.person),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Champ mot de passe avec affichage/masquage
              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                validator: (val) => val!.isEmpty ? "Champ requis" : null,
                decoration: InputDecoration(
                  hintText: 'Password',
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              if (_errorMessage.isNotEmpty)
                Text(
                  _errorMessage,
                  style: const TextStyle(color: Colors.red, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              const SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0A3F4D),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: _isLoading ? null : _login,
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Log in"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
