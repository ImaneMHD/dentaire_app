import 'package:flutter/material.dart';

class BaseScaffold extends StatelessWidget {
  final String title;
  final Widget body;

  const BaseScaffold({
    super.key,
    required this.body,
    this.title = '',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: title.isNotEmpty
          ? AppBar(
              title: Text(title),
              backgroundColor: const Color(0xFF4F9CB2),
            )
          : null,
      body: SafeArea(child: body),
    );
  }
}
