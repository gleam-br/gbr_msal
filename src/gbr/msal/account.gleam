////
//// Módulo sobre a conta do usuário
////
//// [lib/msal-browser/docs/accounts.md](https://github.com/AzureAD/microsoft-authentication-library-for-js/blob/dev/lib/msal-browser/docs/accounts.md)
////
//// [lib/msal-common/docs/multi-tenant-accounts.md](https://github.com/AzureAD/microsoft-authentication-library-for-js/blob/dev/lib/msal-common/docs/multi-tenant-accounts.md)
////

import gleam/bool
import gleam/javascript/array
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/result

import gbr/msal/domain.{type AccountInfo, type Msal, type Request, type Try}
import gbr/msal/ffi_mjs.{exec_sync, new_key}

/// Existe alguma conta de usuário autenticada no cache.
///
pub fn is_authenticated(in: Msal) -> Result(Bool, String) {
  use account <- result.map(account_first(in))

  option.is_some(account)
}

/// Recupera a primeira conta do usuário encontrada, sendo na ordem:
///
/// 1. [Recupera a conta ativa](https://github.com/AzureAD/microsoft-authentication-library-for-js/blob/dev/lib/msal-browser/docs/accounts.md#active-account-apis)
/// 2. [Recupera a conta do cache](https://github.com/AzureAD/microsoft-authentication-library-for-js/blob/dev/lib/msal-browser/docs/accounts.md#usage)
/// 3. [Recupera a 1a. conta das contas no cache](https://github.com/AzureAD/microsoft-authentication-library-for-js/blob/dev/lib/msal-browser/docs/accounts.md#usage)
///
pub fn account_first(in: Msal) -> Result(Option(AccountInfo), String) {
  use active <- result.try(account_active(in))
  use <- bool.guard(option.is_some(active), Ok(active))

  use account <- result.try(account(in, None))
  use <- bool.guard(option.is_some(account), Ok(account))

  use accounts <- result.map(accounts(in, None))

  case accounts {
    Some(accounts) -> option.from_result(list.first(accounts))
    None -> None
  }
}

/// Recupera a conta ativa disponível do cliente
///
/// [lib/msal-browser/docs/login-user.md#account-apis](https://github.com/AzureAD/microsoft-authentication-library-for-js/blob/dev/lib/msal-browser/docs/login-user.md#account-apis)
///
pub fn account_active(in: Msal) -> Try(Option(AccountInfo)) {
  use instance <- domain.instance(in)
  use response <- result.map(exec_sync(instance, "getActiveAccount", new_key()))

  response
}

/// Seta a conta ativa disponível do cliente
///
/// [lib/msal-browser/docs/login-user.md#account-apis](https://github.com/AzureAD/microsoft-authentication-library-for-js/blob/dev/lib/msal-browser/docs/login-user.md#account-apis)
///
pub fn account_active_set(in: Msal, account: AccountInfo) -> Try(AccountInfo) {
  use instance <- domain.instance(in)
  use _void <- result.map(exec_sync(instance, "setActiveAccount", account))

  account
}

/// Recupera as contas disponíveis do cliente
///
/// [lib/msal-browser/docs/accounts.md](https://github.com/AzureAD/microsoft-authentication-library-for-js/blob/dev/lib/msal-browser/docs/accounts.md)
///
pub fn account(in: Msal, req: Option(Request)) -> Try(Option(AccountInfo)) {
  use instance <- domain.instance(in)
  use response <- result.map(exec_sync(
    instance,
    "getAccount",
    option.unwrap(req, new_key()),
  ))

  response
}

/// Recupera as contas disponíveis do cliente
///
/// [lib/msal-browser/docs/accounts.md](https://github.com/AzureAD/microsoft-authentication-library-for-js/blob/dev/lib/msal-browser/docs/accounts.md)
///
pub fn accounts(
  in: Msal,
  req: Option(Request),
) -> Try(Option(List(AccountInfo))) {
  use instance <- domain.instance(in)
  use response <- result.map(exec_sync(
    instance,
    "getAllAccounts",
    option.unwrap(req, new_key()),
  ))

  use response <- option.map(response)

  array.to_list(response)
}

/// Recupera a conta disponíveis por 'username'.
///
/// [lib/msal-browser/docs/accounts.md](https://github.com/AzureAD/microsoft-authentication-library-for-js/blob/dev/lib/msal-browser/docs/accounts.md)
///
pub fn account_by_name(in: Msal, username: String) -> Try(Option(AccountInfo)) {
  use instance <- domain.instance(in)
  use response <- result.map(exec_sync(
    instance,
    "getAccountByUsername",
    username,
  ))

  response
}
