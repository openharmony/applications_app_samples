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

import router from '@ohos.router'
import ParseData from '../common/ParseData'
import { QueryStorageData } from '../common/QueryStorageData'
import { QueryVolumeData } from '../common/QueryVolumeData'
import { StorageData } from '../model/StorageData'

function convertString(resource: Resource, molecule: number, denominator: number): string {
  let resultString = getContext(this).resourceManager.getStringSync(resource.id)
  return `${resultString} ${ParseData.parseSizeToString(molecule)}/${ParseData.parseSizeToString(denominator)}`
}

@Extend(Column) function columnStyle () {
  .width('100%')
  .padding({ left: 12, right: 12, top: 6, bottom: 6 })
  .borderRadius(24)
  .backgroundColor(Color.White)
}

@Extend(Row) function rowStyle () {
  .width('100%')
  .height(50)
  .padding({ left: 12, right: 12 })
  .margin({ top: 12 })
  .borderRadius(24)
  .backgroundColor(Color.White)
}

@Component
export struct StorageList {
  @State totalSize: number = 0
  @State usedSize: number = 0
  @State isVolumeDataInit: boolean = false
  private itemSizeList: number[] = []
  private storageDataList: StorageData[] = []
  private queryData: QueryStorageData = undefined
  private queryVolumeData: QueryVolumeData = new QueryVolumeData()

  aboutToAppear() {
    this.storageDataList = this.queryData.classifiedDataList
    this.itemSizeList = this.queryData.itemSizeList
    this.totalSize = this.queryData.totalSize
    this.queryData.getUsedSize((usedSize: number) => {
      this.usedSize = usedSize
    })
    this.queryVolumeData.initVolumeData((hasInit: boolean) => {
      this.isVolumeDataInit = hasInit
    })
  }

  build() {
    Column() {
      Stack({ alignContent: Alignment.Center }) {
        DataPanel({
          values: this.itemSizeList,
          max: ParseData.parseSize(this.totalSize),
          type: DataPanelType.Circle
        })
        Text(ParseData.calculatePercentage(this.usedSize, this.totalSize))
          .fontSize(50)
        Text(convertString($r('app.string.storage_list_used'), this.usedSize, this.totalSize))
          .fontSize(18)
          .margin({ top: 80 })
      }
      .height(300)

      // If there are volumes available, the component is displayed
      Row() {
        Text($r('app.string.storage_list_available_information'))
        Blank()
        Image($r('app.media.ic_arrow_right'))
          .size({ width: 20, height: 20 })
      }
      .rowStyle()
      .visibility(this.isVolumeDataInit ? Visibility.Visible : Visibility.None)
      .onClick(() => {
        router.push({ url: 'pages/VolumeList' })
      })

      Text($r('app.string.storage_list_user_data'))
        .width('100%')
        .margin({ bottom: 12, top: 12 })
        .textAlign(TextAlign.Start)

      Column() {
        ForEach(this.storageDataList, (item: StorageData, index: number) => {
          Row() {
            this.colorPoint(item.color)
            Text(item.name)
            Blank()
            Text(ParseData.parseSizeToString(item.size))
            Image($r('app.media.ic_arrow_right'))
              .size({ width: 20, height: 20 })
              .visibility(index === 0 ? Visibility.Visible : Visibility.Hidden)
          }
          .width('100%')
          .height(30)
          .margin({ top: 6, bottom: 6 })
          .onClick(() => {
            if (index === 0) {
              router.push({ url: 'pages/AppInfo' })
            }
          })

          Divider()
            .color($r('app.color.gray_divider'))
            .visibility(index === this.storageDataList.length - 1 ? Visibility.None : Visibility.Visible)
        })
      }
      .alignItems(HorizontalAlign.Start)
      .columnStyle()
    }
  }

  @Builder colorPoint(color: ResourceColor) {
    Row()
      .size({ width: 10, height: 10 })
      .margin({ right: 12 })
      .borderRadius(5)
      .backgroundColor(color)
  }
}