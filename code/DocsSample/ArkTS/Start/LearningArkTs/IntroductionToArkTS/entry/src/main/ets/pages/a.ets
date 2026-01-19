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

// [Start annotation_export_autoGenerate_dts]
// a.ets
import { ClassAuthor4 } from './author';

export @interface MethodAnno4 {
  data: number = 0;
}

@ClassAuthor4
class MyClass {
  @MethodAnno4({data: 123})
  foo() {}

  @MethodAnno4({data: 456})
  private bar() {}
}
// [End annotation_export_autoGenerate_dts]
// [Start annotation_export_example]
// a.ets
export @interface MyAnno2 {}
export @interface ClassAuthor2 {}
// [End annotation_export_example]
// [Start annotation_import]
// a.ets
export @interface Anno {}

export @interface ClassAuthor1 {}

console.info('hello');
// [End annotation_import]
// [Start annotation_autoGenerate_dts]
// a.ets
export @interface ClassAuthor5 {}

@interface MethodAnno { // 没导出
  data: number;
}
// [End annotation_autoGenerate_dts]