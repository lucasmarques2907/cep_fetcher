/// Represents a Brazilian address retrieved by a postal code (CEP).
class Cep {
  /// The CEP (Código de Endereçamento Postal), must be exactly 8 digits.
  final String cep;

  /// The street address (logradouro).
  final String address;

  /// The neighborhood or district (bairro).
  final String district;

  /// The city name (localidade).
  final String city;

  /// The state abbreviation (UF), e.g., 'SP' or 'RJ'.
  final String state;

  /// Creates an immutable [Cep] instance.
  ///
  /// All fields are required and must be non-null.
  const Cep({
    required this.cep,
    required this.address,
    required this.district,
    required this.city,
    required this.state,
  });

  /// Converts the [Cep] instance to a JSON map.
  Map<String, dynamic> toJson() => {
    'cep': cep,
    'address': address,
    'district': district,
    'city': city,
    'state': state,
  };
}
