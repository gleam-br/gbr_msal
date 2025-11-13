////
//// Gleam MSAL FFI JS
////

import gleam/option.{type Option}

import gbr/msal/domain.{type Application, type Promise, type Try}

@external(javascript, "./ffi.mjs", "app")
pub fn app(config: a, controller: String) -> Promise(Application)

pub fn exec_sync(app: Application, method: String, req: a) -> Try(Option(b)) {
  execute(app, "sync", method, req)
}

pub fn exec_async(app: Application, method: String, req: a) -> Promise(b) {
  execute(app, "async", method, req)
}

@external(javascript, "./ffi.mjs", "newKeyValue")
pub fn new_key() -> a

pub fn not_empty(obj: a) -> Bool {
  !empty_key(obj)
}

@external(javascript, "./ffi.mjs", "execute")
fn execute(app: Application, mode: String, method: String, req: a) -> b

@external(javascript, "./ffi.mjs", "emptyKeyValue")
fn empty_key(obj: a) -> Bool

@external(javascript, "./ffi.mjs", "setKey")
pub fn set_key(obj: a, key: String, value: b) -> a

@external(javascript, "./ffi.mjs", "setParentKey")
pub fn set_parent_key(obj: a, parent: String, key: String, value: b) -> a

@external(javascript, "./ffi.mjs", "getKey")
pub fn get_key(obj: a, key: String) -> Option(b)

@external(javascript, "./ffi.mjs", "getParentKey")
pub fn get_parent_key(obj: a, parent: String, key: String) -> Option(b)
