import 'dart:convert';
import 'package:battle_spirits_online/features/cards/domain/card_level.dart';
import 'package:drift/drift.dart';

import 'cards_table.dart';
import '../../domain/card_model.dart';
import 'database.dart';

part 'cards_dao.g.dart';

@DriftAccessor(tables: [Cards])
class CardsDao extends DatabaseAccessor<AppDatabase> with _$CardsDaoMixin {
  CardsDao(super.db);

  Future<List<CardModel>> getAllCards() async {
    final rows = await select(cards).get();
    return rows.map(_mapRowToModel).toList();
  }

  Future<CardModel?> getCardById(String id) async {
    final row = await (select(cards)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
    return row != null ? _mapRowToModel(row) : null;
  }

  Future<void> insertOrUpdate(CardModel card) async {
    await into(cards).insertOnConflictUpdate(_mapModelToCompanion(card));
  }

  // -------------------------
  // MAPPING
  // -------------------------

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
      levelsJson: Value(jsonEncode(card.levels.map((e) => e.toJson()).toList())),
      rarity: Value(card.rarity),
      setCode: Value(card.set),
      imageUrl: Value(card.imageUrl),
      effectTextRewrite: Value(card.effectTextRewrite),
      keywordsJson: Value(jsonEncode(card.keywords)),
      parallelVariantsJson: Value(jsonEncode(card.parallelVariants)),
      releaseDate: Value(card.releaseDate),
    );
  }
}
