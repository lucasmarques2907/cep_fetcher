class Cep {
  final String cep;
  final String address;
  final String district;
  final String city;
  final String state;

  const Cep({
    required this.cep,
    required this.address,
    required this.district,
    required this.city,
    required this.state,
  });

  Map<String, dynamic> toJson() => {
    'cep': cep,
    'address': address,
    'district': district,
    'city': city,
    'state': state,
  };
}
