import 'package:drift/drift.dart';

class Cards extends Table {
  TextColumn get id => text()();
  TextColumn get cardNumber => text()();
  TextColumn get nameEn => text()();
  TextColumn get type => text()();
  TextColumn get color => text()();
  IntColumn get cost => integer()();

  // JSON con i livelli (List<CardLevel>)
  TextColumn get levelsJson => text()();

  TextColumn get rarity => text()();
  TextColumn get setCode => text()();

  TextColumn get imageUrl => text().nullable()();

  TextColumn get effectTextRewrite => text().nullable()();

  TextColumn get keywordsJson => text().nullable()();

  TextColumn get parallelVariantsJson => text().nullable()();

  DateTimeColumn get releaseDate => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
