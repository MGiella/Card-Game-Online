import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:battle_spirits_online/features/cards/data/local/cards_dao.dart';
import 'package:battle_spirits_online/features/cards/domain/card_model.dart';

class DeckBuilderPage extends ConsumerStatefulWidget {
  const DeckBuilderPage({super.key});

  @override
  ConsumerState<DeckBuilderPage> createState() => _DeckBuilderPageState();
}

class _DeckBuilderPageState extends ConsumerState<DeckBuilderPage> {
  List<CardModel> deck = [];
  CardModel? selectedCard;
  String filterText = "";
  String? filterColor;
  int? filterCost;
  String? filterType;
  String? filterRarity;
  String? filterSet;
  String? filterFamily;

  List<CardModel> applyFilters(List<CardModel> cards) {
  return cards.where((card) {
    // 🔍 Testo nel nome
    if (filterText.isNotEmpty &&
        !card.nameEn.toLowerCase().contains(filterText.toLowerCase())) {
      return false;
    }

    // 🎨 Colore
    if (filterColor != null && filterColor!.isNotEmpty) {
      if (card.color != filterColor) return false;
    }

    // 💠 Costo
    if (filterCost != null) {
      if (card.cost != filterCost) return false;
    }

    // 🧩 Tipo
    if (filterType != null && filterType!.isNotEmpty) {
      if (card.type != filterType) return false;
    }

    // ⭐ Rarità
    if (filterRarity != null && filterRarity!.isNotEmpty) {
      if (card.rarity != filterRarity) return false;
    }

    // 📦 Set
    if (filterSet != null && filterSet!.isNotEmpty) {
      if (card.set != filterSet) return false;
    }

    // 🐉 Famiglia
  if (filterFamily != null && filterFamily!.isNotEmpty) {
      final families = card.family
          ?.split(RegExp(r'[/,]')) // supporta "/" o ","
          .map((f) => f.trim())
          .where((f) => f.isNotEmpty)
          .toList();

      if (!families!.contains(filterFamily)) return false;
    }
    return true;
  }).toList();
}


