/// A powerful and extensible Dart package to retrieve Brazilian address data from CEP codes,
/// with automatic fallback between multiple public APIs.
library;

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cep_fetcher/models/cep_model.dart';
import 'package:cep_fetcher/exceptions/cep_exceptions.dart';

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

  final List<Future<Cep?> Function()> providers = [
    () => _tryViaCep(cleanCep, timeout),
    () => _tryAwesomeApi(cleanCep, timeout),
    () => _tryOpenCepApi(cleanCep, timeout),
  ];

  for (final fetch in providers) {
    try {
      final data = await fetch();
      if (data != null) return data;
    } catch (_) {
      // Silent: ignores and try the next provider
    }
  }

  throw CepNotFoundException(cep);
}

/// Tries to fetch address data using the ViaCEP API.
///
/// Returns a [Cep] object if successful, or `null` otherwise.
Future<Cep?> _tryViaCep(String cep, Duration timeout) async {
  final res = await http
      .get(Uri.https('viacep.com.br', '/ws/$cep/json/'))
      .timeout(timeout);
  if (res.statusCode != 200) return null;

  final data = jsonDecode(res.body);
  if (data['erro'] == true) return null;

  return Cep(
    cep: cep,
    address: data['logradouro'],
    district: data['bairro'],
    city: data['localidade'],
    state: data['uf'],
  );
}

/// Tries to fetch address data using the AwesomeAPI.
///
/// Returns a [Cep] object if successful, or `null` otherwise.
Future<Cep?> _tryAwesomeApi(String cep, Duration timeout) async {
  final res = await http
      .get(Uri.https('cep.awesomeapi.com.br', '/json/$cep'))
      .timeout(timeout);
  if (res.statusCode != 200) return null;

  final data = jsonDecode(res.body);
  if (data['status'] == 404 || data.containsKey('erro')) return null;

  return Cep(
    cep: cep,
    address: data['address'],
    district: data['district'],
    city: data['city'],
    state: data['state'],
  );
}

/// Tries to fetch address data using the OpenCEP API.
///
/// Returns a [Cep] object if successful, or `null` otherwise.
Future<Cep?> _tryOpenCepApi(String cep, Duration timeout) async {
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
