import 'package:flutter/material.dart';

class HerbDirectoryScreen extends StatelessWidget {
  const HerbDirectoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Herb Directory'),
      ),
      body: const Center(
        child: Text(
          'Herb directory content will appear here.',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
