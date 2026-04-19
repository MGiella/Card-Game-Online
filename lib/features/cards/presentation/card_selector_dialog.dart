import 'package:flutter/material.dart';

class CardSelectorDialog extends StatelessWidget {
  const CardSelectorDialog({super.key});

  @override
  Widget build(BuildContext context) {
    // MOCK: in futuro useremo il database Drift
    final mockCards = [
      "BS01-001",
      "BS01-002",
      "BS01-003",
    ];

    return AlertDialog(
      title: const Text("Seleziona una carta"),
      content: SizedBox(
        width: 400,
        height: 300,
        child: ListView.builder(
          itemCount: mockCards.length,
          itemBuilder: (context, index) {
            final id = mockCards[index];
            return ListTile(
              title: Text(id),
              onTap: () => Navigator.pop(context, id),
            );
          },
        ),
      ),
    );
  }
}
