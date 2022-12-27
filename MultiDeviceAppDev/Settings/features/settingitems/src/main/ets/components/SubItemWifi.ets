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
export struct SubItemWifi {
  private title: string | Resource
  private subTitle: string | Resource
  private isConnected: boolean
  private icon: Resource
  @State isTouched: boolean = false

  build() {
    Row() {
      Column() {
        Text(this.title)
          .fontSize($r('sys.float.ohos_id_text_size_body1'))
          .fontColor(this.isConnected ?
            $r('sys.color.ohos_id_color_text_primary_activated') : $r('sys.color.ohos_id_color_text_primary'))
          .fontWeight(FontWeight.Medium)
          .margin({bottom: 1})


        Text(this.subTitle)
          .fontSize($r('sys.float.ohos_id_text_size_body2'))
          .fontColor(this.isConnected ?
          $r('sys.color.ohos_id_color_text_primary') : $r('sys.color.ohos_id_color_text_secondary'))
          .fontWeight(FontWeight.Regular)
          .margin({top: 8})
      }
      .alignItems(HorizontalAlign.Start)

      Blank()

      Image(this.icon)
        .fillColor($r('sys.color.ohos_id_color_primary'))
        .width(24)
        .height(24)
    }
    .height(56)
    .width('100%')
    .borderRadius(24)
    .padding({left: 8, right: 8})
    .alignItems(VerticalAlign.Center)
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