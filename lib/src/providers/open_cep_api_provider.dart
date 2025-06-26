import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cep_fetcher/models/cep_model.dart';

/// Tries to fetch address data using the OpenCEP API.
///
/// Returns a [Cep] object if successful, or `null` otherwise.
Future<Cep?> tryOpenCepApi(String cep, Duration timeout) async {
  final res = await http
      .get(Uri.https('opencep.com', '/v1/$cep'))
      .timeout(timeout);
  if (res.statusCode != 200) return null;

  final data = jsonDecode(res.body);
  if (data['status'] == 404 || data.containsKey('erro')) return null;

  return Cep(
    cep: cep,
    address: data['logradouro'],
    district: data['bairro'],
    city: data['localidade'],
    state: data['uf'],
  );
}