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
@Entry
  // [Start Static_code_V1]
@Component
struct MyComponentCodeV1 {
  static a: string = '';
  // 静态代码块不生效，a的值仍为空字符串''
  static {
    this.a = 'hello world';
  }
  // [StartExclude Static_code_V1]
  build() {
    Column() {
      // $r('app.string.static_code')需要替换为开发者所需的资源文件
      Text(MyComponentCodeV1.a === '' ? $r('app.string.static_code') : MyComponentCodeV1.a)
    }
    .width('100%')
    .height('100%')
  }

  // [EndExclude Static_code_V1]
}

// [End Static_code_V1]


