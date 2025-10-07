import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  final List<String> notifications = [
    "Nouvelle vidéo ajoutée au module Pathologie",
    "Votre quiz a été corrigé",
    "Nouveau commentaire sur une vidéo",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Notifications")),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(Icons.notifications),
            title: Text(notifications[index]),
          );
        },
      ),
    );
  }
}
