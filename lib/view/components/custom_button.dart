import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final Function onPressedFct;
  final String label;
  final IconData? icon;

  const CustomButton(
      {super.key, required this.onPressedFct, required this.label, this.icon});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return SizedBox(
      height: screenHeight * 0.12,
      width: screenWidth * 0.45,
      child: ElevatedButton(
        onPressed: onPressedFct(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, size: screenWidth * 0.07),
              const SizedBox(width: 8),
            ],
            SizedBox(width: screenWidth * 0.01),
            Flexible(
              child: Text(
                maxLines: 1, // Empêche le texte de dépasser
                overflow: TextOverflow
                    .ellipsis, // Ajoute "..." si le texte est trop long
                label,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
