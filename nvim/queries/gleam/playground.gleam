pub type Foo {
  Foo(a: String, b: String)
}

pub fn foo(a a: String, b b: String, c c: Int) -> String {
  a <> b
}

pub fn with_callback(a: String, cb: fn () -> String) {
  cb(a)
}

pub fn bar() {
  foo(a: "foo", b: "bar", c: "baz")
  with_callback("foo", fn () {
    "bar"
  })
}

