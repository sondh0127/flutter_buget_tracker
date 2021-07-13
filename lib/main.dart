import 'package:flutter/material.dart';
import 'package:flutter_buget_tracker/budget_screen.dart';
import 'package:flutter_buget_tracker/pages/home.dart';
import 'package:flutter_buget_tracker/pages/pokedex.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: '.env');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      routes: {
        '/': (context) => BudgetScreen(),
        '/home': (context) => const MyHomePage(),
        '/pokedex': (context) => const PokeDexPage(),
        // '/detail': ( context) => PokemonDetailPage()
      },
    );
  }
}
