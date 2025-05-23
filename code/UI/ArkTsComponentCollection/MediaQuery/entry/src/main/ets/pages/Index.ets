/*
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
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
import mediaQuery from '@ohos.mediaquery'
import { TitleBar } from '../common/TitleBar'
import { newsList, getNew } from '../model/New'
import { NewView } from '../common/NewView'
import Logger from '../model/Logger'
import { NewsType } from '../model/DataModel'

const TAG = 'MainIndex'
const INDEXPAGE_BGCOLOR = '#F5F5F5'

@Entry
@Component
struct Index {
  private listener = mediaQuery.matchMediaSync('screen and (min-aspect-ratio: 1.5) or (orientation: landscape)')
  @State currentNew: NewsType = getNew(0)
  @State isLand: boolean = false

  onLand(mediaQueryResult) {
    Logger.info(`${TAG} onLand: mediaQueryResult.matches=${mediaQueryResult.matches}`)
    if (mediaQueryResult.matches) {
      this.isLand = true
    } else {
      this.isLand = false
    }
  }

  aboutToAppear() {
    this.listener.on('change', this.onLand.bind(this))
  }

  build() {
    Row() {
      Column() {
        TitleBar()
        List() {
          ForEach(newsList, (item, index) => {
            ListItem() {
              Column() {
                Text(item.title)
                  .id(`item${index}`)
                  .width('100%')
                  .fontSize(22)
                Text(item.publisher)
                  .width('100%')
                  .fontSize(18)
                  .fontColor(Color.Gray)
              }
              .padding(10)
              .height('10%')
              .constraintSize({ minHeight: 80 })
              .backgroundColor(Color.White)
              .justifyContent(FlexAlign.Center)
            }
            .onClick(() => {
              if (!this.isLand) {
                router.push({
                  params: { title: item.title, newId: item.newId },
                  url: 'pages/New' })
              } else {
                this.currentNew = getNew(item.newId)
              }
            })
          }, item => JSON.stringify(item))
        }
        .width('100%')
        .height('100%')
        .layoutWeight(1)
        .divider({ strokeWidth: 1, startMargin: 15, endMargin: 15 })
        .padding({ left: 10, right: 10 })
      }
      .layoutWeight(2)
      .height('100%')
      .backgroundColor($r('app.color.indexPage_color'))

      if (this.isLand) {
        NewView({ currentNew: $currentNew })
      }
    }
    .size({ width: '100%', height: '100%' })
  }
}