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
// [Start ArkUI_Star_binding2]
@Entry
@ComponentV2
struct Index {
  @Local value: number = 0;

  build() {
    Column() {
      Text(`${this.value}`)
      Button(`change value`).onClick(() => {
        this.value++;
      })
      Star({ value: this.value!! })
      // [StartExclude ArkUI_Star_binding2]
        .id('aaa')
      // [Start ArkUI_Star_binding1]
      Star({ value: this.value, $value: (val: number) => { this.value = val; }})
      // [End ArkUI_Star_binding1]
      // [EndExclude ArkUI_Star_binding2]
    }
  }
}

@ComponentV2
struct Star {
  @Param value: number = 0;
  @Event $value: (val: number) => void = (val: number) => {};

  build() {
    Column() {
      Text(`${this.value}`)
      Button(`change value`).onClick(() => {
        this.$value(10);
      })
    }
  }
}
// [End ArkUI_Star_binding2]