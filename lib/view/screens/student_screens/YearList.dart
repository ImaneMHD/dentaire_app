import 'package:flutter/material.dart';

class YearList extends StatelessWidget {
  const YearList({super.key});

  final List<String> years = const [
    "1ère année",
    "2ème année",
    "3ème année",
    "4ème année",
    "5ème année",
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: years.length,
      itemBuilder: (context, index) {
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.symmetric(vertical: 6),
          child: ListTile(
            tileColor: const Color(0xFFD9D9D9),
            leading: const Icon(Icons.school, color: Color(0xFF1A6175)),
            title: Text(
              years[index],
              style: const TextStyle(fontSize: 18),
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 18),
            onTap: () {
              Navigator.pushNamed(
                context,
                'Trimesters', // ✅ ce nom doit matcher exactement ce que tu as mis dans onGenerateRoute
                arguments: {'year': years[index]},
              );
            },
          ),
        );
      },
    );
  }
}
