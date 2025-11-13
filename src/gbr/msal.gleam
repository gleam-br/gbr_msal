//// # Gleam Microsoft Authentication Library
////
//// ```gleam
//// pub fn main() {
////   let cfg =
////     msal.cfg("client_id")
////     |> msal.cfg_add_auth("authority", "https://login.microsoftonline/common")
////     |> msal.cfg_add_cache("cacheLocation", "localStorage")
////
////   use msal <- promise.try_await(msal.new(cfg))
////   use response <- promise.map_try(msal.login(msal, msal.popup, None))
////   msal.res_get(response, "idToken") |> echo
////   msal.res_get(response, "accessToken") |> echo
////   msal.res_parent_get(response, "account", "username") |> echo
//// }
//// ```
////
//// ```gleam
//// pub fn main() {
////   let msal =
////     cfg("client_id")
////     |> cfg_add_auth("authority", "https://login.microsoftonline/common")
////     |> cfg_add_cache("cacheLocation", "localStorage")
////     |> new()
////
////   use msal <- promise.map_try(msal)
////   use account_active <- result.try(account_active(msal))
////
////   echo account_active
//// }
//// ```
////

import gleam/javascript/promise
import gleam/option.{type Option}

import gbr/msal/domain.{
  type Configuration, type Iteraction, type Promise, type Request, type Response,
  Code, Popup, Redirect, Silent,
}

import gbr/msal/ffi_mjs.{
  app, exec_async, get_key, get_parent_key, new_key, set_key, set_parent_key,
}

pub type Msal =
  domain.Msal

pub const code = Code

pub const popup = Popup

pub const silent = Silent

pub const redirect = Silent

pub fn new(cfg: Configuration) -> Promise(Msal) {
  use app <- promise.map_try(app(cfg, "standard"))

  domain.msal(instance: app, config: cfg)
  |> Ok()
}

pub fn nested(cfg: Configuration) -> Promise(Msal) {
  use app <- promise.map_try(app(cfg, "nested"))

  domain.msal(instance: app, config: cfg)
  |> Ok()
}

pub fn cfg(client_id: String) {
  new_key()
  |> set_parent_key("auth", "clientId", client_id)
}

pub fn cfg_add_auth(in: Configuration, key: String, value: a) {
  set_parent_key(in, "auth", key, value)
}

pub fn cfg_add_cache(in: Configuration, key: String, value: a) {
  set_parent_key(in, "cache", key, value)
}

pub fn cfg_add_system(in: Configuration, key: String, value: a) {
  set_parent_key(in, "system", key, value)
}

pub fn req() -> Request {
  new_key()
}

pub fn req_add(in: Request, key: String, value: a) -> Request {
  set_key(in, key, value)
}

pub fn req_parent_add(
  in: Request,
  parent: String,
  key: String,
  value: a,
) -> Request {
  set_parent_key(in, parent, key, value)
}

pub fn res_get(in: Response, key: String) -> Option(a) {
  get_key(in, key)
}

pub fn res_parent_get(in: Response, parent: String, key: String) -> Option(a) {
  get_parent_key(in, parent, key)
}

pub fn login(
  in: Msal,
  iteraction: Iteraction,
  req: Option(Request),
) -> Promise(Response) {
  let iteraction = case iteraction {
    Popup -> "loginPopup"
    Redirect -> "loginRedirect"
    Silent -> "ssoSilent"
    _ -> "loginPopup"
  }
  use instance <- domain.instance(in)
  use response <- promise.map_try(exec_async(
    instance,
    iteraction,
    option.unwrap(req, new_key()),
  ))

  Ok(response)
}

pub fn logout(
  in: Msal,
  iteraction: Iteraction,
  req: Option(Request),
) -> Promise(Nil) {
  let iteraction = case iteraction {
    Popup -> "logoutPopup"
    Redirect -> "logoutRedirect"
    Silent -> "logout"
    _ -> "logoutPopup"
  }
  use instance <- domain.instance(in)
  use _ <- promise.map_try(exec_async(
    instance,
    iteraction,
    option.unwrap(req, new_key()),
  ))

  Ok(Nil)
}

pub fn token(
  in: Msal,
  iteraction: Iteraction,
  req: Request,
) -> Promise(Response) {
  let iteraction = case iteraction {
    Popup -> "acquireTokenPopup"
    Redirect -> "acquireTokenRedirect"
    Silent -> "acquireTokenSilent"
    Code -> "acquireTokenByCode"
  }
  use instance <- domain.instance(in)
  use response <- promise.map_try(exec_async(instance, iteraction, req))

  Ok(response)
}

pub fn handle_redirect(in: Msal) -> Promise(Response) {
  use instance <- domain.instance(in)
  use response <- promise.map_try(exec_async(
    instance,
    "handleRedirectPromise",
    new_key(),
  ))

  Ok(response)
}
