import 'package:flutter/material.dart';
import 'package:flutter_buget_tracker/budget_repository.dart';
import 'package:flutter_buget_tracker/failure_model.dart';
import 'package:flutter_buget_tracker/item_model.dart';
import 'package:flutter_buget_tracker/spending_chart.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

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
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Drawer Header'),
            ),
            ListTile(
              title: const Text('Pokedex'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/pokedex');
              },
            ),
            ListTile(
              title: const Text('Home'),
              onTap: () {
                // ...
              },
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _futureItems = BudgetRepository().getItems();
          setState(() {});
        },
        child: FutureBuilder<List<Item>>(
          future: _futureItems,
          // initialData: InitialData,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final items = snapshot.data!;
              return Provider<List<Item>>.value(
                value: items,
                child: const SpendingList(),
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
      ),
    );
  }
}

class SpendingList extends StatelessWidget {
  const SpendingList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _items = context.watch<List<Item>>();
    return ListView.builder(
      itemCount: _items.length + 1,
      itemBuilder: (BuildContext context, int index) {
        if (index == 0) {
          return SpendingChart();
        }

        final item = _items[index - 1];
        return Container(
          margin: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(
              width: 2.0,
              color: getCategoryColor(item.category),
            ),
            boxShadow: const [
              BoxShadow(
                color: Colors.grey,
                offset: Offset(0, 2),
                blurRadius: 6.0,
              ),
            ],
          ),
          child: ListTile(
            title: Text(
              item.name,
              style: TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
            subtitle: Text(
                '${item.category} * ${DateFormat.yMd().format(item.date)}'),
            trailing: Text(
              '-${item.price.toStringAsFixed(2)} \$',
              style: TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        );
      },
    );
  }
}

Color getCategoryColor(String category) {
  switch (category) {
    case 'Entertainment':
      return Colors.red[400]!;
    case 'Food':
      return Colors.green[400]!;
    case 'Transportation':
      return Colors.blue[400]!;
    case 'Personal':
      return Colors.purple[400]!;
    default:
      return Colors.orange[400]!;
  }
}
