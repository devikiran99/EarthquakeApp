import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/earthquake_model.dart';
import '../models/query_params.dart';

class WeatherRepository{

  Future<EarthquakeModel> getEarthquakeData(QueryParams queryParams) async {
    final baseUrl = Uri.parse('https://earthquake.usgs.gov/fdsnws/event/1/query');
    final uri = Uri.https(baseUrl.authority, baseUrl.path, queryParams.toJson());
    final response = await http.get(uri);
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    return EarthquakeModel.fromJson(json);
  }

}