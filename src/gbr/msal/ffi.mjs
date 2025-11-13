/**
 * @packageDocumentation
 * @module gmsal
 */

////
//// # FFI p/ funções do @azure/msal-browser
////

import * as msal from "@azure/msal-browser";

import { Ok, Error } from "../gleam.mjs"
import { Some, None } from "../../gleam_stdlib/gleam/option.mjs"

/// Browser check variables
/// If you support IE, our recommendation is that you sign-in using Redirect APIs
/// If you as a developer are testing using Edge InPrivate mode, please add "isEdge" to the if check
///
/// Somente usamos a iteração via redirecionamento se o agente for
/// o Internet Explorer, senão utilizamos via popup que utiliza as
/// novas bibliotecas assíncronas do browser, que são mais seguras.
///
/// https://github.com/AzureAD/microsoft-authentication-library-for-js/blob/dev/samples/msal-browser-samples/TestingSample/app/auth.js
///
const ua = window.navigator.userAgent;
const msie = ua.indexOf("MSIE ");
const msie11 = ua.indexOf("Trident/");
const msedge = ua.indexOf("Edge/");
const firefox = ua.indexOf("Firefox");

export const isIE = msie > 0 || msie11 > 0;
export const isEdge = msedge > 0;
// Only needed if you need to support the redirect flow in Firefox incognito
export const isFirefox = firefox > 0;

/// Cria e inicializa nova instância padrão do msal.
///
/// - config: msal.Configuration
/// - controller: 'nested' ou 'standard' (padrão)
///
export function app(config, controller) {
  switch (controller) {
    case "nested":
      return execApp(
        () => msal.createNestablePublicClientApplication(config),
        "new app nested")
    default:
      return execApp(
        () => msal.createStandardPublicClientApplication(config),
        "new app standard")
  }
}

export function execute(app, mode, fn, req) {
  let exe = execAppSync
  if (mode === 'async') {
    exe = execApp
  }
  return exe(
    () => emptyKeyValue(req) ? app[`${fn}`]() : app[`${fn}`](req),
    `exec ${mode} ${fn} ${req && req != {} ? 'w/' : 'without'} request`)
}

export function newKeyValue() {
  return {}
}

export function emptyKeyValue(result) {
  return !result
    || result === undefined
    || result === null
    || (typeof result === "object" && result == {})
}

export function setKey(result, key, value) {
  if (!result) result = {}
  result[key] = value
  return result
}

export function setParentKey(result, parent, key, value) {
  if (!result) result = {}
  if (!result[parent]) result[parent] = {}
  result[parent][key] = value
  return result
}

export function getKey(result, key) {
  if (result
    && result[key]
    && result[key] !== undefined
    && result[key] !== null) {
    return new Some(result[key])
  }
  return new None()
}

export function getParentKey(result, parent, key) {
  if (result
    && result[parent]
    && result[parent] !== undefined
    && result[parent] !== null
    && result[parent][key]
    && result[parent][key] !== undefined
    && result[parent][key] !== null
  ) return new Some(result[parent][key])
  return new None()
}

// PRIVATES
//

/// Função de log p/ imprimir mensagem no web console.
///
function log(msg) {
  console.log("LOG:gmsal:", msg)
}

async function execApp(cb, info) {
  try {
    log(info + " [REQ]")
    const result = await cb()
    log(info + " [OK]")
    if (emptyKeyValue(result)) {
      return new Ok()
    }
    return new Ok(result)
  } catch (error) {
    return newError(error, info + " [ERROR]")
  }
}

/// TODO
/// - Desenvolver [ try silent + iteration_required_error + login popup|redirect ]
/// - Tratar AuthError(errorCode,errorMessage,subError,correlationId)
///
/// https://github.com/AzureAD/microsoft-authentication-library-for-js/blob/b08a46c1a4a2fbc2eac4521e5e672a084998940d/samples/msal-browser-samples/VanillaJSTestApp2.0/app/pop/auth.js#L85-L98
///
async function tryOr(tryCb, orCb, info) {
  try {
    log(info + " [REQ]")
    const result = await tryCb()
    log(info + " [OK]")
    if (emptyKeyValue(result)) {
      return new Ok()
    }
    return new Ok(result)
  } catch (error) {
    if (!(error instanceof msal.InteractionRequiredAuthError)) {
      return newError(error, info + " [ERROR]")
    }

    try {
      console.warn(info, error)
      log(info + " fallback [REQ]")
      const result = await orCb()
      log(info + " fallback [OK]")
      return new Ok(result)
    } catch (error2) {
      return newError(error2, info + " fallback [ERROR]")
    }
  }
}

function execAppSync(cb, info) {
  try {
    log(info + " [REQ]")
    let result = cb()
    log(info + " [OK]")
    if (result) {
      return new Ok(new Some(result))
    }
    return new Ok(new None)
  } catch (error) {
    return newError(error, info + " [ERROR]")
  }
}

function newError(error, alt) {
  console.error(">", error)
  console.error(">>> CAUSE", alt)
  return new Error(error ? error.toString() : alt)
}
