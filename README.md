# cep_fetcher

## Funcionalidades

- Obtém dados de endereço (logradouro, bairro, cidade, estado) a partir de um CEP, utilizando múltiplas APIs:
  - [ViaCEP](https://viacep.com.br)
  - [AwesomeAPI](https://cep.awesomeapi.com.br)
  - [OpenCEP](https://opencep.com)
- Tenta usar a próxima API automaticamente caso uma falhe
- Tratamento de erros silencioso com registro via `debugPrint` (somente em modo debug)

## Primeiros Passos

### Adicionar dependência

No seu `pubspec.yaml`:

```yaml
dependencies:
    cep_fetcher: ^1.0.0
```

Depois execute:
```flutter pub get```

## Como Usar

Importe e chame o método `fetchCepData`:

```dart
import 'package:cep_fetcher/cep_fetcher.dart';
import 'package:cep_fetcher/models/cep_model.dart';

final fetcher = CepFetcher();

void getAddress() async {
    final Cep? data = await fetcher.fetchCepData('01001000');

    if (data != null){
        print('${info.address}, ${info.district} - ${info.city}/${info.state}');
    }else{
        print('CEP inválido ou não encontrado');
    }
}
```

## Modelo de CEP

```dart
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
```

## Provedores de API

Ordem de fallback (tentativas):

1. **ViaCep** (`viacep.com.br`)
2. **AwesomeAPI** (`cep.awesomeapi.com.br`)
3. **OpenCEP** (`opencep.com`)

## Tratamento de Erros

- Retorna `null` se:
  - O CEP fornecido for inválido (não conter 8 dígitos numéricos)
  - Todas as tentativas de API falharem
- Erros de rede e requisições são capturados e exibidos via `debugPrint` (apenas em modo de debug)

## Exemplo Completo

```dart
void main() async {
    final fetcher = CepFetcher();
    final result = await fetcher.fetchCepData('99999999');

    if(result == null){
        print('CEP não encontrado');
    }else{
        print('Logradouro: ${result.address}, ${result.city} - ${result.state}');
    }
}
```

## Licença

Este projeto está licenciado sob a [Licença MIT](https://github.com/lucasmarques2907/cep_fetcher/blob/main/LICENSE).

## Contato

Created by **Lucas Vinícius Marques**, connect via [LinkedIn](https://www.linkedin.com/in/lucas-vinicius-marques-0a340131b/)