import 'package:flutter/material.dart';
import 'package:battle_spirits_online/features/cards/presentation/card_selector_dialog.dart';

class DeckBuilderPage extends StatefulWidget {
  const DeckBuilderPage({super.key});

  @override
  State<DeckBuilderPage> createState() => _DeckBuilderPageState();
}

class _DeckBuilderPageState extends State<DeckBuilderPage> {
  List<String> cardIds = []; // per ora solo ID

  void _addCard(String cardId) {
    setState(() {
      cardIds.add(cardId);
    });
  }

  void _removeCard(String cardId) {
    setState(() {
      cardIds.remove(cardId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Deck Builder"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _openCardSelector();
        },
        label: const Text("Aggiungi carta"),
        icon: const Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: cardIds.length,
        itemBuilder: (context, index) {
          final id = cardIds[index];
          return ListTile(
            title: Text("Carta: $id"),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => _removeCard(id),
            ),
          );
        },
      ),
    );
  }

  void _openCardSelector() async {
    final selectedId = await showDialog<String>(
      context: context,
        builder: (_) => const CardSelectorDialog(),
      );

    if (selectedId != null) {
      _addCard(selectedId);
    }
  }
}
