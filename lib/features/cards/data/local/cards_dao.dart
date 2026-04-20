import 'dart:convert';
import 'package:battle_spirits_online/features/cards/domain/card_level.dart';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'cards_table.dart';
import '../../domain/card_model.dart';
import 'database.dart';

part 'cards_dao.g.dart';

@DriftAccessor(tables: [Cards])
class CardsDao extends DatabaseAccessor<AppDatabase> with _$CardsDaoMixin {
  CardsDao(super.db);

  // ---------------------------------------------------------
  // GETTERS
  // ---------------------------------------------------------

  Future<List<CardModel>> getAllCards() async {
    final rows = await select(cards).get();
    return rows.map(_mapRowToModel).toList();
  }

  Future<CardModel?> getCardById(String id) async {
    final row = await (select(cards)..where((tbl) => tbl.id.equals(id)))
        .getSingleOrNull();
    return row != null ? _mapRowToModel(row) : null;
  }

  // ---------------------------------------------------------
  // INSERT / UPDATE
  // ---------------------------------------------------------

  Future<void> insertOrUpdate(CardModel card) async {
    await into(cards).insertOnConflictUpdate(_mapModelToCompanion(card));
  }

  // ---------------------------------------------------------
  // UPDATE CAMPI LOCALI
  // ---------------------------------------------------------

  Future<void> updateImageInfo(
    String id, {
    required String localPath,
    required bool downloaded,
  }) async {
    await (update(cards)..where((tbl) => tbl.id.equals(id))).write(
      CardsCompanion(
        imageLocalPath: Value(localPath),
        imageDownloaded: Value(downloaded),
      ),
    );
  }

  Future<void> updateEffect(
    String id, {
    required String effectRaw,
    required DateTime scrapedAt,
  }) async {
    await (update(cards)..where((tbl) => tbl.id.equals(id))).write(
      CardsCompanion(
        effectRaw: Value(effectRaw),
        effectScrapedAt: Value(scrapedAt),
      ),
    );
  }

  // ---------------------------------------------------------
  // COUNT
  // ---------------------------------------------------------

  Future<int> countCards() async {
    final countExp = cards.id.count();
    final query = selectOnly(cards)..addColumns([countExp]);
    final result = await query.getSingle();
    return result.read(countExp) ?? 0;
  }

  // ---------------------------------------------------------
  // SETS PRESENTI NEL DB
  // ---------------------------------------------------------

  Future<List<String>> getExistingSets() async {
    final query = selectOnly(cards, distinct: true)
      ..addColumns([cards.setCode]);

    final rows = await query.get();

    return rows
        .map((row) => row.read(cards.setCode))
        .whereType<String>()
        .where((s) => s.isNotEmpty)
        .toList();
  }

  // ---------------------------------------------------------
  // MAPPING
  // ---------------------------------------------------------

  CardModel _mapRowToModel(Card row) {
    final levels = (jsonDecode(row.levelsJson) as List)
        .map((e) => CardLevel.fromJson(e))
        .toList();

    return CardModel(
      id: row.id,
      cardNumber: row.cardNumber,
      nameEn: row.nameEn,
      type: row.type,
      color: row.color,
      cost: row.cost,
      levels: levels,
      rarity: row.rarity,
      set: row.setCode,
      imageUrl: row.imageUrl ?? '',
      effectTextRewrite: row.effectTextRewrite ?? '',
      keywords: row.keywordsJson != null
          ? List<String>.from(jsonDecode(row.keywordsJson!))
          : [],
      parallelVariants: row.parallelVariantsJson != null
          ? List<String>.from(jsonDecode(row.parallelVariantsJson!))
          : [],
      releaseDate: row.releaseDate,

      // 🆕 AGGIUNTO
      family: row.family,

      // Campi locali
      imageLocalPath: row.imageLocalPath,
      imageDownloaded: row.imageDownloaded,
      effectRaw: row.effectRaw,
      effectScrapedAt: row.effectScrapedAt,
    );
  }

  CardsCompanion _mapModelToCompanion(CardModel card) {
    return CardsCompanion(
      id: Value(card.id),
      cardNumber: Value(card.cardNumber),
      nameEn: Value(card.nameEn),
      type: Value(card.type),
      color: Value(card.color),
      cost: Value(card.cost),
      levelsJson:
          Value(jsonEncode(card.levels.map((e) => e.toJson()).toList())),
      rarity: Value(card.rarity),
      setCode: Value(card.set),
      imageUrl: Value(card.imageUrl),
      effectTextRewrite: Value(card.effectTextRewrite),

      // 🆕 AGGIUNTO
      family: Value(card.family),

      keywordsJson: Value(jsonEncode(card.keywords)),
      parallelVariantsJson: Value(jsonEncode(card.parallelVariants)),
      releaseDate: Value(card.releaseDate),

      // Campi locali
      imageLocalPath: Value(card.imageLocalPath),
      imageDownloaded: Value(card.imageDownloaded),
      effectRaw: Value(card.effectRaw),
      effectScrapedAt: Value(card.effectScrapedAt),
    );
  }

  // ---------------------------------------------------------
  // RICERCA
  // ---------------------------------------------------------

  Future<List<CardModel>> searchCards(String query) async {
    if (query.isEmpty) {
      final rows = await getAllCards();
      return rows;
    }

    final results = await (select(cards)
          ..where((tbl) =>
              tbl.nameEn.like('%$query%') |
              tbl.cardNumber.like('%$query%')))
        .get();

    return results.map(_mapRowToModel).toList();
  }
}

// ---------------------------------------------------------
// PROVIDERS
// ---------------------------------------------------------

final cardsDaoProvider = Provider<CardsDao>((ref) {
  final db = ref.read(appDatabaseProvider);
  return CardsDao(db);
});

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase();
});
