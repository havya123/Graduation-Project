import 'package:http/http.dart' as http;

class PlaceRepo {
  Future<String?> fetchUrl(String url, {Map<String, dynamic>? headers}) async {
    try {
      final uri = Uri.parse(url);
      final response = await http.get(
        uri,
      );
      if (response.statusCode == 200) {
        return response.body;
      }
    } catch (e) {
      print(e);
    }
    return null;
  }
}
