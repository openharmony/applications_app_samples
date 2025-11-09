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
// [Start Persistent_page_first]
const MAX_NUM: number = 50;
// [End Persistent_page_first]
@Entry
@Component
struct TestPageThree {
  @State message: string = 'Hello World';
  @StorageLink('bProp') bProp: number = 46;

  // 组件初始化并即将显示时执行（仅触发一次）
  aboutToAppear() {
    // [Start Persistent_page_three]
    PersistentStorage.persistProp('aProp', 48);
    if ((AppStorage.get<number>('aProp') ?? 0) > MAX_NUM) {
      // 如果PersistentStorage存储的值超过50，设置为47
      AppStorage.setOrCreate('aProp',47);
    }
    // [End Persistent_page_three]
  }

  build() {
    Row() {
      Column() {
        Text(this.message)
        Text(`${this.bProp}`)
      }
    }
  }
}
