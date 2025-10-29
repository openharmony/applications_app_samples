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

// [Start PublicWithStorageProp_ErrorCase]
@Entry
@Component
struct PWPErrorAccessRestrictions  {
  @Provide consumeValue: string = 'Hello';
  build() {
    Column() {
      PWPErrorComponentChild();
    }
    .width('100%');
  }
}

@Component
struct PWPErrorComponentChild  {
  // 此处使用public修饰符时会出现告警日志
  @LocalStorageProp('sessionLocalProp') public localPropValue: string = 'Hello';
  // 此处使用public修饰符时会出现告警日志
  @LocalStorageLink('sessionLocalLink') public localLinkValue: string = 'Hello';
  // 此处使用public修饰符时会出现告警日志
  @StorageProp('sessionProp') public storagePropValue: string = 'Hello';
  // 此处使用public修饰符时会出现告警日志
  @StorageLink('sessionLink') public storageLinkValue: string = 'Hello';
  // 此处使用public修饰符时会出现告警日志
  @Consume public consumeValue: string;

  build() {
    Column() {
      Text('Hello')
        .fontSize(50)
        .fontWeight(FontWeight.Bold);
    };
  }
}
// [End PublicWithStorageProp_ErrorCase]
