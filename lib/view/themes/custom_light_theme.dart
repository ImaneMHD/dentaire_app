import 'package:flutter/material.dart';

class LightThemes {
////////////////////////// Thème clair///////////////////////////////
  static final ThemeData lightTheme1 = ThemeData(
    ///////*** App bar theme (style des app bar) ***//////
    scaffoldBackgroundColor: const Color(0xffc5f3fd),
    appBarTheme: const AppBarTheme(
      color: Color(0xff065464), // Couleur de fond
      elevation: 15, // Ombre sous l'AppBar
      shadowColor: Color(0xffaae3ef), // Couleur de l'ombre
      titleTextStyle: TextStyle(
          // style du titre
          color: Color(0xffaae3ef),
          fontSize: 24,
          fontWeight: FontWeight.bold,
          fontFamily: 'ComicSans'),
      iconTheme: IconThemeData(
        // style des icones
        color: Color(0xffaae3ef), // Couleur des icônes (ex: bouton retour)
      ),
      actionsIconTheme: IconThemeData(
        // style des boutons d'action
        color: Color(0xffaae3ef), // Couleur des icônes dans `actions: []`
      ),
    ),
    // La couleur par défault
    primarySwatch: Colors.blueGrey,
    brightness: Brightness.light, // en mode clair

    ///////*** Text theme (style des textes) ***//////
    textTheme: const TextTheme(
      bodyLarge: TextStyle(
          // le premier style pour le texte large
          fontWeight: FontWeight.bold,
          fontFamily: 'ComicSans',
          fontStyle: FontStyle.italic,
          fontSize: 28,
          color: Color(0xff033244)),
      bodyMedium: TextStyle(
          // le deuxième style pour le texte moyen
          fontWeight: FontWeight.bold,
          fontFamily: 'ComicSans',
          fontStyle: FontStyle.italic,
          fontSize: 20,
          color: Color(0xff033244)),
      bodySmall: TextStyle(
          // le troisième style pour le texte petit
          fontWeight: FontWeight.normal,
          fontFamily: 'ComicSans',
          fontStyle: FontStyle.italic,
          fontSize: 4,
          color: Color(0xff033244)),
    ),

    ///////*** Input decoration theme (style des TextField) ***//////
    inputDecorationTheme: InputDecorationTheme(
        filled: true, // remplir le fond avec la couleur du fond
        fillColor: Colors.white,
        // couleur du fond

        // Le style par défaut de la bordure (quand le champ n'est pas sélectionné)
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: const BorderSide(color: Color(0xffcbc7c7), width: 2),
        ),
        // Le style de la bordure quand le champ est sélectionné
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: const BorderSide(color: Color(0xff033244), width: 5),
        ),
        hintStyle: const TextStyle(color: Colors.grey), // style du texte indice
        prefixIconColor: const Color(0xff033244), // couleur de l'icon prefix
        suffixIconColor: const Color(0xff033244), // couleur de l'icone suffix
        labelStyle: TextStyle(
            // style du label
            fontSize: 15,
            backgroundColor: Colors.transparent,
            color: Colors.grey,
            fontWeight: FontWeight.normal,
            fontStyle: FontStyle.normal,
            fontFamily: 'TimeNewRoman')),

    ///////*** Buttons theme (style des ElevatedButton) ***//////

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xff065464), //  Couleur de fond visible
        foregroundColor: Colors.grey, //  Couleur du texte et icône
        //   padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
        shape: RoundedRectangleBorder(
          side: const BorderSide(
            color: Color(0xff173542), //  Couleur du trait
            width: 3, //  Épaisseur du trait
            style:
                BorderStyle.solid, //  Style du trait (dotted, dashed non dispo)
          ),
          borderRadius: BorderRadius.circular(15), //  Coins arrondis
        ),
        shadowColor: const Color(0x8a080808), //  Ombre
        elevation: (20), //  Effet d'élévation
      ),
    ),

    ///////*** List tile theme (style des ListView) ***//////
    listTileTheme: ListTileThemeData(
      tileColor: const Color(0xff58d7f1),
      textColor: Colors.black,
      iconColor: const Color(0xff636160),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: const Color(0xff065464), // Couleur de fond
      foregroundColor: Colors.white, // Couleur de l'icône/text
      elevation: 20, //  Ombre du bouton
      shape: RoundedRectangleBorder(
        //  Forme personnalisée
        borderRadius: BorderRadius.circular(50),
      ),
      sizeConstraints: BoxConstraints.tightFor(
          width: 100, height: 60), //  Taille personnalisée
    ),
    cardTheme: CardTheme(
      color: const Color(0xffd24b4b), //  Couleur de fond de la carte
      shadowColor: Colors.grey.withOpacity(0.5), //  Ombre
      elevation: 5, //  Hauteur de l'ombre
      shape: RoundedRectangleBorder(
        //  Bordures arrondies
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.blue, width: 2),
      ),
      margin: EdgeInsets.all(8), //  Marge autour des cartes),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.white, // Couleur de fond
      selectedItemColor: Colors.blue, // Couleur de l'icône sélectionnée
      unselectedItemColor: Colors.grey, // Couleur des icônes non sélectionnées
      showSelectedLabels: true, // Afficher le texte des items sélectionnés
      showUnselectedLabels: false,
      // Masquer le texte des items non sélectionnés
    ),
  );
}
