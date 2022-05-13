// Tests behavior when a module is both imported and used from different paths
// when the use has an except list, ensuring that we can still access the
// remaining symbols and utilize qualified access.
module A {
  var x: int = 4;
  proc foo() {
    writeln("In A.foo()");
  }
}
module B {
  public use A as A except foo;
}

module C {
  // Note: this import is private and thus does not impact the symbols available
  import A.foo;
}

module D {
  use B, C;

  proc main() {
    writeln(x);
    writeln(A.x);
    // foo(); // Won't work
    A.foo();
  }
}
