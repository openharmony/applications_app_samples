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

import router from '@ohos.router'

interface BundleItem {
  img: Resource
  text: Resource
  name: string
}

class BasicDataSource<T> implements IDataSource {
  private listeners: DataChangeListener[] = []

  public totalCount(): number {
    return 0
  }

  public getData(index: number): T | undefined {
    return undefined
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

  notifyDataReload() {
    this.listeners.forEach(listener => {
      listener.onDataReloaded()
    })
  }

  notifyDataAdd(index: number) {
    this.listeners.forEach(listener => {
      listener.onDataAdd(index)
    })
  }

  notifyDataChange(index: number) {
    this.listeners.forEach(listener => {
      listener.onDataChange(index)
    })
  }

  notifyDataDelete(index: number) {
    this.listeners.forEach(listener => {
      listener.onDataDelete(index)
    })
  }

  notifyDataMove(from: number, to: number) {
    this.listeners.forEach(listener => {
      listener.onDataMove(from, to)
    })
  }
}

class MyDataSource extends BasicDataSource<BundleItem> {
  private dataArray: BundleItem[] = [
    { img: $r('app.media.music'), text: $r('app.string.music'), name: 'Music' },
    { img: $r('app.media.video'), text: $r('app.string.video'), name: 'Video' },
    { img: $r('app.media.map'), text: $r('app.string.map'), name: 'Map' }
  ]

  public totalCount(): number {
    return this.dataArray.length
  }

  public getData(index: number): BundleItem | undefined {
    return this.dataArray[index]
  }

  public replaceData(result: BundleItem[]) {
    this.dataArray = result
  }
}

@Component
export struct BundleInfo {
  @State dataSet: MyDataSource = new MyDataSource()
  @Prop isWideLayout: boolean
  @Prop isSidebar: boolean = false
  @Prop selectedBundleName: string = ''

  build() {
    Flex({ direction: FlexDirection.Row, wrap: FlexWrap.Wrap }) {
      LazyForEach(this.dataSet, (item: BundleItem) => {
        Row() {
          Image(item.img)
            .margin(10)
            .width('40%')
            .height('60%')
            .objectFit(ImageFit.Contain)

          Text(item.text)
            .margin(10)
            .fontSize(20)

          Image($r('app.media.right'))
            .margin(10)
            .width('15%')
            .height('20%')
            .layoutWeight(1)
            .objectFit(ImageFit.Contain)
        }
        .id(item.name + 'App')
        .margin(5)
        .width(this.isSidebar ? '95%' : (this.isWideLayout ? '48%' : '95%'))
        .height(this.isSidebar ? 90 : (this.isWideLayout ? 150 : '20%'))
        .borderRadius(20)
        .backgroundColor(this.isSidebar && this.selectedBundleName === item.name ? '#d7ebff' : '#f6f6f6')
        .onClick(() => {
          if (this.isSidebar) {
            AppStorage.SetOrCreate<string>('selectedBundleName', item.name)
            return
          }
          router.push({
            url: 'pages/Login',
            params: {
              bundleName: item.name
            }
          })
        })
      }, (item: BundleItem) => item.name)
    }
    .width('100%')
    .height('100%')
    .layoutWeight(1)
  }
}
