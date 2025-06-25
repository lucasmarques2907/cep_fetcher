## [0.0.1] - 2025-06-25
### Adicionado
- Lançamento inicial da biblioteca `cep_fetcher`.
- Suporte a múltiplas APIs de CEP (ViaCEP, AwesomeAPI, OpenCEP).
- Fallback automático entre provedores em caso de falha.
- Validação de CEP (apenas 8 dígitos numéricos).
- Modelo `Cep` com serialização via `toJson`.
- Tratamento de erro silencioso com `debugPrint`.