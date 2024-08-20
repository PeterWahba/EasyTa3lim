import 'dart:convert';

import 'package:academy_app/providers/shared_pref_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_udid/flutter_udid.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_device_identifier/mobile_device_identifier.dart';

import '../constants.dart';

class DifficultyLevel {
  String id;
  String name;

  DifficultyLevel(this.id, this.name);

  static List<DifficultyLevel> getDifficultyLevel() {
    return <DifficultyLevel>[
      DifficultyLevel('all', 'All Level'),
      DifficultyLevel('beginner', 'Beginner'),
      DifficultyLevel('intermediate', 'Intermediate'),
      DifficultyLevel('advanced', 'Advanced'),
    ];
  }
}

class PriceFilter {
  String id;
  String name;

  PriceFilter(this.id, this.name);

  static List<PriceFilter> getPriceFilter() {
    return <PriceFilter>[
      PriceFilter('all', 'All Price'),
      PriceFilter('free', 'Free'),
      PriceFilter('paid', 'Paid'),
    ];
  }
}

class Language {
  int? id;
  String? value;
  String? displayedValue;

  Language({@required this.id, @required this.value, @required this.displayedValue});
}

class Languages with ChangeNotifier {
  List<Language> _items = [];

  List<Language> get items {
    return [..._items];
  }

  Future<void> fetchLanguages() async {
    var url = '$BASE_URL/api/languages';
    try {
      final response = await http.get(Uri.parse(url));
      final extractedData = json.decode(response.body) as List;
      // if (extractedData.length != 0) {
      //   return;
      // }
      final List<Language> loadedLanguages = [];
      // print(extractedData);
      for (var langData in extractedData) {
        loadedLanguages.add(
          Language(
            id: langData['id'],
            value: langData['value'],
            displayedValue: langData['displayedValue'],
          ),
        );
      }
      _items = loadedLanguages;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }
}

Future<void> sendScreenShotLogs(String message) async {
  String? authToken = await SharedPreferenceHelper().getAuthToken();

  if (authToken == null || authToken.isEmpty) {
    authToken = 'notAuth';
  }
  final deviceId = base64.encode(utf8.encode((await MobileDeviceIdentifier().getDeviceId())!));
  String udid = await FlutterUdid.consistentUdid;

  var url = "$BASE_URL/api/log_screenshot?token=$authToken&message=$message&deviceid=$deviceId&udid=$udid";
  await http.get(Uri.parse(url));
}
