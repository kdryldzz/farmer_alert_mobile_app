import 'dart:convert';
import 'package:flutter/services.dart';

class CityDistrictService {
  // City and district data
  Future<Map<String, List<String>>> loadCityDistricts() async {
    final String jsonString = await rootBundle.loadString('datas/city_district.json');
    final Map<String, dynamic> jsonResponse = json.decode(jsonString);
    // Return the parsed data
    return jsonResponse.map((key, value) => MapEntry(key, List<String>.from(value)));
  }
}