import 'package:flutter/material.dart';
import 'package:http/http.dart';

class BaseRepository extends ChangeNotifier {
  bool _isBusy = false;
  bool get isBusy => _isBusy;

  set isBusy(bool newBusy) {
    _isBusy = newBusy;
  }

  BaseRepository();

  Future<Response> getAsync(String url) async {
    print('Get Api Address :- $url');

    var response = await get(Uri.parse(url));

    return response;
  }

  void apiCall({
    bool isReady = false,
    bool isException = false,
    bool isNotify = false,
    bool isApiError = false,
  }) {
    _isBusy = isReady;
    if (isNotify) {
      notifyListeners();
      print('NotifyListeners');
    }
    print(isReady
        ? 'Api call start'
        : isException
            ? 'Exception occured'
            : isApiError
                ? 'Api error occured'
                : 'Api call success');
  }
}
