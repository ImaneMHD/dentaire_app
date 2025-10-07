import 'package:flutter/material.dart';

class SearchInput extends StatefulWidget {
  const SearchInput({Key? key}) : super(key: key);

  @override
  State<SearchInput> createState() => _SearchInputState();
}

class _SearchInputState extends State<SearchInput> {
  late FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Center(
      child: SizedBox(
        width: screenWidth * 0.85, // 85% de la largeur de l'écran
        child: Stack(
          children: [
            // Le champ réel
            TextField(
              focusNode: _focusNode,
              style: const TextStyle(fontSize: 16),
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                filled: true,
                fillColor: Colors.white,
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.black),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
              ),
            ),

            // Label + icône animés
            AnimatedPositioned(
              duration: const Duration(milliseconds: 200),
              left: 12,
              top: _isFocused ? 0 : 20,
              child: Row(
                children: [
                  Icon(Icons.search,
                      size: _isFocused ? 18 : 24, color: Colors.grey),
                  const SizedBox(width: 4),
                  AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 200),
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: _isFocused ? 16 : 20,
                      fontWeight: FontWeight.w500,
                    ),
                    child: const Text("Rechercher..."),
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
