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

import router from '@ohos.router';
import { CoreDataModel } from '../../model/homeModel'
import { coreData } from '../../data/homeData'

class CoreNum2 implements IDataSource {
  totalCount(): number {
    return this.num
  }

  getData(index: number): any {
    return index
  }

  registerDataChangeListener(listener: DataChangeListener) {
    if (this.listeners.indexOf(listener) < 0) {
      this.listeners.push(listener)
    }
  }

  unregisterDataChangeListener(listener: DataChangeListener) {
    const pos = this.listeners.indexOf(listener)
    if (pos >= 0) {
      this.listeners.splice(pos, 1)
    }
  }

  num: number = 10
  listeners: DataChangeListener[] = []
}

@Component
export struct Core2 {
  coreNum: CoreNum2 = new CoreNum2()
  @State coreData: Array<CoreDataModel> = coreData
  @Prop ratio: number

  build() {
    Column() {
      List() {
        LazyForEach(this.coreNum, item1 => {
          ListItem() {
            Grid() {
              GridItem() {
                Column() {
                  Image(`${this.coreData[item1 * 2].uri}`)
                    .width(40 * this.ratio)
                    .aspectRatio(1)
                    .objectFit(ImageFit.Contain)
                  Text(`${this.coreData[item1 * 2 + 1].title}`)
                    .fontSize(15 * this.ratio)
                    .margin({ top: 5 })
                }
              }
              .width('100%')

              GridItem() {
                Column() {
                  Image(`${this.coreData[item1 * 2].uri}`)
                    .width(40 * this.ratio)
                    .aspectRatio(1)
                    .objectFit(ImageFit.Contain)
                  Text(`${this.coreData[item1 * 2 + 1].title}`)
                    .fontSize(15 * this.ratio)
                    .margin({ top: 5 })
                }
              }
              .width('100%')
            }
            .rowsTemplate('1fr 1fr')
            .columnsTemplate('1fr')
          }
          .width('22.5%')
        }, item => item.toString())
      }
      .listDirection(Axis.Horizontal)
      .height(160 * this.ratio)
      .width('100%')
    }
  }
}