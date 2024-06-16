import 'dart:convert';
import 'package:http/http.dart' as http;

class UnsplashService {
  final String accessKey = '1zUCmf9cMTzEzZwMzuzp4iC1mfavknbD66d2XPRX0CQ';

  Future<List<String>> fetchImages(String query) async {
    final response = await http.get(
      Uri.parse('https://api.unsplash.com/search/photos?query=$query&client_id=$accessKey'),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      List<dynamic> results = data['results'];
      return results.map<String>((result) => result['urls']['small'] as String).toList();
    } else {
      throw Exception('Failed to load images');
    }
  }
}
