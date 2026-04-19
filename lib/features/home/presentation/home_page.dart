import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Battle Spirits Online'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Background (per ora un colore, poi possiamo mettere un'immagine)
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.deepPurple, Colors.black],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          // Contenuto
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FilledButton(
                    onPressed: () => context.go('/decks'),
                    child: const Text('Deck Building'),
                  ),
                  const SizedBox(height: 16),

                  // Simulator (disattivato per ora)
                  FilledButton.tonal(
                    onPressed: null, // disabilitato
                    child: const Text('Simulator (coming soon)'),
                  ),
                  const SizedBox(height: 16),

                  // Settings
                  OutlinedButton(
                    onPressed: () {
                      // route futura
                    },
                    child: const Text('Settings'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
