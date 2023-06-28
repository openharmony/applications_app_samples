/*
* Copyright (c) 2023 Hunan OpenValley Digital Industry Development Co., Ltd.
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

import router from '@ohos.router'

export interface Action {
  id: string
  name: ResourceStr
  event: (event?: ClickEvent) => void
}

@Component
export default struct NavigationBar {
  private title?: ResourceStr
  private showIndicator?: boolean = true
  private darkMode?: boolean = false
  private actions?: Array<Action>

  build() {
    Row() {
      if (this.showIndicator) {
        Row() {
          Image($r('app.media.ic_public_back'))
            .objectFit(ImageFit.Contain)
            .width(28)
            .aspectRatio(1)
        }
        .id('iv_back')
        .height('100%')
        .aspectRatio(1)
        .justifyContent(FlexAlign.Center)
        .onClick(() => router.back())
      }

      Text(this.title ?? '')
        .fontColor(this.darkMode ? '#ffffff' : '#E6000000')
        .fontSize($r('app.float.text_size_title'))
        .margin({ left: this.showIndicator ? 0 : 24 })

      Blank()
        .layoutWeight(1)

      ForEach(this.actions, (item: Action) => {
        Button(item.name)
          .id(item.id)
          .backgroundColor($r('app.color.bg_transparent'))
          .fontSize(16)
          .fontColor('#FF0A59F7')
          .margin({ right: 24 })
          .onClick(item.event)
      })
    }
    .width('100%')
    .height('100%')
    .backgroundColor(this.darkMode ? $r('app.color.bg_transparent') : $r('app.color.bg_transparent'))
  }
}