import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cep_fetcher/models/cep_model.dart';

/// Tries to fetch address data using the AwesomeAPI.
///
/// Returns a [Cep] object if successful, or `null` otherwise.
Future<Cep?> tryAwesomeApi(String cep, Duration timeout) async {
  final res = await http
      .get(Uri.https('cep.awesomeapi.com.br', '/json/$cep'))
      .timeout(timeout);
  if (res.statusCode != 200) return null;

  final data = jsonDecode(res.body);
  if (data['status'] == 404 || data.containsKey('erro')) return null;

  return Cep(
    cep: cep,
    address: data['address'],
    district: data['district'],
    city: data['city'],
    state: data['state'],
  );
}
