## [0.0.1] - 2025-06-25
### Adicionado
- Lançamento inicial da biblioteca `cep_fetcher`.
- Suporte a múltiplas APIs de CEP (ViaCEP, AwesomeAPI, OpenCEP).
- Fallback automático entre provedores em caso de falha.
- Validação de CEP (apenas 8 dígitos numéricos).
- Modelo `Cep` com serialização via `toJson`.
- Tratamento de erro silencioso com `debugPrint`.

## [0.0.2] - 2025-06-25
### Corrigido
- Adicionado o campo `license` no `pubspec.yaml` e o arquivo `LICENSE` para compatibilidade com o pub.dev.

## [0.0.3] - 2025-06-25
### Corrigido
- Sincronizando as versões da lib no `pubscep.yaml`

## [0.0.4] - 2025-06-25
### Documentação
- Adicionados comentários `dartdoc` à API pública para conformidade com o pub.dev.
- Incluído exemplo funcional em `example/example.dart` demonstrando o uso básico da biblioteca.