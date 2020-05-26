/*
 * Copyright 2020 Hewlett Packard Enterprise Development LP
 * Copyright 2004-2019 Cray Inc.
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

#ifndef _AUTO_LOCAL_ACCESS_H_
#define _AUTO_LOCAL_ACCESS_H_

#include "CallExpr.h"
#include "symbol.h"

bool adjustAutoLocalAccessStatic(CallExpr *call, Immediate *imm);
bool adjustAutoLocalAccessDynamic(CallExpr *call);

Expr *resolveMaybeLocalThis(CallExpr *call);

void analyzeArrays();

#endif
