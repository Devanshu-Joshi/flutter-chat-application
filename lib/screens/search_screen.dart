import 'package:flutter/material.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {    return Scaffold(
    backgroundColor: Theme.of(context).colorScheme.surface,
    body: Center(
      child: Text(
        "Search",
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurface,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
  }
}