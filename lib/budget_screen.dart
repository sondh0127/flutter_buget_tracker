import 'package:flutter/material.dart';
import 'package:flutter_buget_tracker/budget_repository.dart';
import 'package:flutter_buget_tracker/failure_model.dart';
import 'package:flutter_buget_tracker/item_model.dart';

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({Key? key}) : super(key: key);

  @override
  _BudgetScreenState createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  late Future<List<Item>> _futureItems;

  @override
  void initState() {
    super.initState();
    _futureItems = BudgetRepository().getItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Budget Tracker'),
      ),
      body: FutureBuilder(
        future: _futureItems,
        // initialData: InitialData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Center(
              child: Text('hasData'),
            );
          } else if (snapshot.hasError) {
            final failure = snapshot.error as Failure;
            return Center(
              child: Text(failure.message),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
