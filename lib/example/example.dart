import 'package:cep_fetcher/cep_fetcher.dart';

void main() async {
  final fetcher = CepFetcher();
  final result = await fetcher.fetchCepData('99999999');

  if (result == null) {
    print('CEP não encontrado');
  } else {
    print('Logradouro: ${result.address}, ${result.city} - ${result.state}');
  }
}
