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

// [Start hsp_resource]
@Entry
@Component
struct Second {
  // [library]仅为示例模块名，请替换为实际模块名
  // 资源名仅作示例，请替换为实际使用的资源
  text: string = '[library].string.test_string';
  fontSize: string = '[library].float.font_size';
  fontColor: string = '[library].color.font_color';
  image: string = '[library].media.image';
  rawfile: string = '[library].icon.png';

  build() {
    Column() {
      // 使用字面量[模块名].type.name获取资源
      Text($r('[library].string.test_string'))
        .id('hsp_resource_one')
        .fontSize($r('[library].float.font_size'))
        .fontColor($r('[library].color.font_color'))
      Image($rawfile('[library].icon.png'))
        .height(100)
        .width(100)

      // 使用变量获取资源
      Text($r(this.text))
        .id('hsp_resource_two')
        .fontSize($r(this.fontSize))
        .fontColor($r(this.fontColor))

      Image($r(this.image))
        .height(100)
        .width(100)

      Image($rawfile(this.rawfile))
        .height(100)
        .width(100)
    }
    .height('100%')
    .width('100%')
  }
}
// [End hsp_resource]