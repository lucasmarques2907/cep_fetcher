import 'dart:convert';
import 'package:http/http.dart' as http;

/// Current version of the cep_fetcher library.
const String libraryVersion = '1.0.0';

/// Default headers used in all HTTP requests performed by this package.
///
/// Includes:
/// - `Accept: application/json` to ensure only JSON responses are accepted.
/// - `User-Agent` to identify the library in external API logs.
const Map<String, String> defaultHeaders = {
  'Accept': 'application/json',
  'User-Agent': 'cep_fetcher/$libraryVersion',
};

/// Executes an HTTP GET request to the given [uri] and returns the JSON-decoded response.
///
/// - Automatically applies [defaultHeaders] and merges any [headers] provided.
/// - Enforces a [timeout] for the request.
/// - Returns `null` if the response status code is not 200, if the content-type is not JSON,
///   or if the response body is not valid JSON.
///
/// This function is used internally by all CEP data providers
/// to standardize network access and avoid code duplication.
///
/// Example usage:
/// ```dart
/// final uri = Uri.https('viacep.com.br', '/ws/01001000/json/');
/// final data = await getJson(uri, Duration(seconds: 3));
/// if (data != null) print(data['logradouro']);
/// ```
Future<Map<String, dynamic>?> getJson(
  Uri uri,
  Duration timeout, {
  Map<String, String>? headers,
}) async {
  final response = await http
      .get(uri, headers: {...defaultHeaders, if (headers != null) ...headers})
      .timeout(timeout);

  if (response.statusCode != 200) return null;
  if (!response.headers['content-type']!.contains('application/json')) {
    return null;
  }

  try {
    return jsonDecode(response.body) as Map<String, dynamic>;
  } catch (_) {
    return null;
  }
}
