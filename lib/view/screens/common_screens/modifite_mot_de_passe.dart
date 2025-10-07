import 'package:dentaire/view/screens/common_screens/password_screen.dart';
import 'package:flutter/material.dart';

void showPasswordChangeDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      content: const Text("Voulez-vous changer votre mot de passe ?"),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context); // fermer le dialog
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const PasswordChangeScreen()),
            );
          },
          child: const Text("OK"),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context), // juste fermer
          child: const Text("Exit"),
        ),
      ],
    ),
  );
}
