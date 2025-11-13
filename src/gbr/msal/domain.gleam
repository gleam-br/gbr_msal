////
//// TYPES
////
//// Tipos p/ trabalharmos com a biblioteca @azure/msal-browser.
////

import gleam/javascript/promise

/// Concentra a composição necessária p/ exec. das funções em 'gbr_msal'.
///
/// - `config`: Config da inicialização do msal.
/// - `instance`: Instância do msal criada.
///
/// https://github.com/AzureAD/microsoft-authentication-library-for-js/blob/dev/lib/msal-browser/docs/initialization.md#createpca-pattern
///
pub opaque type Msal {
  Msal(config: Configuration, instance: Application)
}

/// Cria nova instancia de Msal
///
pub fn msal(config config, instance instance) {
  Msal(config:, instance:)
}

/// Extrai instância da aplicação @azure/msal-browser
///
pub fn instance(in: Msal, cb: fn(Application) -> a) -> a {
  let Msal(instance:, ..) = in
  cb(instance)
}

/// IPublicClientApplication
///
/// [lib/msal-browser/docs/initialization.md](https://github.com/AzureAD/microsoft-authentication-library-for-js/blob/dev/lib/msal-browser/docs/initialization.md#initialization-of-msal)
///
pub type Application

/// Configuration
///
/// [lib/msal-browser/docs/configuration.md](https://github.com/AzureAD/microsoft-authentication-library-for-js/blob/dev/lib/msal-browser/docs/configuration.md#configuration-options)
///
pub type Configuration

/// Qualquer objeto de requisição da biblioteca @azure/msal-browser:
///
/// - login: PopupRequest | RedirectRequest | SsoSilentRequest
/// - token: PopupRequest | RedirectRequest | SilentRequest | AuthenticationCodeRequest
/// - logout: EndSessionRequest | EndSessionRequestPopup
/// - account: AccountFilter
///
pub type Request

/// Qualquer objeto de resposta da biblioteca @azure/msal-browser:
///
/// - login: AuthenticationResult
/// - token: AuthenticationResult
/// - account: AccountInfo
/// - logout: void
///
pub type Response

/// AccountInfo
///
/// [lib/msal-common/docs/Accounts.md](https://github.com/AzureAD/microsoft-authentication-library-for-js/blob/dev/lib/msal-common/docs/Accounts.md)
///
pub type AccountInfo =
  Response

/// Iteração c/ o usuário
///
/// [Escolha qual usar](https://github.com/AzureAD/microsoft-authentication-library-for-js/blob/dev/lib/msal-browser/docs/initialization.md#choosing-an-interaction-type)
///
pub type Iteraction {
  Code
  Popup
  Silent
  Redirect
}

/// Erro geral utilizado pela @azure/msal-browser.
/// TODO retornar este erro do ffi.mjs
pub type AuthError {
  /// Atributos:
  ///
  /// * code          : Short string denoting error
  /// * message       : Detailed description of error
  /// * sub           : Describes the subclass of an error
  /// * correlation_id: CorrelationId associated with the error
  AuthError(code: String, message: String, sub: String, correlation_id: String)
}

/// Short alias type
///
pub type Try(a) =
  Result(a, String)

/// Short alias type
///
pub type Promise(a) =
  promise.Promise(Try(a))
