import 'package:chat_verse/src/core/providers/i_http_provider.dart';
import 'package:http/http.dart' as http;

class HttpProvider implements IHttpProvider {
  @override
  Future get(String url, Map<String, String>? headers) async {
    try {
      final currentUri = Uri.parse(url);
      return await http.get(currentUri, headers: headers);
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future post(String url, body, Map<String, String>? headers) async {
    try {
      final currentUri = Uri.parse(url);
      return await http.post(currentUri, headers: headers);
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future put(String url, body, Map<String, String>? headers) async {
    try {
      final currentUri = Uri.parse(url);
      return await http.put(currentUri, headers: headers);
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future delete(String url, Map<String, String>? headers) async {
    try {
      final currentUri = Uri.parse(url);
      return await http.delete(currentUri, headers: headers);
    } catch (error) {
      rethrow;
    }
  }
}
