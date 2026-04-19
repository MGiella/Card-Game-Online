import 'package:battle_spirits_online/app/router/app_router.dart';
import 'package:battle_spirits_online/features/cards/data/local/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void  main() async {
  runApp(const ProviderScope(child: BattleSpiritsApp()));

  final db = AppDatabase();
  final dao = db.cardsDao;

  final cards = await dao.getAllCards();
  print('Carte nel database: ${cards.length}');


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
