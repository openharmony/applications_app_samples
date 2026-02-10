/*
* Copyright (C) 2026 Huawei Device Co., Ltd.
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
* http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/

// Annotation.ets
import { Anno } from './MyAnno';
// [Start annotation_export_example_import]
// [Start annotation_import_example]
// Annotation.ets
import { MyAnno2 } from './MyAnno';
import * as ns from './MyAnno';
// [StartExclude annotation_export_example_import]
// 仅引用了Anno注解，不会导致MyAnno.ets的console.info执行
class X {
  // ...
}
// [End annotation_import_example]
// [EndExclude annotation_export_example_import]
@MyAnno2
@ns.ClassAuthor2
class C {
  // ...
}
// [End annotation_export_example_import]
// [Start annotation_statement]
// 注解的声明：
@interface ClassAuthor {
  authorName: string
}

// 注解的使用：
@ClassAuthor({authorName: "Bob"})
class MyClass {
  // ...
}
// [End annotation_statement]
// [Start annotation_statement_example]
@interface ClassPreamble {
  authorName: string;
  revision: number = 1;
}
@interface MyAnno {}
// [End annotation_statement_example]
// [Start annotation_statement_multiple]
@MyAnno()
@ClassAuthor({authorName: "John Smith"})
class MyClass1 {
  // ...
}
// [End annotation_statement_multiple]
// [Start annotation_usages_example]
@ClassPreamble({authorName: "John", revision: 2})
class C1 {
  // ...
}


@ClassPreamble({authorName: "Bob"}) // revision的默认值为1
class C2 {
  // ...
}

@MyAnno() // 对类和方法可以同时使用同一个注解
class C3 {
  @MyAnno()
  foo() {}
  @MyAnno()
  static bar() {}
}
// [End annotation_usages_example]
@interface ClassPreamble1 {
  authorName: string;
  revision: number = 1;
}
// [Start annotation_field_order]
@ClassPreamble1({authorName: "John", revision: 2})
// [StartExclude annotation_field_order]
class C5 {}
// [EndExclude annotation_field_order]
// the same as:
@ClassPreamble1({revision: 2, authorName: "John"})
// [End annotation_field_order]
class C6 {}
// [Start annotation_array]
@interface ClassPreamble2 {
  authorName: string;
  revision: number = 1;
  reviewers: string[];
}

@ClassPreamble2(
{
  authorName: "Alice",
  reviewers: ["Bob", "Clara"]
}
)
class C0 {
  // ...
}
// [End annotation_array]
// [Start annotation_omit]
@MyAnno
class C4 {
  // ...
}
// [End annotation_omit]
// [Start annotation_export]
export @interface MyAnno1 {}
// [End annotation_export]