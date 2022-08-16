/*
 * Copyright 2021-2022 Hewlett Packard Enterprise Development LP
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

#ifndef CHPL_UAST_NAMEDDECL_H
#define CHPL_UAST_NAMEDDECL_H

#include "chpl/uast/Decl.h"
#include "chpl/framework/UniqueString.h"

namespace chpl {
namespace uast {


/**
  This is an abstract base class for declarations that carry a name.
 */
class NamedDecl : public Decl {

 private:
  UniqueString name_;

 protected:
  NamedDecl(AstTag tag, Decl::Visibility visibility, Decl::Linkage linkage,
            int attributesChildNum,
            UniqueString name)
    : Decl(tag, attributesChildNum, visibility, linkage),
      name_(name) {
  }

  NamedDecl(AstTag tag, AstList children, int attributesChildNum,
            Decl::Visibility visibility,
            Decl::Linkage linkage,
            int linkageNameChildNum,
            UniqueString name)
    : Decl(tag, std::move(children), attributesChildNum, visibility,
           linkage,
           linkageNameChildNum),
      name_(name) {
  }

  bool namedDeclContentsMatchInner(const NamedDecl* other) const {
    return this->name_ == other->name_ &&
           declContentsMatchInner(other);
  }

  void namedDeclMarkUniqueStringsInner(Context* context) const {
    name_.mark(context);
  }

 public:
  virtual ~NamedDecl() = 0; // this is an abstract base class

  UniqueString name() const { return name_; }
};


} // end namespace uast
} // end namespace chpl

#endif
