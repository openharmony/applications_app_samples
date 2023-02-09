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

import ParseData from '../common/ParseData'
import { QueryVolumeData } from '../common/QueryVolumeData'
import { TitleBar } from '../common/TitleBar'
import { VolumeData } from '../model/VolumeData'

function getString(resource: Resource): string {
  return getContext(this).resourceManager.getStringSync(resource.id)
}

function convertString(resource: Resource, molecule: number, denominator: number): string {
  let resultString = getString(resource)
  return `${resultString} ${ParseData.parseSizeToString(molecule)}/${ParseData.parseSizeToString(denominator)}`
}

@Extend(Column) function columnStyle () {
  .width('100%')
  .padding(12)
  .borderRadius(24)
  .backgroundColor(Color.White)
}

@Entry
@Component
struct VolumeList {
  @State isInit: boolean = false
  @State volumeSizeList: VolumeData[] = []
  private queryVolumeData: QueryVolumeData = new QueryVolumeData()

  aboutToAppear() {
    this.queryVolumeData.initVolumeData((hasInit: boolean) => {
      this.isInit = hasInit
      this.volumeSizeList = this.queryVolumeData.volumeSizeList
    })
  }

  build() {
    Column() {
      TitleBar({ title: $r('app.string.volume_list_available_information') })
      Scroll() {
        Column({ space: 12 }) {
          ForEach(this.volumeSizeList, (item: VolumeData, index: number) => {
            Column() {
              Text(`${getString($r('app.string.volume_list_volume')).toString()} ${item.description}`)
                .width('100%')
                .textAlign(TextAlign.Start)
              Stack({ alignContent: Alignment.Center }) {
                Progress({
                  value: ParseData.parseSize(item.totalSize - item.freeSize),
                  total: ParseData.parseSize(item.totalSize),
                  type: ProgressType.Ring
                })
                  .style({ strokeWidth: 20 })

                Text(ParseData.calculatePercentage((item.totalSize - item.freeSize), item.totalSize))
                  .fontSize(45)
              }
              .height(220)

              Text(convertString($r('app.string.storage_list_used'), (item.totalSize - item.freeSize), item.totalSize))
                .margin({ top: 12 })
                .fontWeight(FontWeight.Bold)
            }
            .margin({ bottom: index === this.volumeSizeList.length - 1 ? 60 : 0 })
            .columnStyle()
          })
        }
        .constraintSize({ minHeight: '100%' })
      }
      .padding(12)
    }
    .size({ width: '100%', height: '100%' })
    .backgroundColor($r('app.color.background'))
  }
}