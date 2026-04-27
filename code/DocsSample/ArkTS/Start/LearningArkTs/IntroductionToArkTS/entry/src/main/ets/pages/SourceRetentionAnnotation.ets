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

// [Start annotation_source_retention_annotation]
import { Retention, RetentionPolicy } from '@kit.ArkTS';

// 构造用户自定义源码态注解
@Retention({policy: RetentionPolicy.SOURCE})
@interface SourceAnnotation {}
// 源码态注解可以在类和类成员上使用
@SourceAnnotation
class C {
  @SourceAnnotation
  private name_: string = '';
  @SourceAnnotation
  get name(): string {
    return this.name_;
  }
}
// 源码态注解可以在变量声明上使用
@SourceAnnotation
let a = 1;
// 源码态注解可以在接口和接口成员上使用
@SourceAnnotation
interface I {
  @SourceAnnotation
  foo(): void
}
// 源码态注解可以在注解上使用
@SourceAnnotation
@interface Anno {}
// 源码态注解可以在函数上使用
@SourceAnnotation
function func () {}
// 源码态注解可以在命名空间上使用
@SourceAnnotation
namespace ns {}
// 源码态注解可以在类型别名上使用
@SourceAnnotation
type A = number;
// 源码态注解可以在枚举上使用
@SourceAnnotation
enum ColorSet { RED, GREEN, BLUE }
// [End annotation_source_retention_annotation]