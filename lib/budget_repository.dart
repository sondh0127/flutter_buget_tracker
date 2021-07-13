import 'dart:convert';
import 'dart:io';

import 'package:flutter_buget_tracker/failure_model.dart';
import 'package:flutter_buget_tracker/item_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class BudgetRepository {
  final http.Client _client;
  static const String baseUrl = 'https://api.notion.com/v1';

  BudgetRepository({http.Client? client}) : _client = client ?? http.Client();

  void dispose() {
    _client.close();
  }

  Future<List<Item>> getItems() async {
    try {
      final url =
          '${baseUrl}/databases/${dotenv.env['NOTION_DATABASE_ID']}/query';

      final response = await _client.post(Uri.parse(url), headers: {
        HttpHeaders.authorizationHeader:
            'Bearer ${dotenv.env['NOTION_API_KEY']}',
        'Notion-Version': '2021-05-13'
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        print(data);
        return (data['results'] as List<dynamic>)
            .where((e) => !Item.isEmpty(e as Map<String, dynamic>))
            .map((e) => Item.fromMap(e as Map<String, dynamic>))
            .toList()
              ..sort((a, b) => b.date.compareTo(a.date));
      } else {
        throw const Failure(message: 'Something went wrong!');
      }
    } catch (e) {
      print(e.toString());
      throw const Failure(message: 'Something went wrong!');
    }
  }
}
