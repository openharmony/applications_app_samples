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
// [Start Persistent_page_three]
const MAX_NUM: number = 50; // 大字体尺寸

@Entry
@Component
struct testPageThree {
  @State message: string = 'Hello World';
  @StorageLink('aProp') aProp: number = 46;

  build() {
    Row() {
      Column() {
        Text(this.message)
        // 应用退出时会保存当前结果。重新启动后，会显示上一次的保存结果
        // 未修改时默认值为47
        Text(`${this.aProp}`)
          .onClick(() => {
            this.aProp += 1;
            const currentAProp = AppStorage.get<number>('aProp') ?? 0;
            PersistentStorage.persistProp('aProp', currentAProp);
            if (currentAProp > MAX_NUM) {
              // 如果PersistentStorage存储的值超过50，设置为47
              AppStorage.setOrCreate('aProp', 47);
            }
          })
      }
    }
  }
}
// [End Persistent_page_three]