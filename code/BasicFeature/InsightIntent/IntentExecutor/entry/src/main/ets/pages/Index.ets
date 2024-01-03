/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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
@Component
struct Index {

  build() {
    Column() {
      Text($r('app.string.intent_executor_title'))
        .fontColor('#182431')
        .fontSize(32)
        .fontWeight(700)
        .margin({ left: 72, top: 32 })
        .textAlign(TextAlign.Start)
        .width('100%')
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('sys.color.ohos_id_color_text_field_sub_bg'))
  }
}