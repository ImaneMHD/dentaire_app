import 'package:flutter/material.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController messageController = TextEditingController();

  // 🔹 Infos de contact de l'application (admin)
  final String adminName = "Admin Dentaire";
  final String adminEmail = "admin@dentaire.com";
  final String adminPhone = "+213 770 00 00 00";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contactez-nous'),
        backgroundColor: const Color(0xFF1A6175),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Section infos admin
            const Text(
              "Informations de contact",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A6175),
              ),
            ),
            const SizedBox(height: 10),
            _buildInfo(Icons.person, adminName),
            _buildInfo(Icons.email, adminEmail),
            _buildInfo(Icons.phone, adminPhone),
            const Divider(height: 30),

            // 🔹 Section formulaire
            const Text(
              "Envoyez-nous un message",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A6175),
              ),
            ),
            const SizedBox(height: 10),
            _buildField("Votre nom", nameController),
            _buildField("Votre email", emailController),
            _buildField("Votre message", messageController, maxLines: 5),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isNotEmpty &&
                    emailController.text.isNotEmpty &&
                    messageController.text.isNotEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          "Merci ${nameController.text}, votre message a été envoyé !"),
                    ),
                  );
                  nameController.clear();
                  emailController.clear();
                  messageController.clear();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1A6175),
                minimumSize: const Size.fromHeight(50),
              ),
              child: const Text("Envoyer"),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildField(String label, TextEditingController controller,
      {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildInfo(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF1A6175)),
          const SizedBox(width: 10),
          Text(text, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
