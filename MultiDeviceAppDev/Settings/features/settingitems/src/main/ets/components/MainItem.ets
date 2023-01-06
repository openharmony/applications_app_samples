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
export struct MainItem {
  private title: string | Resource
  private tag: string | Resource
  private icon: string | Resource
  private label: string = ''
  @LocalStorageLink('selectedLabel') selectedLabel: string = ''
  @LocalStorageProp('isSplitMode') isSplitMode: boolean = false
  @State isTouched: boolean = false

  isActivated(): boolean {
    if (this.isSplitMode) {
      return this.label !== '' && this.label === this.selectedLabel
    }
    return this.isTouched
  }
  
  build() {
    Row() {
      Image(this.icon)
        .width(24)
        .height(24)

      Text(this.title)
        .fontSize(16)
        .lineHeight(22)
        .fontWeight(FontWeight.Medium)
        .fontFamily('HarmonyHeiTi')
        .fontColor($r('sys.color.ohos_id_color_text_primary'))
        .align(Alignment.Start)
        .margin({ left: 16 })

      Blank()

      Text(this.tag)
        .fontSize(14)
        .lineHeight(19)
        .fontWeight(FontWeight.Regular)
        .fontFamily('HarmonyHeiTi')
        .fontColor($r('sys.color.ohos_id_color_text_primary'))

      Image($r('app.media.ic_settings_arrow'))
        .width(12)
        .height(24)
        .margin({left: 4})
        .fillColor($r('sys.color.ohos_id_color_fourth'))
    }
    .alignItems(VerticalAlign.Center)
    .width('100%')
    .height(56)
    .borderRadius(20)
    .padding({left: 8, right: 8})
    .backgroundColor(this.isActivated() ? $r('app.color.itemActivated') : $r('app.color.itemInactivated'))
    .onTouch((event: TouchEvent) => {
      if (event.type === TouchType.Down) {
        this.isTouched = true
      } else if (event.type === TouchType.Up) {
        this.isTouched = false
      }
    })
  }
}