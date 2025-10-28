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

// [Start ProtectedInStruct_ErrorCase]
@Entry
@Component
struct PISErrorAccessRestrictions  {
  build() {
    Column() {
      PISErrorComponentChild({regularValue: 'Hello'});
    }
    .width('100%');
  }
}

@Component
struct PISErrorComponentChild  {
  // 此处使用protected修饰符时会出现告警日志
  protected regularValue: string = 'Hello';
  build() {
    Column() {
      Text('Hello')
        .fontSize(50)
        .fontWeight(FontWeight.Bold);
    };
  }
}
// [End ProtectedInStruct_ErrorCase]
