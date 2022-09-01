/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
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

import { AppItem, MyAppSource } from '../model/HomeDataType'

@Component
export default struct IndexApps {
  private title: Resource
  @StorageProp('currentBreakpoint') currentBreakpoint: string = 'md'
  private apps: AppItem[] = []

  @Builder
  appListHeader() {
    Row() {
      Text(this.title)
        .width(100)
        .fontSize(16)
        .textAlign(TextAlign.Start)
        .fontWeight(500)
      Blank()
      Text($r('app.string.more'))
        .fontSize(14)
        .textAlign(TextAlign.End)
        .fontWeight(400)
        .margin({ right: 2 })
      Image($r('app.media.ic_public_arrow_right'))
        .width(12)
        .height(18)
        .opacity(0.9)
        .objectFit(ImageFit.Fill)
    }
    .margin({ bottom: 9, top: 9 })
    .width('100%')
    .alignItems(VerticalAlign.Bottom)
  }

  @Builder
  appListItem(app:AppItem) {
    Column() {
      Image(app.image)
        .width(this.currentBreakpoint === 'lg' ? 80 : 56)
        .height(this.currentBreakpoint === 'lg' ? 80 : 56)
        .margin({ bottom: 8 })
      Text(app.title)
        .width(this.currentBreakpoint === 'lg' ? 80 : 56)
        .height(16)
        .fontSize(12)
        .textAlign(TextAlign.Center)
        .fontColor('#18181A')
        .margin({ bottom: 8 })
      Button($r('app.string.install'))
        .width(this.currentBreakpoint === 'lg' ? 80 : 56)
        .height(28)
        .fontColor('#0A59F7')
        .fontWeight(500)
        .fontSize(12)
        .padding({ top: 6, bottom: 6, left: 8, right: 8 })
        .backgroundColor('rgba(0,0,0,0.05)')
    }
  }


  build() {
    Column() {
      this.appListHeader()
      List({ space: this.currentBreakpoint === 'lg' ? 44 : 20}) {
        LazyForEach(new MyAppSource(this.apps), app => {
          ListItem() {
            this.appListItem(app)
          }
        }, app => app.id)
      }
      .width('100%')
      .height(this.currentBreakpoint === 'lg' ? 140 : 120)
      .listDirection(Axis.Horizontal)
    }
    .width('100%')
    .height(this.currentBreakpoint === 'lg' ? 188 : 164)
    .padding({ bottom: 8, left: 12, right: 12 })
  }
}


