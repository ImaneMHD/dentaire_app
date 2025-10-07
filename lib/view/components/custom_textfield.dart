import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final Icon icon;
  final TextEditingController controller;
  final String Function(String?)? validator;
  final bool isObscure;
  final IconButton? suffixButon;

  const CustomTextField(
      {super.key,
      required this.hintText,
      required this.icon,
      required this.controller,
      this.validator,
      required this.isObscure,
      this.suffixButon});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return TextFormField(
      validator: validator,
      controller: controller,
      obscureText: isObscure,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(
            vertical: screenHeight * 0.02,
            horizontal: screenWidth * 0.04), // alligner le texte de la bordure
        prefixIconConstraints: BoxConstraints(
          minWidth: screenWidth *
              0.2, // Espace minimal pour éviter que l'icône soit collée
        ),
        suffixIconConstraints: BoxConstraints(
          minWidth: screenWidth *
              0.2, // Espace minimal pour éviter que l'icône soit collée
        ),
        // espace autour du texte
        hintText: hintText,
        prefixIcon: icon,
        suffixIcon: suffixButon,
        labelText: hintText,
      ),
    );
  }
}
