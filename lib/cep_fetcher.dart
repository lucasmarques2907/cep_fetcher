/// A powerful and extensible Dart package to retrieve Brazilian address data from CEP codes,
/// with automatic fallback between multiple public APIs.
library;

import 'package:cep_fetcher/models/cep_model.dart';
import 'package:cep_fetcher/exceptions/cep_exceptions.dart';
import 'package:flutter/foundation.dart';

import 'src/providers/via_cep_provider.dart';
import 'src/providers/awesome_api_provider.dart';
import 'src/providers/open_cep_api_provider.dart';

/// Internal in-memory cache to store successfully resolved CEPs.
/// Avoids redundant API calls during the same runtime session.
final Map<String, Cep> _cepCache = {};

/// Fetches address data for a given CEP.
///
/// The [cep] must contain 8 numeric digits.
///
/// [timeout] defines the maximum duration for each request. Allowed range:
/// between `Duration(seconds: 1)` and `Duration(seconds: 10)`.
///
/// Throws a [TimeoutOutOfRangeException] if the timeout is not between 1 and 10 seconds.
///
/// Throws an [InvalidCepFormatException] if the CEP is not exactly 8 digits after normalization.
///
/// Throws a [CepNotFoundException] if no address data is found from any provider.
///
/// Returns a [Cep] object if a valid response is found from any provider,
/// or `null` if all providers fail or the CEP is invalid.
///
/// Internally caches successful lookups to avoid redundant network requests
/// for the same CEP during the application's runtime.
///
/// It queries multiple APIs with automatic fallback between:
/// - ViaCEP
/// - AwesomeAPI
/// - OpenCEP
Future<Cep?> fetchCepData(
  String cep, {
  Duration timeout = const Duration(seconds: 3),
}) async {
  if (timeout < Duration(seconds: 1) || timeout > Duration(seconds: 10)) {
    throw TimeoutOutOfRangeException(timeout);
  }

  final cleanCep = cep.replaceAll(RegExp(r'\D'), '');
  if (cleanCep.length != 8) {
    throw InvalidCepFormatException(cep);
  }

  if (cleanCep == '99999999') {
    throw CepNotFoundException(cleanCep);
  }

  if (_cepCache.containsKey(cleanCep)) {
    return _cepCache[cleanCep]!;
  }

  final List<Future<Cep?> Function()> providers = [
    () => tryViaCep(cleanCep, timeout),
    () => tryAwesomeApi(cleanCep, timeout),
    () => tryOpenCepApi(cleanCep, timeout),
  ];

  for (final fetch in providers) {
    try {
      final data = await fetch();
      if (data != null) {
        _cepCache[cleanCep] = data;
        return data;
      }
    } catch (_) {
      // Silent: ignores and try the next provider
    }
  }

  throw CepNotFoundException(cep);
}

/// Internal cache accessor for testing purposes only.
///
/// Exposes the in-memory CEP cache so it can be inspected in unit tests.
/// Do not use in production code.
@visibleForTesting
Map<String, Cep> get internalCache => _cepCache;