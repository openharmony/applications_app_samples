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

@Component
export struct BrowseHistory {
  @Link url: string
  @Link browses: string[]
  @Link webState: boolean
  @Link isLoading: boolean
  @Link isWebError: boolean
  @Link backToHome: boolean
  @Link isHttpError: boolean

  build() {
    Column() {
      Text($r('app.string.browse_history'))
        .width('90%')
        .fontSize(20)
        .margin({ top: 10 })
        .textAlign(TextAlign.Start)
      LazyForEach(new MyDataSource(this.browses), item => {
        Row() {
          Image($r('app.media.circle'))
            .width('15%')
            .height(30)
            .objectFit(ImageFit.ScaleDown)
          Text(item)
            .height(50)
            .fontSize(15)
            .layoutWeight(1)
            .fontWeight(FontWeight.Regular)
        }
        .onClick(() => {
          this.url = item
          this.webState = true
          this.isLoading = true
          this.backToHome = false
          this.isWebError = false
          this.isHttpError = false
        })
      }, item => item)
    }
  }
}