  @override
  Widget build(BuildContext context) {
    final dao = ref.read(cardsDaoProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Deck Builder"),
        centerTitle: true,
      ),
      body: FutureBuilder<List<CardModel>>(
        future: dao.getAllCards(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final allCards = snapshot.data!;

          return Row(
            children: [
              // ---------------------------------------------------
// 1) COLONNA SINISTRA - DETTAGLIO CARTA
// ---------------------------------------------------
Expanded(
  flex: 2,
  child: selectedCard == null
      ? const Center(child: Text("Seleziona una carta"))
      : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),

            // 🔥 TITOLO GRANDE
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                selectedCard!.nameEn,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 10),

            // 🔥 Tipo e Famiglia
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Tipo: ${selectedCard!.type}",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 4),

                  if (selectedCard!.family?.isNotEmpty ?? false)
                    Text(
                      "Famiglia: ${selectedCard!.family}",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // 🔥 IMMAGINE
            Expanded(
              child: selectedCard!.imageLocalPath != null &&
                      File(selectedCard!.imageLocalPath!).existsSync()
                  ? Image.file(File(selectedCard!.imageLocalPath!))
                  : const Icon(Icons.image_not_supported, size: 100),
            ),

            // 🔥 EFFETTO
            Container(
              padding: const EdgeInsets.all(12),
              height: 180,
              child: SingleChildScrollView(
                child: Text(
                  selectedCard!.effectRaw ?? "Nessun effetto",
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),

            // 🔥 BOTTONE AGGIUNGI
            Center(
              child: ElevatedButton(
                onPressed: () {
                  setState(() => deck.add(selectedCard!));
                },
                child: const Text("Aggiungi al deck"),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
),
              // ---------------------------------------------------
              // 2) COLONNA CENTRALE - DECK (GRIGLIA + DRAG TARGET)
              // ---------------------------------------------------
              Expanded(
                flex: 3,
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("Deck", style: TextStyle(fontSize: 18)),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.sort),
                        ),
                      ],
                    ),

                    Expanded(
                      child: DragTarget<CardModel>(
                        onWillAccept: (data) => true,
                        onAccept: (card) {
                          setState(() => deck.add(card));
                        },
                        builder: (context, _, __) {
                          return GridView.builder(
                            padding: const EdgeInsets.all(8),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              childAspectRatio: 0.75,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 8,
                            ),
                            itemCount: deck.length,
                            itemBuilder: (context, index) {
                              final card = deck[index];
                              final file = File(card.imageLocalPath ?? "");

                              return Draggable<CardModel>(
                                data: card,
                                feedback: SizedBox(
                                  width: 120,
                                  child: file.existsSync()
                                      ? Image.file(file)
                                      : const Icon(Icons.image_not_supported),
                                ),
                                childWhenDragging: Opacity(
                                  opacity: 0.3,
                                  child: _deckTile(card, file),
                                ),
                                child: GestureDetector(
                                  onTap: () => setState(() => selectedCard = card),
                                  child: _deckTile(card, file),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),

                    // CESTINO PER DRAG-OUT DELETE
                    DragTarget<CardModel>(
                      onAccept: (card) {
                        setState(() => deck.remove(card));
                      },
                      builder: (context, _, __) {
                        return Container(
                          height: 60,
                          color: Colors.red.withOpacity(0.2),
                          child: const Center(
                            child: Icon(Icons.delete, color: Colors.red, size: 30),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

// ---------------------------------------------------
// 3) COLONNA DESTRA - LISTA CARTE (FILTRI + GRIGLIA)
// ---------------------------------------------------
Expanded(
  flex: 4,
  child: Column(
    children: [
      // 🔍 FILTRI
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          children: [
            // Ricerca testuale
            TextField(
              decoration: const InputDecoration(
                hintText: "Cerca per nome...",
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() => filterText = value);
              },
            ),

            const SizedBox(height: 8),

            Row(
              children: [
                // 🎨 Colore
                DropdownButton<String>(
                  hint: const Text("Colore"),
                  value: filterColor,
                  items: [
                    const DropdownMenuItem(value: "", child: Text("No Filter")),
                    ...["Red", "Blue", "Green", "White", "Yellow", "Purple"]
                        .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                  ],
                  onChanged: (value) {
                    setState(() => filterColor = value!.isEmpty ? null : value);
                  },
                ),

                const SizedBox(width: 12),

                // 💠 Costo
                DropdownButton<int>(
                  hint: const Text("Costo"),
                  value: filterCost,
                  items: [
                    const DropdownMenuItem(value: -1, child: Text("No Filter")),
                    ...List.generate(13, (i) => i)
                        .map((c) => DropdownMenuItem(value: c, child: Text("$c")))
                  ],
                  onChanged: (value) {
                    setState(() => filterCost = value == -1 ? null : value);
                  },
                ),

                const SizedBox(width: 12),

                // 🧩 Tipo
                DropdownButton<String>(
                  hint: const Text("Tipo"),
                  value: filterType,
                  items: [
                    const DropdownMenuItem(value: "", child: Text("No Filter")),
                    ...["Spirit", "Magic", "Nexus"]
                        .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                  ],
                  onChanged: (value) {
                    setState(() => filterType = value!.isEmpty ? null : value);
                  },
                ),
              ],
            ),

            Row(
              children: [
                // ⭐ Rarità
                DropdownButton<String>(
                  hint: const Text("Rarità"),
                  value: filterRarity,
                  items: [
                    const DropdownMenuItem(value: "", child: Text("No Filter")),
                    ...["C", "U", "R", "M", "X"]
                        .map((r) => DropdownMenuItem(value: r, child: Text(r)))
                  ],
                  onChanged: (value) {
                    setState(() => filterRarity = value!.isEmpty ? null : value);
                  },
                ),

                const SizedBox(width: 12),

                // 📦 Set
                DropdownButton<String>(
                  hint: const Text("Set"),
                  value: filterSet,
                  items: [
                    const DropdownMenuItem(value: "", child: Text("No Filter")),
                    ...allCards
                        .map((c) => c.set)
                        .toSet()
                        .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                  ],
                  onChanged: (value) {
                    setState(() => filterSet = value!.isEmpty ? null : value);
                  },
                ),

                const SizedBox(width: 12),

                // 🐉 Famiglia
                DropdownButton<String>(
                  hint: const Text("Famiglia"),
                  value: filterFamily,
                  items: [
                    const DropdownMenuItem(value: "", child: Text("No Filter")),
                  ...allCards
                    .expand((c) => c.family
                        ?.split(RegExp(r'[/,]'))
                        .map((f) => f.trim())
                        .where((f) => f.isNotEmpty)
                        .toList() ??
                    [])
                    .toSet()
                    .map((f) => DropdownMenuItem(value: f, child: Text(f)))

                  ],
                  onChanged: (value) {
                    setState(() => filterFamily = value!.isEmpty ? null : value);
                  },
                ),
              ],
            ),
          ],
        ),
      ),

      const SizedBox(height: 8),

      // 🔥 GRIGLIA CARTE FILTRATE
      Expanded(
        child: Builder(
          builder: (context) {
            final filteredCards = applyFilters(allCards);

            return GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                childAspectRatio: 0.75,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: filteredCards.length,
              itemBuilder: (context, index) {
                final card = filteredCards[index];
                final file = File(card.imageLocalPath ?? "");

                return Draggable<CardModel>(
                  data: card,
                  feedback: SizedBox(
                    width: 120,
                    child: file.existsSync()
                        ? Image.file(file)
                        : const Icon(Icons.image_not_supported),
                  ),
                  child: GestureDetector(
                    onTap: () => setState(() => selectedCard = card),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.black12),
                      ),
                      child: Column(
                        children: [
                          Expanded(
                            child: file.existsSync()
                                ? Image.file(file)
                                : const Icon(Icons.image_not_supported),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            card.nameEn,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    ],
  ),
),
            ],
          );
        },
      ),
    );
  }

Widget _deckTile(CardModel card, File file) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.black12),
      ),
      child: Column(
        children: [
          Expanded(
            child: file.existsSync()
                ? Image.file(file)
                : const Icon(Icons.image_not_supported),
          ),
          const SizedBox(height: 4),
          Text(
            card.nameEn,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
