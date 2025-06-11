/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
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

// export lazy var v;                  // 编译器提示报错：应用编译报错
// export lazy default function f(){}; // 编译器提示报错：应用编译报错
// export lazy default function(){};   // 编译器提示报错：应用编译报错
// export lazy default 42;             // 编译器提示报错：应用编译报错
// export lazy { x };                    // 编译器提示报错：应用编译报错
// export lazy { x as v };               // 编译器提示报错：应用编译报错
// export lazy { x } from 'mod';         // 编译器提示报错：应用编译报错
// export lazy { x as v } from 'mod';    // 编译器提示报错：应用编译报错
// export lazy * from 'mod';           // 编译器提示报错：应用编译报错

// import lazy v from 'mod';           // 编译器提示报错：应用编译报错
// import lazy * as ns from 'mod';     // 编译器提示报错：应用编译报错
//
// import lazy type { obj } from './mod';    // 不支持，编译器、应用编译报错
// import type lazy { obj } from './mod';    // 不支持，编译器、应用编译报错