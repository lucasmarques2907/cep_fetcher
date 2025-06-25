import 'package:flutter_test/flutter_test.dart';

import 'package:cep_fetcher/cep_fetcher.dart';

void main() {
  test('Checks if the CEP is valid and has data', () async {
    final cepFetcher = CepFetcher();

    final result = await cepFetcher.fetchCepData('01001000');

    expect(result, isNotNull);

    expect(result!.cep, '01001000');
    expect(result.address, isNotEmpty);
    expect(result.state, isNotEmpty);
  });
}
