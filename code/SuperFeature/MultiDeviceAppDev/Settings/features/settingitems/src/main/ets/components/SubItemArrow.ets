/**
 * Copyright (c) 2021-2022 Huawei Device Co., Ltd.
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

@Component
export struct SubItemArrow {
  private title: string | Resource = ''
  private tag: string | Resource = ''
  @State isTouched: boolean = false

  build() {
    Row() {
      Text(this.title)
        .fontSize($r('sys.float.ohos_id_text_size_body1'))
        .fontColor($r('sys.color.ohos_id_color_text_primary'))
        .fontWeight(FontWeight.Medium)
        .textAlign(TextAlign.Start)

      Blank()

      Text(this.tag)
        .fontSize(14)
        .lineHeight(19)
        .align(Alignment.End)
        .fontWeight(FontWeight.Regular)
        .fontFamily('HarmonyHeiTi')
        .fontColor($r('sys.color.ohos_id_color_text_secondary'))

      Image($r('app.media.ic_settings_arrow'))
        .width(12)
        .height(24)
        .margin({left: 4})
        .fillColor($r("sys.color.ohos_id_color_fourth"))
    }
    .height(48)
    .width('100%')
    .padding({left: 8, right: 8})
    .borderRadius(24)
    .backgroundColor(this.isTouched ? $r('app.color.itemActivated') : $r('app.color.itemInactivated'))
    .onTouch((event: TouchEvent) => {
      if (event.type === TouchType.Down) {
        this.isTouched = true
      } else if (event.type === TouchType.Up) {
        this.isTouched = false
      }
    })
  }
}