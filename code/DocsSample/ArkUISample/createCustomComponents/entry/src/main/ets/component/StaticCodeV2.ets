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
// [Start Static_code_V2]
@ComponentV2
struct MyComponentV2 {
  static a: string = '';
  // 静态代码块生效，a的值变为'hello world'
  static {
    this.a = 'hello world';
  };
  // [StartExclude Static_code_V2]
  build() {
      Column(){
        Text(MyComponentV2.a)
      }
      .width('100%')
      .height('100%')
  }
  // [EndExclude Static_code_V2]
}
// [End Static_code_V2]
