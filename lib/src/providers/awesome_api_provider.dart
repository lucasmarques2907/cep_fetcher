import 'package:cep_fetcher/src/network.dart';
import 'package:cep_fetcher/models/cep_model.dart';

/// Tries to fetch address data using the AwesomeAPI.
///
/// Returns a [Cep] object if successful, or `null` otherwise.
Future<Cep?> tryAwesomeApi(String cep, Duration timeout) async {
  final uri = Uri.https('cep.awesomeapi.com.br', '/json/$cep');
  final data = await getJson(uri, timeout);

  if (data == null || data['status'] == 404 || data.containsKey('erro')) {
    return null;
  }

  return Cep(
    cep: cep,
    address: data['address'],
    district: data['district'],
    city: data['city'],
    state: data['state'],
  );
}
