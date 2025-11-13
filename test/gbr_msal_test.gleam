import gleeunit

pub fn main() -> Nil {
  gleeunit.main()
}

// gleeunit test functions end in `_test`
pub fn gbr_msal_todo_test() {
  let name = "Gleam BR MSAL"
  let greeting = "Hello, " <> name <> "!"

  assert greeting == "Hello, Gleam BR MSAL!"
}
