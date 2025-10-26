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

// [Start ProtectedInStruct_CorrectCase]
@Entry
@Component
struct PISCorrectAccessRestrictions  {
  build() {
    Column() {
      PISCorrectComponentChild({regularValue: 'Hello'});
    }
    .width('100%');
  }
}

@Component
struct PISCorrectComponentChild  {
  regularValue: string = 'Hello';
  build() {
    Column() {
      // $r('app.string.Hello')需要替换为开发者所需的资源文件
      Text($r('app.string.Hello'))
        .fontSize(50)
        .fontWeight(FontWeight.Bold);
    };
  }
}
// [End ProtectedInStruct_CorrectCase]
