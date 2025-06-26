## 0.1.2

### Corrigido

- Falha no upload do pacote para o pub.dev

## 0.1.1

### Refatorado

- Requisições HTTP centralizadas em uma nova função utilitária getJson, reduzindo duplicação de código entre provedores.
- Adição de headers padrão (`Accept: application/json`, `User-Agent: cep_fetcher/VERSION`) para todas as chamadas às APIs.
- Criação de constante libraryVersion para controle de versão dentro da lib.

### Documentação

- Documentação interna adicionada à função `getJson`, explicando seu uso, comportamento e integridade de retorno.
- Comentários refinados em cada provedor (`◊tryViaCep`, `tryOpenCepApi`, `tryAwesomeApi`) para manter consistência e clareza.

## 0.1.0

### Adicionado

- Aviso legal sobre o uso desta biblioteca e das APIs públicas utilizadas para consulta de dados.

## 0.0.9

### Refatorado

- Função `fetchCepData` retorna dados do CEP ou uma exception com descrição do erro.

## 0.0.8

### Refatorado

- Formatação de arquivos de acordo com o padrão do pub.dev.

## 0.0.7

### Adicionado

- Lançadas exceções personalizadas (`CepFetcherException`, `InvalidCepFormatException`, `TimeoutOutOfRangeException`, `CepNotFoundException`) para melhorar o controle de erros.
- Novo tratamento explícito para CEP inválido `99999999`.
- Cache interno em memória adicionado para evitar chamadas repetidas às APIs para o mesmo CEP.

### Alterado

- A função principal `fetchCepData` agora é global (não requer mais instanciar uma classe).
- Validação de `timeout` agora lança `TimeoutOutOfRangeException` ao invés de `ArgumentError`.
- Mensagens de erro e docstrings refinadas para maior clareza e precisão.
- Atualização do `README.md` com exemplos reais e instruções completas de uso e erros.

### Refatorado

- Código reorganizado: moved funções de provedores para `lib/src/providers` e ocultadas da API pública.
- `debugPrint` foi removido, deixando o controle total de erros para o usuário via exceptions.
- Funções de acesso direto às APIs (`tryViaCep`, etc.) não são mais acessíveis externamente.

### Testes

- Novos testes unitários cobrindo:
  - Tempo de timeout inválido
  - CEP com formato inválido
  - CEP não encontrado
  - Consulta bem-sucedida
  - Reutilização de CEPs já consultados via cache interno

## 0.0.6

### Corrigido

- Passando arquivo de exemplos da pasta lib para a raiz do projeto.

## 0.0.5

### Documentação

- Adicionando comentários `dartdoc` aos arquivos do modelo de cep, exemplo e teste.

## 0.0.4

### Documentação

- Adicionados comentários `dartdoc` à API pública para conformidade com o pub.dev.
- Incluído exemplo funcional em `example/example.dart` demonstrando o uso básico da biblioteca.

## 0.0.3

### Corrigido

- Sincronizando as versões da lib no `pubscep.yaml`

## 0.0.2

### Corrigido

- Adicionado o campo `license` no `pubspec.yaml` e o arquivo `LICENSE` para compatibilidade com o pub.dev.

## 0.0.1

### Adicionado

- Lançamento inicial da biblioteca `cep_fetcher`.
- Suporte a múltiplas APIs de CEP (ViaCEP, AwesomeAPI, OpenCEP).
- Fallback automático entre provedores em caso de falha.
- Validação de CEP (apenas 8 dígitos numéricos).
- Modelo `Cep` com serialização via `toJson`.
- Tratamento de erro silencioso com `debugPrint`.
