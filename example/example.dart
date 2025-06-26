// Example usage of the `cep_fetcher` package.
// This example shows how to fetch address data from a Brazilian CEP using the
// fetchCepData function.

// ignore_for_file: avoid_print

import 'package:cep_fetcher/cep_fetcher.dart';

void main() async {
  const inputCep = '01001000';

  try {
    final result = await fetchCepData(inputCep, timeout: Duration(seconds: 3));

    print('✔️ CEP encontrado:');
    print('   ${result!.address}, ${result.city} - ${result.state}');
  } catch (e) {
    print('❌ Erro ao buscar CEP: $e');
  }
}
