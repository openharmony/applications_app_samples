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
// [Start Persistent_page_four]
// 定义常量替代魔法值，明确数值含义
const DEFAULT_NUMBER: number = 10; // 默认数字值
const FONT_SIZE_LARGE: number = 50; // 大字体尺寸

// 初始化持久化属性，键名使用常量定义（若有多处使用可提取）
const STORAGE_KEY_P: string = 'P';
PersistentStorage.persistProp(STORAGE_KEY_P, undefined);

@Entry
@Component
struct TestCase6 {
  // 使用常量作为默认值，类型明确
  @StorageLink(STORAGE_KEY_P) p: number | undefined | null = DEFAULT_NUMBER;

  build() {
    Row() {
      Column() {
        Text(this.p + '')
          .fontSize(FONT_SIZE_LARGE)
          .fontWeight(FontWeight.Bold)
        Button('changeToNumber').onClick(() => {
          this.p = DEFAULT_NUMBER;
        })
        Button('changeTo undefined').onClick(() => {
          this.p = undefined;
        })
        Button('changeTo null').onClick(() => {
          this.p = null;
        })
      }
      .width('100%')
    }
    .height('100%')
  }
}

// [End Persistent_page_four]