import 'package:flutter/material.dart';

class DecksPage extends StatelessWidget {
  const DecksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Deck Builder'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Qui apparirà il tuo deck',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () {
                // qui in futuro apriremo il Card Selector
              },
              child: const Text('Aggiungi carta'),
            ),
          ],
        ),
      ),
    );
  }
}
