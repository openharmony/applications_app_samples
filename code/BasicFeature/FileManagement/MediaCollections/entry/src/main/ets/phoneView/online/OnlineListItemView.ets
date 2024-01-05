/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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
import { samplesData, JsonItem } from '../../model/JsonListData'
import Logger from '../../model/Logger'

const TAG: string = "OnlinePlayListItem"

@Component
export default struct OnlineListItemView {
  @State isExpanded: boolean = false
  @State isOpenOfflineLicenseArr: boolean[] = []
  @Link @Watch('onClickIndexExpand') clickIndex: number
  private firstItem: JsonItem = {} as JsonItem
  private index: number = 0

  aboutToAppear() {
    this.firstItem.samples.forEach(() => {
      this.isOpenOfflineLicenseArr.push(false)
    })
  }

  /**
   * 展开其他一级标题时收起已展开
   */
  onClickIndexExpand() {
    if (this.clickIndex !== this.index) {
      this.isExpanded = false
    }
  }

  modifyTextFormat(text: string) {
    let newArr: string[] = []
    let oldArr = text.split('')
    oldArr.forEach((item: string) => {
      if (item === '-' || item === '_') {
        newArr.push(' ')
      } else {
        newArr.push(item)
      }
    })
    return newArr.join('')
  }

  @Builder
  firstLevelBar() {
    Row({ space: 10 }) {
      Image(this.isExpanded ? $r('app.media.upward') : $r('app.media.downward')).height(20)
      Text(this.firstItem.name)
        .width('90%')
        .fontColor(0xE6E6E6)
        .fontSize(22)
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
    }
    .id(`firstLevelBar${this.index}`)
    .width('90%')
    .height(60)
    .onClick(() => {
      this.clickIndex = this.index
      this.isExpanded = !this.isExpanded
    })
  }

  @Builder
  secondLevelBar() {
    List() {
      ForEach(this.firstItem.samples, (secondItem: samplesData, index: number) => {
        ListItem() {
          Column() {
            Row() {
              Text() {
                Span(`${index + 1}. `)
                Span(this.modifyTextFormat(secondItem.name))
              }
              .width('75%')
              .fontColor(0xE6E6E6)
              .fontSize(18)
              .maxLines(2)
              .textOverflow({ overflow: TextOverflow.Ellipsis })

              Row({ space: 10 }) {
                Image($r('app.media.download')).height(25)
                Image(this.isOpenOfflineLicenseArr[index] ? $r('app.media.key_blue') : $r('app.media.key'))
                  .height(25)
                  .onClick(() => {
                    if (this.isOpenOfflineLicenseArr[index]) {
                      this.isOpenOfflineLicenseArr[index] = false
                    } else {
                      this.isOpenOfflineLicenseArr[index] = true
                    }
                  })
              }
            }
            .id(`secondLevelBar${index}`)
            .width('90%')
            .height(50)
            .justifyContent(FlexAlign.SpaceBetween)
            .onClick(() => {
              router.pushUrl({
                url: 'pages/online/OnlinePlayer',
                params: {
                  videoParams: secondItem
                }
              }, router.RouterMode.Standard, (err) => {
                if (err) {
                  Logger.error(TAG, `Invoke pushUrl failed, code is ${err.code}, message is ${err.message}`)
                  return
                }
              })
              if (this.isOpenOfflineLicenseArr[index]) {
                AppStorage.setOrCreate('licenseType', 1);
              } else {
                AppStorage.setOrCreate('licenseType', 0);
              }
            })
          }.width('100%')
        }
      }, (item: samplesData) => JSON.stringify(item))
    }
    .divider({
      strokeWidth: 1,
      color: Color.Gray,
    })
  }

  build() {
    Column() {
      // 一级列表
      this.firstLevelBar()

      if (this.isExpanded) {
        Divider()
          .strokeWidth(1)
          .color(Color.Gray)

        // 二级列表
        this.secondLevelBar()
      }
    }.width('100%')
  }
}