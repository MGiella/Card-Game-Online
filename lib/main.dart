import 'dart:async';
import 'package:battle_spirits_online/app/router/app_router.dart';
import 'package:battle_spirits_online/features/cards/data/card_importer.dart';
import 'package:battle_spirits_online/features/cards/data/effect_scaper_service.dart';
import 'package:battle_spirits_online/features/cards/data/local/database.dart';
import 'package:battle_spirits_online/features/cards/data/remote_card_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'features/cards/data/local/cards_dao.dart';
import 'features/cards/domain/card_model.dart';

import 'features/cards/data/image_downloader_service.dart';




// ---------------------------------------------------------
// 1) WIDGET PROGRESS BAR
// ---------------------------------------------------------
class ImportProgressScreen extends StatelessWidget {
  final ValueNotifier<double> progress;

  const ImportProgressScreen({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ValueListenableBuilder<double>(
          valueListenable: progress,
          builder: (context, value, _) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Importazione dati in corso...",
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: 300,
                  child: LinearProgressIndicator(value: value),
                ),
                const SizedBox(height: 10),
                Text("${(value * 100).toStringAsFixed(1)}%"),
              ],
            );
          },
        ),
      ),
    );
  }
}


// ---------------------------------------------------------
// 2) FUNZIONE PER IMPORTARE UN SINGOLO SET
// ---------------------------------------------------------
Future<void> importSingleSet(String setCode, CardsImporter importer) async {
  print("📥 Scarico JSON del set $setCode...");

  final url =
      "https://raw.githubusercontent.com/MGiella/Card-Game-Online/refs/heads/master/tools/scraper/cards_public/cards_public_$setCode.json";

  final loader = RemoteCardsLoader(url);
  final jsonData = await loader.load();

  if (jsonData.isEmpty) {
    print("⚠️ Set $setCode ignorato (URL non valido)");
    return;
  }

  print("📦 Importo ${jsonData.length} carte del set $setCode...");
  await importer.importFromJsonData(jsonData);
}


// ---------------------------------------------------------
// 3) PROCESSA UNA CARTA (immagine + effetto)
// ---------------------------------------------------------
Future<void> processCard(CardModel card, CardsDao dao) async {
  final imageDownloader = ImageDownloaderService(cardsDao: dao);
  final effectScraper = EffectScraperService(cardsDao: dao);

  // Scarica immagine
  await imageDownloader.downloadImageForCard(card);
  // Scrape effetto
  
  await effectScraper.scrapeEffectForCard(card);
}


// ---------------------------------------------------------
// 4) MAIN
// ---------------------------------------------------------
void main() async {
  WidgetsFlutterBinding.ensureInitialized();


  final databaseProvider = Provider<AppDatabase>((ref) => AppDatabase());
  final cardsDaoProvider = Provider<CardsDao>((ref) => ref.watch(databaseProvider).cardsDao);

  final db = ProviderContainer().read(databaseProvider);
  final dao = db.cardsDao;
  
  final progress = ValueNotifier<double>(0);

  // Mostra subito la progress bar
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: ImportProgressScreen(progress: progress),
  ));

  print("🔍 Controllo carte nel DB...");

  final before = await dao.countCards();
  print("Prima dell'import: $before");

  // 1) Carico lista set
  final setsLoader = RemoteCardsLoader(
    "https://raw.githubusercontent.com/MGiella/Card-Game-Online/refs/heads/master/tools/scraper/cards_public/sets.json",
  );
  final allSets = await setsLoader.load();

  final existingSets = await dao.getExistingSets();
  final missingSets = allSets.where((s) => !existingSets.contains(s)).toList();

  print("📌 Set disponibili: $allSets");
  print("📌 Set già nel DB: $existingSets");
  print("📌 Set da importare: $missingSets");

  final importer = CardsImporter(dao);
  final setsToImport = missingSets.take(3).toList();

  print("🚀 Import parallelo dei set: $setsToImport");

  // 2) Import parallelo dei set
  await Future.wait(
    setsToImport.map((set) => importSingleSet(set, importer)),
  );

  print("✔ Import set completato");

  // 3) Ora processiamo tutte le carte (immagini + effetti)
  final cards = await dao.getAllCards();
  final total = cards.length;
  int done = 0;

  for (final card in cards) {
    await processCard(card, dao);
    done++;
    progress.value = done / total;
  }

  print("✔ Download immagini + effetti completato");

  // 4) Avvia l'app completa
  runApp(const ProviderScope(child: BattleSpiritsApp()));
}



class BattleSpiritsApp extends StatelessWidget {
  const BattleSpiritsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Battle Spirits Online',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.deepPurple,
      ),
      routerConfig: appRouter,
    );
  }
}
