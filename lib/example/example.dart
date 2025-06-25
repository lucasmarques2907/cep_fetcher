// Example usage of the `cep_fetcher` package.
// This example shows how to fetch address data from a Brazilian CEP using the
// CepFetcher class.

import 'package:cep_fetcher/cep_fetcher.dart';
import 'package:flutter/foundation.dart';

void main() async {
  final fetcher = CepFetcher();
  final result = await fetcher.fetchCepData('01001000');

  if (result == null) {
    debugPrint('CEP não encontrado');
  } else {
    debugPrint(
      'Logradouro: ${result.address}, ${result.city} - ${result.state}',
    );
  }
}
