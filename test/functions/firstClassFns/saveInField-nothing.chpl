record Foo {
  var funcStored = false;
  var funcField: func(int, bool) = none;

  proc init(x: func(int, bool)) {
    funcStored = true;
    funcField = x;
  }

  proc init() {
    this.complete();
  }

  proc callTheField(arg: int) {
    if (funcStored) {
      if (funcField(arg)) {
        writeln("fcf with arg ", arg, " successful");
      } else {
        writeln("fcf with arg ", arg, " unsuccessful");
      }
    } else {
      writeln("no fcf stored");
    }
  }
}

proc bar(x: int): bool {
  if (x * 3 > 15) {
    return true;
  } else {
    return false;
  }
}

var f1 = new Foo(bar);
f1.callTheField(2);
f1.callTheField(6);
var f2 = new Foo();
f2.callTheField(17);
