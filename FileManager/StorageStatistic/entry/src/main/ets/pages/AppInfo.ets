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
 * WITHOUT WstorageDataListANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { AppData } from '../model/AppData'
import Logger from '../utils/Logger'
import ParseData from '../common/ParseData'
import { QueryStorageData } from '../common/QueryStorageData'
import { TitleBar } from '../common/TitleBar'

const TAG: string = 'AppInfo'

function convertString(resource: Resource, data: number): string {
  let resultString = getContext(this).resourceManager.getStringSync(resource.id)
  return `${resultString} ${ParseData.parseSizeToString(data)}    `
}

@Extend(Column) function columnStyle () {
  .width('100%')
  .borderRadius(24)
  .padding({ left: 12, right: 12, top: 6, bottom: 6 })
  .backgroundColor(Color.White)
}

@Entry
@Component
struct AppInfo {
  @State appPackageList: AppData[] = []
  @State isStorageDataInit: boolean = false
  private queryStorageData: QueryStorageData = new QueryStorageData()

  aboutToAppear() {
    this.queryStorageData.initData((hasInit: boolean) => {
      this.isStorageDataInit = hasInit
      this.appPackageList = this.queryStorageData.appDataList
    })
  }

  build() {
    Column() {
      TitleBar({ title: $r('app.string.app_info_app_storage_information') })

      if (this.isStorageDataInit) {
        Scroll() {
          Column() {
            ForEach(this.appPackageList, (item: AppData, index: number) => {
              Column() {
                Text(`${item.appName}`)
                  .fontSize(16)
                  .fontWeight(FontWeight.Bold)
                  .visibility(item.hasLabel ? Visibility.Visible : Visibility.None)
                Text(`${item.bundleName}`)
                  .fontSize(16)
                Text() {
                  Span(convertString($r('app.string.app_info_application'), item.bundleStats.appSize))
                    .fontSize(16)
                    .fontWeight(FontWeight.Bold)
                  Span(convertString($r('app.string.app_info_data'), item.bundleStats.dataSize))
                    .fontSize(16)
                    .fontWeight(FontWeight.Bold)
                  Span(convertString($r('app.string.app_info_cache'), item.bundleStats.cacheSize))
                    .fontSize(16)
                    .fontWeight(FontWeight.Bold)
                }
              }
              .height(75)
              .width('100%')
              .margin({ top: 6, bottom: 6 })
              .columnStyle()
              .margin({ bottom: index === this.appPackageList.length - 1 ? 60 : 0 })
              .alignItems(HorizontalAlign.Start)
              .justifyContent(FlexAlign.SpaceAround)
            })
          }
          .constraintSize({ minHeight: '100%' })
        }
        .width('100%')
        .padding(12)
        .backgroundColor($r('app.color.background'))
      } else {
        Row() {
          LoadingProgress()
            .size({ width: 30, height: 30 })
            .color(Color.Gray)
          Text($r('app.string.common_please_wait'))
            .fontColor(Color.Gray)
        }
        .height('100%')
        .justifyContent(FlexAlign.Center)
      }
    }
  }
}