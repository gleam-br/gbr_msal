# 🛂 Gleam Microsoft Authorization Library

🚧 **Work in progress** not production ready.

[Gleam](https://gleam.run/) integration to MSAL, [@azure/msal-browser](https://github.com/AzureAD/microsoft-authentication-library-for-js/tree/dev/lib/msal-browser).

Mais sobre [MS OAuth2](https://docs.microsoft.com/azure/active-directory/develop/v2-oauth2-auth-code-flow).

⚠️ Alerta:

[Login user without hint](https://github.com/AzureAD/microsoft-authentication-library-for-js/blob/dev/lib/msal-browser/docs/login-user.md#without-user-hint)

[![Package Version](https://img.shields.io/hexpm/v/gbr_msal)](https://hex.pm/packages/gbr_msal)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/gbr_msal/)

```sh
gleam add gbr_msal@1
```

Further documentation can be found at <https://hexdocs.pm/gbr_msal>.

## Development

```sh
gleam run   # Run the project
gleam test  # Run the tests
```

## ⚡ Funcionalidades

- [Init](https://github.com/AzureAD/microsoft-authentication-library-for-js/blob/dev/lib/msal-browser/docs/initialization.md)
- [Login](https://github.com/AzureAD/microsoft-authentication-library-for-js/blob/dev/lib/msal-browser/docs/login.md)
- [Redirect](https://github.com/AzureAD/microsoft-authentication-library-for-js/blob/dev/lib/msal-browser/docs/initialization.md#redirect-apis)
- [Token](https://github.com/AzureAD/microsoft-authentication-library-for-js/blob/dev/lib/msal-browser/docs/acquire-token.md)
- [Logout](https://github.com/AzureAD/microsoft-authentication-library-for-js/blob/dev/lib/msal-browser/docs/logout.md)
- [Considerações](https://github.com/AzureAD/microsoft-authentication-library-for-js/blob/dev/lib/msal-browser/docs/login-user.md#redirecturi-considerations)

## 🎨 Misc

- [AT Pop](https://github.com/AzureAD/microsoft-authentication-library-for-js/blob/dev/lib/msal-browser/docs/access-token-proof-of-possession.md)
  - [SHR Claims](https://github.com/AzureAD/microsoft-authentication-library-for-js/blob/dev/lib/msal-browser/docs/shr-client-claims.md)
  - [SHR Nonce](https://github.com/AzureAD/microsoft-authentication-library-for-js/blob/dev/lib/msal-browser/docs/shr-server-nonce.md)
- [Resources and scopes](https://github.com/AzureAD/microsoft-authentication-library-for-js/blob/dev/lib/msal-browser/docs/resources-and-scopes.md)
- [Events](https://github.com/AzureAD/microsoft-authentication-library-for-js/blob/dev/lib/msal-browser/docs/events.md)
- [IFrame](https://github.com/AzureAD/microsoft-authentication-library-for-js/blob/dev/lib/msal-browser/docs/iframe-usage.md)
- [Erros](https://github.com/AzureAD/microsoft-authentication-library-for-js/blob/dev/lib/msal-browser/docs/errors.md)
- [SPA](https://learn.microsoft.com/en-us/entra/identity-platform/authentication-flows-app-scenarios#single-page-public-client-and-confidential-client-applications)
- [FAQ](https://github.com/AzureAD/microsoft-authentication-library-for-js/blob/dev/lib/msal-react/FAQ.md)

### 🍸 Exemplos

- [Vue3](https://github.com/AzureAD/microsoft-authentication-library-for-js/tree/dev/samples/msal-browser-samples/vue3-sample-app/src)
- [VanillaJS](https://github.com/AzureAD/microsoft-authentication-library-for-js/blob/dev/samples/msal-browser-samples/VanillaJSTestApp2.0/app/onPageLoad/auth.js)

## ✈️ Utilizando

Adicione a dependência ao seu projeto:

```sh
gleam add gmsal
```

Faça seu primeiro login na microsoft usando o Gleam ⭐

```gleam
import gmsal

pub fn main() {
  let cfg =
    gmsal.cfg("client_id")
    |> gmsal.cfg_add_auth("authority", "https://login.microsoftonline/common")
    |> gmsal.cfg_add_cache("cacheLocation", "localStorage")

  use msal <- promise.try_await(gmsal.new(cfg))
  use response <- promise.map_try(gmsal.login(msal, gmsal.popup, None))

  gmsal.res_get(response, "idToken") |> echo
  gmsal.res_get(response, "accessToken") |> echo
  gmsal.res_parent_get(response, "account", "username") |> echo
  gmsal.res_parent_get(response, "account", "name") |> echo
}
```

Ou, consulte dados da conta de usuário ativa no cache msal-browser:

```gleam

import gmsal
import gmsal/account.{account_active}

pub fn main() {
  let cfg =
    gmsal.cfg("client_id")
    |> gmsal.cfg_add_auth("authority", "https://login.microsoftonline/common")
    |> gmsal.cfg_add_cache("cacheLocation", "localStorage")

  use msal <- promise.map_try(gmsal.new(cfg))
  use account_active <- result.try(account_active(msal))

  echo account_active
}
```

> Mais sobre e documentação pode ser encontrada aqui <https://hexdocs.pm/gmsal>.

## 🧪 Contribuindo

- [Código de Conduta](./CODE_OF_CONDUCT.md)
- [Como contribuir](./CONTRIBUTING.md)

## 🌄 Roadmap

- [ ] Unit tests
- [ ] More docs
- [ ] GH workflow
  - [ ] test & build
  - [ ] changelog & publish