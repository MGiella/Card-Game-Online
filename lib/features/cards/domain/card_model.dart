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
  final String imageUrl; // URL remoto
  final String effectTextRewrite;
  final List<String> keywords;
  final List<String> parallelVariants;
  final DateTime? releaseDate;

  // 🆕 AGGIUNTO
  final String? family;

  // 🔥 Campi locali (non nel JSON pubblico)
  final String? imageLocalPath;
  final bool imageDownloaded;
  final String? effectRaw;
  final DateTime? effectScrapedAt;

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
    required this.family, // 🆕 AGGIUNTO
    this.releaseDate,

    // Campi locali
    this.imageLocalPath,
    this.imageDownloaded = false,
    this.effectRaw,
    this.effectScrapedAt,
  });

  factory CardModel.fromJson(Map<String, dynamic> json) {
    return CardModel(
      id: json['id'],
      cardNumber: json['cardNumber'],
      nameEn: json['nameEn'],
      type: json['type'],
      color: json['color'],
      cost: json['cost'],
      levels: (json['levels'] as List? ?? [])
          .map((e) => CardLevel.fromJson(e))
          .toList(),
      rarity: json['rarity'],
      set: json['set'],
      imageUrl: json['imageUrl'],
      effectTextRewrite: json['effectTextRewrite'] ?? '',
      keywords: List<String>.from(json['keywords'] ?? []),
      parallelVariants: List<String>.from(json['parallelVariants'] ?? []),

      // 🆕 AGGIUNTO
      family: json['family'] ?? "",

      releaseDate: json['releaseDate'] != null
          ? DateTime.parse(json['releaseDate'])
          : null,

      // Campi locali NON presenti nel JSON → default
      imageLocalPath: null,
      imageDownloaded: false,
      effectRaw: json['effectRaw'], // utile se importi dal DB
      effectScrapedAt: json['effectScrapedAt'] != null
          ? DateTime.parse(json['effectScrapedAt'])
          : null,
    );
  }

  CardModel copyWith({
    String? imageLocalPath,
    bool? imageDownloaded,
    String? effectRaw,
    DateTime? effectScrapedAt,
  }) {
    return CardModel(
      id: id,
      cardNumber: cardNumber,
      nameEn: nameEn,
      type: type,
      color: color,
      cost: cost,
      levels: levels,
      rarity: rarity,
      set: set,
      imageUrl: imageUrl,
      effectTextRewrite: effectTextRewrite,
      keywords: keywords,
      parallelVariants: parallelVariants,
      family: family, // 🆕 NON si modifica qui
      releaseDate: releaseDate,

      // Campi locali aggiornabili
      imageLocalPath: imageLocalPath ?? this.imageLocalPath,
      imageDownloaded: imageDownloaded ?? this.imageDownloaded,
      effectRaw: effectRaw ?? this.effectRaw,
      effectScrapedAt: effectScrapedAt ?? this.effectScrapedAt,
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
        'family': family, // 🆕 AGGIUNTO
        'releaseDate': releaseDate?.toIso8601String(),

        // Campi locali NON vanno nel JSON pubblico
        'imageLocalPath': imageLocalPath,
        'imageDownloaded': imageDownloaded,
        'effectRaw': effectRaw,
        'effectScrapedAt': effectScrapedAt?.toIso8601String(),
      };
}
