import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

class CustomNavBarTheme {
  static CurvedNavigationBar getNavigationBar(
      {required int index, required itemsList, required Function(int) onTap}) {
    return CurvedNavigationBar(
      backgroundColor:
          const Color(0xffD9D9D9), // Couleur d'arrière-plan derrière la barre
      buttonBackgroundColor: const Color(0xff065464), // Fond du bouton actif
      color: const Color(0xff065464), // Couleur de la barre
      height: 60, // Hauteur de la barre
      animationDuration:
          const Duration(microseconds: 5000), // Durée de l'animation
      animationCurve: Curves.bounceIn, // Courbe d'animation
      index: index, // Index actuel
      items: itemsList,
      onTap: onTap, // Fonction exécutée lorsqu'on appuie sur un item
    );
  }
}
