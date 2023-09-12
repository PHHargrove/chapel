module Deque {
  use CTypes;

  extern type deque_t;
  extern type deque_iterator_t;

  extern proc deque_init(eltSize: c_ssize_t, ref deque: deque_t, initSize: c_ssize_t);
  extern proc deque_push_front(eltSize: c_ssize_t, ref deque: deque_t, ref val);
  extern proc deque_push_back(eltSize: c_ssize_t, ref deque: deque_t, ref val);
  extern proc deque_pop_front(eltSize: c_ssize_t, ref deque: deque_t);
  extern proc deque_pop_back(eltSize: c_ssize_t, ref deque: deque_t);
  extern proc deque_destroy(ref deque: deque_t);

  extern proc deque_last(eltSize: c_ssize_t, ref deque: deque_t): deque_iterator_t;
  extern proc deque_begin(ref deque: deque_t): deque_iterator_t;
  extern proc deque_it_get_cur(eltSize: c_ssize_t, it: deque_iterator_t, ref output);
  extern proc deque_size(eltSize: c_ssize_t, ref deque: deque_t): c_ssize_t;

  extern proc sizeof(type t): c_ssize_t;

  record deque {
    type eltType;
    var d: deque_t;
    proc init(type eltType) {
      this.eltType = eltType;
      init this;
      deque_init(sizeof(eltType), d, 0);
    }
    proc ref deinit() {
      deque_destroy(d);
    }
    proc pushFront(x: eltType) {
      var t = x;
      deque_push_front(sizeof(eltType), d, t);
    }
    proc ref pushBack(x: eltType) {
      var t = x;
      deque_push_back(sizeof(eltType), d, t);
    }
    proc ref getFront() {
      var t: eltType;
      deque_it_get_cur(sizeof(eltType), deque_begin(d), t);
      return t;
    }
    proc getBack() {
      var t: eltType;
      deque_it_get_cur(sizeof(eltType), deque_last(sizeof(eltType), d), t);
      return t;
    }
    proc ref popFront() {
      var front: eltType = getFront(); // = getFront():eltType;
      deque_pop_front(sizeof(eltType), d);
      return front;
    }
    proc popBack() {
      var back: eltType = getBack();
      deque_pop_back(sizeof(eltType), d);
      return back;
    }
    proc ref empty() {
      return deque_size(sizeof(eltType), d) == 0;
    }
  }
}
