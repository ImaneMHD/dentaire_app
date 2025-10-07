import 'package:flutter/material.dart';

class AdminScaffold extends StatelessWidget {
  final String? title;
  final PreferredSizeWidget? appBar;
  final Widget body;
  final List<Map<String, dynamic>> notifications;
  final Widget? floatingActionButton; // ✅ ajout

  const AdminScaffold({
    super.key,
    this.title,
    this.appBar,
    required this.body,
    required this.notifications,
    this.floatingActionButton, // ✅ ajout
  });

  void _showNotificationsPanel(BuildContext context) {
    // ... ton code notifications ici
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ListView(
          children: notifications
              .map((notif) => ListTile(
                    leading: Icon(notif["icon"] as IconData? ?? Icons.info),
                    title: Text(notif["title"] ?? ""),
                  ))
              .toList(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar ??
          AppBar(
            title: Text(title ?? ''),
            backgroundColor: const Color(0xFF1A6175),
            actions: [
              IconButton(
                icon: const Icon(Icons.notifications),
                onPressed: () => _showNotificationsPanel(context),
              ),
            ],
          ),
      body: body,
      floatingActionButton:
          floatingActionButton, // ✅ maintenant utilisable depuis TeachersPage
    );
  }
}
