# Contribuindo com o Gleam

Obrigado por contribuir com o Gleam!

Antes de continuar, leia nosso [código de conduta][código-de-conduta] que todos os colaboradores devem cumprir.

[Código-De-Conduta]: https://github.com/gleam-lang/gleam/blob/main/CODE_OF_CONDUCT.md

## Contribuindo com relatórios de bugs

Se você encontrou um bug no Gleam, verifique se há um ticket aberto para este problema em [nosso rastreador de problemas do GitHub][issues]. Se você não conseguir encontrar um ticket existente para o bug, abra um novo.

[Problemas]: https://github.com/gleam-lang/gleam/issues

Um bug pode ser um problema técnico, como uma falha do compilador ou um valor de retorno incorreto de uma função de biblioteca, ou um problema de experiência do usuário, como documentação pouco clara ou ausente. Se não tiver certeza se o seu problema é um bug, abra um ticket e resolveremos juntos.

## Contribuindo com alterações no código

Antes de trabalhar no código, sugerimos que você leia o arquivo [docs/compiler/README.md](docs/compiler/README.md).

Ele descreve os componentes fundamentais e o design deste projeto.

Alterações no código do Gleam são bem-vindas através do processo abaixo.

1. Encontre ou abra uma issue do GitHub relevante para a alteração que você deseja fazer e comente dizendo que deseja trabalhar nessa issue. Se a alteração introduzir uma nova funcionalidade ou comportamento, este seria um bom momento para discutir os detalhes da alteração para garantir que estamos de acordo sobre como a nova funcionalidade deve funcionar.
2. Atualize o arquivo [CHANGELOG.md](CHANGELOG.md) com suas alterações.
3. Abra um pull request do GitHub com suas alterações e garanta que os testes e a compilação passem no CI.
4. Um membro da equipe do Gleam revisará as alterações e poderá fornecer feedback para trabalharmos nelas. Dependendo da alteração, pode haver várias rodadas de feedback.
5. Assim que as alterações forem aprovadas, o código será rebaseado na branch `main`.

## Desenvolvimento local

Para executar os testes do compilador. Isso exigirá a instalação de uma versão estável recente do Rust, Erlang, Elixir, NodeJS, Deno e Bun.

Se você estiver usando o gerenciador de pacotes Nix, há um [flake gleam-nix](https://github.com/vic/gleam-nix) que você pode usar para executar qualquer versão do Gleam ou obter rapidamente um ambiente de desenvolvimento para o Gleam.

```shell
cargo test

# Ou, se você tiver o watchexec instalado, poderá executá-los automaticamente
# quando os arquivos forem alterados
make test-watch
```

Para executar os testes de integração de linguagem. Isso exigirá a instalação de uma versão estável recente do Rust, Erlang e NodeJS.

```shell
make language-test
```

Se você não tiver Rust ou Cargo instalados, pode executar o comando acima em uma sandbox do Docker.

Execute o comando abaixo neste diretório.

```shell
docker run -v $(pwd):/opt/app -it -w /opt/app rust:latest bash
```

## Desenvolvimento em Rust

Aqui estão algumas dicas e diretrizes para escrever código Rust no compilador Gleam:

A variável de ambiente `GLEAM_LOG` pode ser usada para fazer com que o compilador imprima mais informações para depuração e introspecção. Por exemplo, `GLEAM_LOG=trace`.

### Clippy linter

Seu PR pode falhar na CI devido a erros do Clippy. O Clippy pode ser executado localmente da seguinte forma:

```shell
cargo clean -p gleam
cargo clippy
```

Se você tiver erros de lint no CI, mas não tiver atualizado localmente sua versão do Rust para a última versão estável.

```shell
rustup upgrade stable
```

## Esquema do Cap'n Proto

O compilador usa um esquema do Cap'n Proto para serializar/desserializar informações do módulo.

Ocasionalmente, o esquema precisa ser alterado. Após modificar `compiler-core/schema.capnp` você precisa gerar novamente `compiler-core/generated/schema_capnp.rs`.

Para fazer isso, [instale o Cap'n Proto](https://capnproto.org/install.html) e descomente as linhas apropriadas em `compiler-core/build.rs`. Então você poderá gerar novamente esse arquivo com:

```shell
cd compiler-core
cargo build
```
