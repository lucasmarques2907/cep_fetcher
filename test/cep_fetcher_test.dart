// Unit tests for the `cep_fetcher` package.
// Verifies that the fetchCepData function behaves as expected,
// including success and error cases.

import 'package:flutter_test/flutter_test.dart';
import 'package:cep_fetcher/cep_fetcher.dart';
import 'package:cep_fetcher/exceptions/cep_exceptions.dart';

void main() {
  setUp(() {
    internalCache.clear();
  });

  group('fetchCepData', () {
    test('Returns valid data for a known good CEP', () async {
      final result = await fetchCepData('01001000');

      expect(result, isNotNull);
      expect(result.cep, '01001000');
      expect(result.address, isNotEmpty);
      expect(result.state, isNotEmpty);
    });

    test('Throws InvalidCepFormatException for badly formatted CEP', () async {
      expect(
        () => fetchCepData('01-ABC'),
        throwsA(isA<InvalidCepFormatException>()),
      );
    });

    test(
      'Throws TimeoutOutOfRangeException for timeout below 1 second',
      () async {
        expect(
          () => fetchCepData('01001000', timeout: Duration(milliseconds: 500)),
          throwsA(isA<TimeoutOutOfRangeException>()),
        );
      },
    );

    test(
      'Throws TimeoutOutOfRangeException for timeout above 10 seconds',
      () async {
        expect(
          () => fetchCepData('01001000', timeout: Duration(seconds: 11)),
          throwsA(isA<TimeoutOutOfRangeException>()),
        );
      },
    );

    test('Throws CepNotFoundException for non-existent CEP', () async {
      expect(
        () => fetchCepData('99999999'),
        throwsA(isA<CepNotFoundException>()),
      );
    });

    test('Reuses cached result on repeated request', () async {
      expect(internalCache.containsKey('01001000'), isFalse);

      final result1 = await fetchCepData('01001000');
      expect(result1, isNotNull);

      expect(internalCache.containsKey('01001000'), isTrue);

      final result2 = await fetchCepData('01001000');
      expect(
        identical(result1, result2),
        isTrue,
      ); // Should be same object instance
    });
  });
}
