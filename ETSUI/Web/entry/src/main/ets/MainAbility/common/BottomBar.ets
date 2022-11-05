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
    if (this.listeners) {
      if (this.listeners.indexOf(listener) < 0) {
        this.listeners.push(listener)
      }
    }
  }

  unregisterDataChangeListener(listener: DataChangeListener): void {
    if (this.listeners) {
      const pos = this.listeners.indexOf(listener)
      if (pos >= 0) {
        this.listeners.splice(pos, 1)
      }
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
export struct BottomBar {
  private controller: WebController = null
  @Link webTitle: string
  @Link isWebError: boolean
  @Link webState: boolean
  @Link url: string
  @Link isHttpError: boolean
  @Link backToHome: boolean
  private options: Array<{
    image: Resource,
    onClick: () => void
  }> = [
    {
      image: $r("app.media.back"),
      onClick: () => {
        this.controller.backward()
        this.isWebError = false
        this.isHttpError = false
      }
    },
    {
      image: $r("app.media.main"),
      onClick: () => {
        this.url = ''
        this.webTitle = '主页'
        this.backToHome = true
        this.webState = false
        this.isWebError = false
        this.isHttpError = false
      }
    },
    {
      image: $r("app.media.forward"),
      onClick: () => {
        this.controller.forward()
        this.isWebError = false
        this.isHttpError = false
      }
    }
  ]

  build() {
    Row() {
      LazyForEach(new MyDataSource(this.options), (item, index) => {
        Row() {
          Image(item.image)
            .width(40)
            .height(40)
            .objectFit(ImageFit.Contain)
            .key('option' + index)
            .onClick(item.onClick)
        }
      }, item => item)
    }
    .alignItems(VerticalAlign.Center)
    .justifyContent(FlexAlign.SpaceAround)
    .width('100%')
    .height(50)
  }
}