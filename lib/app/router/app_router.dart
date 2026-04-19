import 'package:go_router/go_router.dart';

import '../../features/home/presentation/home_page.dart';


//crea un'istanza di GoRouter globale che definisce le rotte dell'applicazione

final appRouter = GoRouter(
  routes: [
    GoRoute(path: '/',name: 'home',builder: (context, state) => const HomePage()),
  ],
);
