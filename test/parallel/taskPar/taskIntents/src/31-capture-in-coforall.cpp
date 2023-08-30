// Test value capturing in a coforall.

#include "support-decls.cpp"

/////////////////////////////////////////////////////////////////////////////
writeln("=== at the module level ===");
#include "capture-coforall.cpp"

/////////////////////////////////////////////////////////////////////////////
writeln("=== in a function ===");
proc test() {
#include "capture-coforall.cpp"
}
test();

/////////////////////////////////////////////////////////////////////////////
writeln("=== in a begin ===");
var sbegin: sync int;
begin {
#include "capture-coforall.cpp"
  sbegin = 1;
}
sbegin;

/////////////////////////////////////////////////////////////////////////////
writeln("=== in a cobegin ===");
cobegin {
  var iiiii: int;
  {
#include "capture-coforall.cpp"
  }
}

/////////////////////////////////////////////////////////////////////////////
writeln("=== in a coforall ===");
coforall iiiii in 1..3 {
  if iiiii == 2 {
#include "capture-coforall.cpp"
  }
}

/////////////////////////////////////////////////////////////////////////////
writeln("=== done ===");
