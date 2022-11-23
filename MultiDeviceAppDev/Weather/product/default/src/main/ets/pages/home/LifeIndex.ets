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

import { getLifeData, MyDataSource, SuitData, Style } from '@ohos/common'

@Preview
@Component
export default struct LifeIndex {
  private lifeData: SuitData[] = getLifeData(0)
  private lifeDataResource: MyDataSource = new MyDataSource(this.lifeData)

  build() {
    Grid() {
      LazyForEach(this.lifeDataResource, item => {
        GridItem() {
          Column() {
            Image(item.src)
              .width(24)
              .height(24)
              .objectFit(ImageFit.Contain)
            Text(item.value)
              .fontSize(14)
              .fontColor(Color.White)
              .margin({ top: 8 })
            Text(item.desc)
              .fontSize(12)
              .fontColor('#99FFFFFF')
              .margin({ top: 2 })
          }
        }
      }, item => item.desc)
    }
    .height(Style.CARD_HEIGHT)
    .columnsTemplate('1fr 1fr 1fr 1fr')
    .rowsTemplate('1fr 1fr')
    .backgroundColor(Style.CARD_BACKGROUND_COLOR)
    .borderRadius(Style.NORMAL_RADIUS)
  }

  aboutToAppear() {
    this.lifeDataResource['dataArray'] = this.lifeData
  }
}