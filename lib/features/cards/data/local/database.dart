import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'cards_table.dart';
import 'cards_dao.dart';

part 'database.g.dart';

@DriftDatabase(
  tables: [Cards],
  daos: [CardsDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationSupportDirectory(); 
    final dbFolder = Directory(p.join(dir.path, 'BattleSpirits'));

    if (!await dbFolder.exists()) {
      await dbFolder.create(recursive: true);
    }

    final dbPath = p.join(dbFolder.path, 'battle_spirits.db');
    print("📁 DB path: $dbPath");

    return NativeDatabase(File(dbPath));
  });
}

