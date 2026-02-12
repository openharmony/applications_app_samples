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
// NameAnno.d.ets 编译器生成的声明文件
import { ClassAuthor4 } from './Author';

export declare @interface MethodAnno4 {
  data: number = 0;
}

@ClassAuthor4
export declare class MyClass {
  @MethodAnno4({data: 123})
  foo(): void;

  bar; // 私有方法不保留注解
}
// [End annotation_export_autoGenerate_dts]

// [Start annotation_export_dts]
// NameAnno.d.ets
export declare @interface ClassAuthor3 {}
// [End annotation_export_dts]

// [Start annotation_autoGenerate_dts]
// NameAnno.d.ets 编译器生成的声明文件
export declare @interface ClassAuthor5 {}
// [End annotation_autoGenerate_dts]

// [Start annotation_name]
// NameAnno.d.ets
export declare @interface NameAnno{name: string = ""}
// [End annotation_name]

// [Start annotation_anno]
// NameAnno.d.ets
export declare @interface MyAnno {}
// [End annotation_anno]

// [Start annotation_developerGenerate_dts]
// NameAnno.d.ets 开发者生成的声明文件
@interface ClassAuthor6 {}

@ClassAuthor6 // 声明文件中有注解
class C {
  // ...
}
// [End annotation_developerGenerate_dts]