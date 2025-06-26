// Basic unit test for the `cep_fetcher` package.
//
// This test verifies that the fetcher correctly returns address data
// for a known, valid CEP using real HTTP requests.

import 'package:flutter_test/flutter_test.dart';
import 'package:cep_fetcher/cep_fetcher.dart';

void main() {
  test('Checks if the CEP is valid and returns address data', () async {

    final result = await fetchCepData('01001000');

    expect(result, isNotNull);
    expect(result!.cep, '01001000');
    expect(result.address, isNotEmpty);
    expect(result.state, isNotEmpty);
  });
}
