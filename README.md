# cep_fetcher

## Funcionalidades

- Obtém dados de endereço (logradouro, bairro, cidade, estado) a partir de um CEP, utilizando múltiplas APIs:
  - [ViaCEP](https://viacep.com.br)
  - [AwesomeAPI](https://cep.awesomeapi.com.br)
  - [OpenCEP](https://opencep.com)
- Tenta usar a próxima API automaticamente caso uma falhe.
- Cache interno em memória para evitar requisições repetidas para o mesmo CEP durante a execução.
- Tratamento de erros via exceções específicas, com mensagens claras para facilitar o diagnóstico.

## Como Usar

Importe o pacote e chame a função `fetchCepData`:

```dart
import 'package:cep_fetcher/cep_fetcher.dart';

void getAddress() async {
    const inputCep = '01001000';

  try {
    final result = await fetchCepData(inputCep, timeout: Duration(seconds: 3));
    print('✔️ CEP encontrado:');
    print('   ${result!.address}, ${result.city} - ${result.state}');
  } catch (e) {
    print('❌ Erro ao buscar CEP: $e');
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

A função `fetchCepData` pode lançar exceções específicas para facilitar o tratamento de erros:

- `InvalidCepFormatException` – O CEP fornecido não contém 8 dígitos válidos após remoção de formatação.
- `TimeoutOutOfRangeException` – O valor fornecido para `timeout` está fora do intervalo permitido (1 a 10 segundos).
- `CepNotFoundException` – Nenhuma das APIs públicas conseguiu retornar dados para o CEP informado.

Todas essas exceções herdam de `CepFetcherException`, permitindo capturas genéricas ou específicas conforme desejado.

## Exemplo Completo

```dart
import 'package:cep_fetcher/cep_fetcher.dart';

void main() async {
  const inputCep = '01001000';

  try {
    final result = await fetchCepData(inputCep, timeout: Duration(seconds: 3));

    print('✔️ CEP encontrado:');
    print('   ${result!.address}, ${result.city} - ${result.state}');
  } catch (e) {
    print('❌ Erro ao buscar CEP: $e');
  }
}
```

## Histórico de versões

Consulte o [CHANGELOG](https://pub.dev/packages/cep_fetcher/changelog) para detalhes sobre as versões anteriores.

## Aviso Legal

Este pacote utiliza APIs públicas de terceiros ([ViaCEP](https://viacep.com.br), [AwesomeAPI](https://cep.awesomeapi.com.br) e [OpenCEP](https://opencep.com)) para obtenção de dados de endereço a partir de um CEP. O desenvolvedor desta biblioteca não tem afiliação com os serviços mencionados, tampouco garante a disponibilidade, exatidão ou continuidade de funcionamento dessas APIs.

O uso deste pacote é de responsabilidade do desenvolvedor que o integra em sua aplicação. Certifique-se de revisar os Termos de Uso de cada provedor de API antes de utilizar este pacote em ambientes de produção.

## Licença

Este projeto está licenciado sob a [Licença MIT](https://github.com/lucasmarques2907/cep_fetcher/blob/main/LICENSE).

## Contato

Criado por **Lucas Vinícius Marques**, entre em contato via [LinkedIn](https://www.linkedin.com/in/lucas-vinicius-marques-0a340131b/)
