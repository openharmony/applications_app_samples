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

import { WebData } from '../model/WebData'
import Logger from '../model/Logger'

class BasicDataSource implements IDataSource {
  private listeners: DataChangeListener[] = []

  public totalCount(): number {
    return 0
  }

  public getData(index: number): any {
    return undefined
  }

  registerDataChangeListener(listener: DataChangeListener): void {
    if (this.listeners.indexOf(listener) < 0) {
      this.listeners.push(listener)
    }
  }

  unregisterDataChangeListener(listener: DataChangeListener): void {
    const pos = this.listeners.indexOf(listener);
    if (pos >= 0) {
      this.listeners.splice(pos, 1)
    }
  }

  notifyDataReload(): void {
    this.listeners.forEach(listener => {
      listener.onDataReloaded()
    })
  }

  notifyDataAdd(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataAdded(index)
    })
  }

  notifyDataChange(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataChanged(index)
    })
  }
}

class MyDataSource extends BasicDataSource {
  public dataArray: string[] = []

  constructor(ele) {
    super()
    for (var index = 0;index < ele.length; index++) {
      this.dataArray.push(ele[index])
    }
  }

  public totalCount(): number {
    return this.dataArray.length
  }

  public getData(index: number): any {
    return this.dataArray[index]
  }

  public addData(index: number, data: string): void {
    this.dataArray.splice(index, 0)
    this.notifyDataAdd(index)
  }
}

const TAG: string = '[HomePage]'

@Component
export struct HomePage {
  @Link url: string
  @Link webState: boolean
  @Link backToHome: boolean
  @Link homeWebs: Array<WebData>

  build() {
    Row() {
      LazyForEach(new MyDataSource(this.homeWebs), (item, index) => {
        Column() {
          Image(this.homeWebs[index].img)
            .width(70)
            .height(70)
            .objectFit(ImageFit.ScaleDown)
            .key('homeWeb' + index)
            .onClick(() => {
              this.url = item.url
              this.webState = true
              this.backToHome = false
              Logger.info(TAG, `this.url=${this.url}`)
            })
          Text(item.title)
            .fontSize(15)
            .fontWeight(FontWeight.Bold)
        }
        .layoutWeight(1)
      }, item => JSON.stringify(item))
    }
    .width('100%')
    .margin({ top: 100 })
  }
}