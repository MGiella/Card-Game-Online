import 'package:drift/drift.dart';

class Cards extends Table {
  TextColumn get id => text()();
  TextColumn get cardNumber => text()();
  TextColumn get nameEn => text()();
  TextColumn get type => text()();
  TextColumn get color => text()();
  IntColumn get cost => integer()();
  TextColumn get family => text().nullable()();

  // JSON con i livelli (List<CardLevel>)
  TextColumn get levelsJson => text()();

  TextColumn get rarity => text()();
  TextColumn get setCode => text()();

  // URL remoto dell'immagine
  TextColumn get imageUrl => text().nullable()();

  // Effetto riscritto (dal JSON pubblico)
  TextColumn get effectTextRewrite => text().nullable()();

  TextColumn get keywordsJson => text().nullable()();
  TextColumn get parallelVariantsJson => text().nullable()();

  DateTimeColumn get releaseDate => dateTime().nullable()();

  // ---------------------------------------------------------
  // Campi locali (solo lato client)
  // ---------------------------------------------------------

  // Percorso locale dell'immagine scaricata
  TextColumn get imageLocalPath => text().nullable()();

  // Flag se l'immagine è stata scaricata
  BoolColumn get imageDownloaded =>
      boolean().withDefault(const Constant(false))();

  // Effetto completo scaricato da Fandom
  TextColumn get effectRaw => text().nullable()();

  // Timestamp dello scraping dell'effetto
  DateTimeColumn get effectScrapedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
