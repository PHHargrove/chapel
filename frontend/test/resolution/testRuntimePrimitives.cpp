/*
 * Copyright 2021-2024 Hewlett Packard Enterprise Development LP
 * Other additional copyright holders may be indicated within.
 *
 * The entirety of this work is licensed under the Apache License,
 * Version 2.0 (the "License"); you may not use this file except
 * in compliance with the License.
 *
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#include "test-resolution.h"

#include "chpl/types/all-types.h"

template <typename F>
static void predicatePrimTypeHelper(const char* primName, std::vector<const char*> args,
                                    F&& predicate,
                                    const char* prelude = "",
                                    QualifiedType::Kind expectedKind = QualifiedType::CONST_VAR) {
  std::string program = prelude;
  program += "var x = __primitive(\"";
  program += primName;
  program += "\"";
  for (auto arg : args) {
    program += ", ";
    program += arg;
  }
  program += ");";
  Context ctx;
  auto context = &ctx;
  QualifiedType qt =  resolveTypeOfXInit(context, std::move(program));
  assert(qt.kind() == expectedKind);
  auto typePtr = qt.type();
  assert(typePtr);
  assert(predicate(typePtr, qt.param()));
}

template <typename T>
static void primTypeHelper(const char* primName, std::vector<const char*> args, const char* prelude = "", QualifiedType::Kind expectedKind = QualifiedType::CONST_VAR) {
  predicatePrimTypeHelper(primName, args, [](const Type* typePtr, const Param* param) {
    return typePtr->is<T>();
  }, prelude, expectedKind);
}

static void intPrimTypeHelper(int width, const char* primName, std::vector<const char*> args, const char* prelude = "", QualifiedType::Kind expectedKind = QualifiedType::CONST_VAR) {
  predicatePrimTypeHelper(primName, args, [width](const Type* typePtr, const Param* param) {
    return typePtr->isIntType() && typePtr->toIntType()->bitwidth() == width;
  }, prelude, expectedKind);
}

static void realPrimTypeHelper(int width, const char* primName, std::vector<const char*> args, const char* prelude = "", QualifiedType::Kind expectedKind = QualifiedType::CONST_VAR) {
  predicatePrimTypeHelper(primName, args, [width](const Type* typePtr, const Param* param) {
    return typePtr->isRealType() && typePtr->toRealType()->bitwidth() == width;
  }, prelude, expectedKind);
}

static void voidPtrPrimTypeHelper(const char* primName, std::vector<const char*> args, const char* prelude = "", QualifiedType::Kind expectedKind = QualifiedType::CONST_VAR) {
  predicatePrimTypeHelper(primName, args, [](const Type* typePtr, const Param* param) {
    return typePtr->isCPtrType() && typePtr->toCPtrType()->isVoidPtr();
  }, prelude, expectedKind);
}

// tests for primitives that should return void
static void testVoidPrims() {
  // test for primitive "chpl_init_record"
  primTypeHelper<VoidType>("chpl_init_record", {});

  // test for primitive "chpl_comm_get"
  primTypeHelper<VoidType>("chpl_comm_get", {});

  // test for primitive "chpl_comm_put"
  primTypeHelper<VoidType>("chpl_comm_put", {});

  // test for primitive "chpl_comm_array_get"
  primTypeHelper<VoidType>("chpl_comm_array_get", {});

  // test for primitive "chpl_comm_array_put"
  primTypeHelper<VoidType>("chpl_comm_array_put", {});

  // test for primitive "chpl_comm_remote_prefetch"
  primTypeHelper<VoidType>("chpl_comm_remote_prefetch", {});

  // test for primitive "chpl_comm_get_strd"
  primTypeHelper<VoidType>("chpl_comm_get_strd", {});

  // test for primitive "chpl_comm_put_strd"
  primTypeHelper<VoidType>("chpl_comm_put_strd", {});

  // test for primitive "shift_base_pointer"
  primTypeHelper<VoidType>("shift_base_pointer", {});

  // test for primitive "array_set"
  primTypeHelper<VoidType>("array_set", {});

  // test for primitive "array_set_first"
  primTypeHelper<VoidType>("array_set_first", {});

  // test for primitive "auto destroy runtime type"
  primTypeHelper<VoidType>("auto destroy runtime type", {});

  // test for primitive "create fn type"
  primTypeHelper<VoidType>("create fn type", {});
}

// test that we can handle non-param string for string_length_bytes
static void test1() {
  intPrimTypeHelper(IntType::defaultBitwidth(), "string_length_bytes", {"s"}, "var s: string;");
}

// test that we can handle non-param bytes for string_length_bytes
static void test2() {
  intPrimTypeHelper(IntType::defaultBitwidth(), "string_length_bytes", {"b"}, "var b: bytes;");
}

static void test3() {
  // test for primitive return type for get real/imag
  realPrimTypeHelper(64, "complex_get_real", {"a"}, "var a: complex(128);", QualifiedType::REF);
}

static void test4() {
  // test for primitive return type for get real/imag
  realPrimTypeHelper(32, "complex_get_real", {"a"}, "var a: complex(64);", QualifiedType::REF);
}

static void test5() {
  // test for primitive return type for get real/imag
  realPrimTypeHelper(64, "complex_get_imag", {"a"}, "var a: complex(128);", QualifiedType::REF);
}

static void test6() {
  // test for primitive return type for get real/imag
  realPrimTypeHelper(32, "complex_get_imag", {"a"}, "var a: complex(64);", QualifiedType::REF);
}

static void test7() {
  // test for primitive "is wide pointer", which should return a bool
  primTypeHelper<BoolType>("is wide pointer", {});
}

// test for primitive "_wide_get_addr", which should return a void ptr
static void test8() {
  voidPtrPrimTypeHelper("_wide_get_addr", {});
}

// test for primitive "steal", which should return the type of the argument
static void test9() {
  intPrimTypeHelper(IntType::defaultBitwidth(), "steal", {"v"}, "var v: int;");
  primTypeHelper<BoolType>("steal", {"v"}, "var v: bool;");
  realPrimTypeHelper(32, "steal", {"v"}, "var v: real(32);");
  realPrimTypeHelper(64, "steal", {"v"}, "var v: real(64);");
}

// test for primitive "getcid", which should return an int32
static void test10() {
  intPrimTypeHelper(32, "getcid", {});
}

// test for primitive "get_union_id", which should return a default int
static void test11() {
  intPrimTypeHelper(IntType::defaultBitwidth(), "get_union_id", {});
}

// "chpl_task_getRequestedSubloc", which should return int 64
static void test12() {
  intPrimTypeHelper(64, "chpl_task_getRequestedSubloc", {});
}

// "class name by id", which should return a cString
static void test13() {
  primTypeHelper<CStringType>("class name by id", {});
}

// "ref to string", which should return a cString
static void test14() {
  primTypeHelper<CStringType>("ref to string", {});
}

// "chpl_lookupFilename", which should return a cString
static void test15() {
  primTypeHelper<CStringType>("chpl_lookupFilename", {});
}

// "_get_user_line", which should return a default int.
static void test16() {
  intPrimTypeHelper(IntType::defaultBitwidth(), "_get_user_line", {});
}

// "_get_user_file", which should return an int32
static void test17() {
  intPrimTypeHelper(32, "_get_user_file", {});
}

// various GPU x/y/z primitives, which all return int(32).
static void test18() {
  intPrimTypeHelper(32, "gpu threadIdx x", {});
  intPrimTypeHelper(32, "gpu threadIdx y", {});
  intPrimTypeHelper(32, "gpu threadIdx z", {});
  intPrimTypeHelper(32, "gpu blockIdx x", {});
  intPrimTypeHelper(32, "gpu blockIdx y", {});
  intPrimTypeHelper(32, "gpu blockIdx z", {});
  intPrimTypeHelper(32, "gpu blockDim x", {});
  intPrimTypeHelper(32, "gpu blockDim y", {});
  intPrimTypeHelper(32, "gpu blockDim z", {});
  intPrimTypeHelper(32, "gpu gridDim x", {});
  intPrimTypeHelper(32, "gpu gridDim y", {});
  intPrimTypeHelper(32, "gpu gridDim z", {});
}

static void test19() {
  voidPtrPrimTypeHelper("gpu allocShared", {"512"});
  voidPtrPrimTypeHelper("gpu allocShared", {"1024"});
  primTypeHelper<ErroneousType>("gpu allocShared", {"v"}, "var v = 1024;", QualifiedType::UNKNOWN);
}

static void test20() {
  primTypeHelper<VoidType>("gpu syncThreads", {});
}

int main() {
  testVoidPrims();
  test1();
  test2();
  test3();
  test4();
  test5();
  test6();
  test7();
  test8();
  test9();
  test10();
  test11();
  test12();
  test13();
  test14();
  test15();
  test16();
  test17();
  test18();
  test19();
  test20();

  return 0;
}
