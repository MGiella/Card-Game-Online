class DeckModel {
  final String id;
  final String name;
  final List<String> cardIds; // solo gli ID delle carte

  DeckModel({
    required this.id,
    required this.name,
    required this.cardIds,
  });

  DeckModel copyWith({
    String? id,
    String? name,
    List<String>? cardIds,
  }) {
    return DeckModel(
      id: id ?? this.id,
      name: name ?? this.name,
      cardIds: cardIds ?? this.cardIds,
    );
  }
}
