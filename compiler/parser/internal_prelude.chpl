class Index {
}

pragma "omit for noanalysis" class Array {
  function this(i) {
    return __primitive("array_index", this, i);
  }
  function this(i, j) {
    return __primitive("array_index", this, i, j);
  }
  function this(i, j, k) {
    return __primitive("array_index", this, i, j, k);
  }
  function set(i, x) {
    return __primitive("array_set", this, i, x);
  }
  function set(i, j, x) {
    return __primitive("array_set", this, i, j, x);
  }
  function set(i, j, k, x) {
    return __primitive("array_set", this, i, j, k, x);
  }
}

class Domain {
}

record Tuple {
  function this(pragma "clone_for_constants" i) { 
    return __primitive("index_object", this, i); 
  }
  function set(pragma "clone_for_constants" i, x) {
    return __primitive("set_index_object", this, i, x);
  }
  function _field1 { return __primitive("index_object", this, 1); }
  function set__field1(x) { return __primitive("set_index_object", this, 1, x); }
  function _field2 { return __primitive("index_object", this, 2); }
  function set__field2(x) { return __primitive("set_index_object", this, 2, x); }
}

pragma "builtin" function +(a : Array, b : Array) { return __primitive("array_pointwise_op", a, b); }
pragma "builtin" function -(a : Array, b : Array) { return __primitive("array_pointwise_op", a, b); }
pragma "builtin" function *(a : Array, b : Array) { return __primitive("array_pointwise_op", a, b); }
pragma "builtin" function /(a : Array, b : Array) { return __primitive("array_pointwise_op", a, b); }
pragma "builtin" function &(a : Array, b : Array) { return __primitive("array_pointwise_op", a, b); }
pragma "builtin" function |(a : Array, b : Array) { return __primitive("array_pointwise_op", a, b); }
pragma "builtin" function ^(a : Array, b : Array) { return __primitive("array_pointwise_op", a, b); }
pragma "builtin" function ==(a : Array, b : Array) { return __primitive("array_pointwise_op", a, b); }
pragma "builtin" function !=(a : Array, b : Array) { return __primitive("array_pointwise_op", a, b); }
pragma "builtin" function <=(a : Array, b : Array) { return __primitive("array_pointwise_op", a, b); }
pragma "builtin" function >=(a : Array, b : Array) { return __primitive("array_pointwise_op", a, b); }
pragma "builtin" function <(a : Array, b : Array) { return __primitive("array_pointwise_op", a, b); }
pragma "builtin" function >(a : Array, b : Array) { return __primitive("array_pointwise_op", a, b); }
pragma "builtin" function and(a : Array, b : Array) { return __primitive("array_pointwise_op", a, b); }
pragma "builtin" function or(a : Array, b : Array) { return __primitive("array_pointwise_op", a, b); }
pragma "builtin" function **(a : Array, b : Array) { return __primitive("array_pointwise_op", a, b); }

pragma "builtin" function +(a : numeric, b : numeric) { return __primitive(a, "+", b); }
pragma "builtin" function -(a : numeric, b : numeric) { return __primitive(a, "-", b); }
pragma "builtin" function *(a : numeric, b : numeric) { return __primitive(a, "*", b); }
pragma "builtin" function /(a : numeric, b : numeric) { return __primitive(a, "/", b); }
pragma "builtin" function mod(a : numeric, b : numeric) { return __primitive(a, "%", b); }
pragma "builtin" function ==(a : numeric, b : numeric) { return __primitive(a, "==", b); } 
pragma "builtin" function !=(a : numeric, b : numeric) { return __primitive(a, "!=", b); }
pragma "builtin" function <=(a : numeric, b : numeric) { return __primitive(a, "<=", b); }
pragma "builtin" function >=(a : numeric, b : numeric) { return __primitive(a, ">=", b); }
pragma "builtin" function <(a : numeric, b : numeric) { return __primitive(a, "<", b); }
pragma "builtin" function >(a : numeric, b : numeric) { return __primitive(a, ">", b); }
pragma "builtin" function &(a : numeric, b : numeric) { return __primitive(a, "&", b); }
pragma "builtin" function |(a : numeric, b : numeric) { return __primitive(a, "|", b); }
pragma "builtin" function ^(a : numeric, b : numeric) { return __primitive(a, "^", b); }
pragma "builtin" function and(a : numeric, b : numeric) { return __primitive(a, "&&", b); }
pragma "builtin" function or(a : numeric, b : numeric) { return __primitive(a, "||", b); }
pragma "builtin" function **(a : numeric, b : numeric) { return __primitive(a, "**", b); }
pragma "builtin" function by(a : numeric, b : numeric) { return __primitive(a, "by", b); }
pragma "builtin" function ==(a : object, b : object) { return __primitive("ptr_eq", a, b); }
pragma "builtin" function !=(a : object, b : object) { return __primitive("ptr_neq", a, b); }

pragma "builtin" function =(a : Index, b : integer) { return __primitive("indextype_set", a, b); }
pragma "builtin" function =(a : integer, b : Index) { return __primitive("indextype_get", b); }

pragma "builtin" function =(a : any, b : any) { return b; }

function _chpl_malloc(number, size, description: string);
function _chpl_calloc(number, size, description: string);
function _chpl_free(memory);
function _chpl_realloc(memory, number, size, description: string);

function _init_string() : string;

function _UNION_CHECK(u, tag, filename, lineno);
function _UNION_SET(u, tag);
function _UNION_CHECK_QUIET(u, tag): boolean;

function _INIT_CONFIG(v, v_type, chapel_name, module_name);
function _INIT_ARRAY(rank, arr, dom, elt_type);
function _INIT_DOMAIN_DIM(dom, dim, lo, hi, str);

function _SEQ_APPEND(s, t, type_name);
function _SEQ_INIT_NIL(s);


pragma "omit for noanalysis" class _seq {
  type elementType;

  class _node {
    var element : elementType;
    var next : _node;
  }

  var length : integer;
  var first : _node;
  var last : _node;

  function append(e : elementType) : _seq {
    var new : _node;
    new = _node();
    new.element = e;
    if length > 0 {
      last.next = new;
      last = new;
    } else {
      first = new;
      last = new;
    }
    length += 1;
    return this;
  }

  function prepend(e : elementType) : _seq {
    var new : _node;
    new = _node();
    new.element = e;
    if length > 0 {
      new.next = first;
      first = new;
    } else {
      first = new;
      last = new;
    }
    length += 1;
    return this;
  }

  function concat(s : _seq) : _seq {
    last.next = s.first;
    last = s.last;
    length += s.length;
    return this;
  }

  function copy() : _seq {
    var new : _seq;
    new = _seq();
    for e in this {
      new.append(e);
    }
    return new;
  }

}

pragma "builtin" function #(a : _seq, b : any) { 
  return __primitive("seqcat_element", a, b); 
}

pragma "builtin" function #(a : _seq, b : _seq) { 
  return __primitive("seqcat_seq", a, b); 
}

pragma "omit for noanalysis" function _seq_append(s, e) {
  s.append(e);
}
/*
pragma "omit for noanalysis" function _seq_pound(e, s) {
  s.prepend(e);
}

pragma "omit for noanalysis" function _seq_pound(s1, s2) {
  s1.append_sequence(s2);
}
*/

