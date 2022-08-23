import 'dart:convert';
import 'dart:developer';
import 'package:daily_news/api/constants.dart';
import 'package:daily_news/api/model.dart';
import 'package:http/http.dart' as http;

class ApiService {
  var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.usersEndpoint);

  Future<List<Results>?> getNews() async {
    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        final List result = jsonDecode(response.body)['results'];
        return result.map(((e) => Results.fromJson(e))).toList();
      }
    } catch (e) {
      log(e.toString());
    }
    return null;
  }
}
