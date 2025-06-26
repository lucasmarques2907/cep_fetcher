import 'package:cep_fetcher/src/network.dart';
import 'package:cep_fetcher/models/cep_model.dart';

/// Tries to fetch address data using the OpenCEP API.
///
/// Returns a [Cep] object if successful, or `null` otherwise.
Future<Cep?> tryOpenCepApi(String cep, Duration timeout) async {
  final uri = Uri.https('opencep.com', '/v1/$cep');
  final data = await getJson(uri, timeout);
  if (data == null || data['status'] == 404 || data.containsKey('erro')) {
    return null;
  }

  return Cep(
    cep: cep,
    address: data['logradouro'],
    district: data['bairro'],
    city: data['localidade'],
    state: data['uf'],
  );
}
