import 'dart:io';

import 'package:battle_spirits_online/features/cards/data/local/cards_dao.dart';
import 'package:battle_spirits_online/features/cards/domain/card_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class CardSelectorDialog extends ConsumerStatefulWidget {
  const CardSelectorDialog({super.key});

  @override
  ConsumerState<CardSelectorDialog> createState() => _CardSelectorDialogState();
}

class _CardSelectorDialogState extends ConsumerState<CardSelectorDialog> {
  String query = "";

  @override
  Widget build(BuildContext context) {
    final dao = ref.read(cardsDaoProvider);

    return AlertDialog(
      title: const Text("Seleziona una carta"),
      content: SizedBox(
        width: 450,
        height: 550,
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                hintText: "Cerca per nome o numero...",
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                  query = value;
                });
              },
            ),
            const SizedBox(height: 12),
            Expanded(
              child: FutureBuilder<List<CardModel>>(
                future: dao.searchCards(query),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final cards = snapshot.data!;

                  if (cards.isEmpty) {
                    return const Center(child: Text("Nessuna carta trovata"));
                  }

                  return ListView.builder(
                    itemCount: cards.length,
                    itemBuilder: (context, index) {
                      final card = cards[index];
                      return ListTile(
                        leading: card.imageLocalPath != null
                            ? Image.file(
                                File(card.imageLocalPath!),
                                width: 40,
                                height: 40,
                                fit: BoxFit.cover,
                              )
                            : const Icon(Icons.image_not_supported),
                        title: Text("${card.cardNumber} — ${card.nameEn}"),
                        subtitle: Text(card.type),
                        onTap: () => Navigator.pop(context, card.id),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
