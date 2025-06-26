/// A Dart package to fetch Brazilian address data from multiple CEP APIs.
library;

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:cep_fetcher/models/cep_model.dart';

/// Fetches address data for a given CEP.
///
/// The [cep] must contain 8 numeric digits.
/// Returns a [Cep] object if a valid response is found from any provider,
/// or `null` if all providers fail or the CEP is invalid.
///
/// It queries multiple APIs with automatic fallback between:
/// - ViaCEP
/// - AwesomeAPI
/// - OpenCEP
Future<Cep?> fetchCepData(String cep) async {
  final cleanCep = cep.replaceAll(RegExp(r'\D'), '');
  if (cleanCep.length != 8) return null;

  final List<Future<Cep?> Function()> providers = [
    () => _tryViaCep(cleanCep),
    () => _tryAwesomeApi(cleanCep),
    () => _tryOpenCepApi(cleanCep),
  ];

  for (final fetch in providers) {
    try {
      final data = await fetch();
      if (data != null) return data;
    } catch (e) {
      debugPrint('Erro ao tentar buscar CEP: $e');
    }
  }

  return null;
}

/// Tries to fetch address data using the ViaCEP API.
///
/// Returns a [Cep] object if successful, or `null` otherwise.
Future<Cep?> _tryViaCep(String cep) async {
  final res = await http.get(Uri.https('viacep.com.br', '/ws/$cep/json/'));
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
Future<Cep?> _tryAwesomeApi(String cep) async {
  final res = await http.get(Uri.https('cep.awesomeapi.com.br', '/json/$cep'));
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
Future<Cep?> _tryOpenCepApi(String cep) async {
  final res = await http.get(Uri.https('opencep.com', '/v1/$cep'));
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

