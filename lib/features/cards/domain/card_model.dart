import 'package:battle_spirits_online/features/cards/domain/card_level.dart';

class CardModel {
  final String id;
  final String cardNumber;
  final String nameEn;
  final String type;
  final String color;
  final int cost;
  final List<CardLevel> levels;
  final String rarity;
  final String set;
  final String imageUrl;
  final String effectTextRewrite;
  final List<String> keywords;
  final List<String> parallelVariants;
  final DateTime? releaseDate;

  

  const CardModel({
    required this.id,
    required this.cardNumber,
    required this.nameEn,
    required this.type,
    required this.color,
    required this.cost,
    required this.levels,
    required this.rarity,
    required this.set,
    required this.imageUrl,
    required this.effectTextRewrite,
    required this.keywords,
    required this.parallelVariants,
    this.releaseDate,
  });

  factory CardModel.fromJson(Map<String, dynamic> json) {
    return CardModel(
      id: json['id'],
      cardNumber: json['cardNumber'],
      nameEn: json['nameEn'],
      type: json['type'],
      color: json['color'],
      cost: json['cost'],
      levels: (json['levels'] as List)
          .map((e) => CardLevel.fromJson(e))
          .toList(),
      rarity: json['rarity'],
      set: json['set'],
      imageUrl: json['imageUrl'],
      effectTextRewrite: json['effectTextRewrite'] ?? '',
      keywords: List<String>.from(json['keywords'] ?? []),
      parallelVariants: List<String>.from(json['parallelVariants'] ?? []),
      releaseDate: json['releaseDate'] != null
          ? DateTime.parse(json['releaseDate'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'cardNumber': cardNumber,
        'nameEn': nameEn,
        'type': type,
        'color': color,
        'cost': cost,
        'levels': levels.map((l) => l.toJson()).toList(),
        'rarity': rarity,
        'set': set,
        'imageUrl': imageUrl,
        'effectTextRewrite': effectTextRewrite,
        'keywords': keywords,
        'parallelVariants': parallelVariants,
        'releaseDate': releaseDate?.toIso8601String(),
      };
}
