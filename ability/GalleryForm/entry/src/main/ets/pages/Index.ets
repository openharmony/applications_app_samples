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

import ImageData from '../data/ImageData'
import mediaLibrary from '@ohos.multimedia.mediaLibrary'
import Logger from '../data/Logger'
import TitleBar from '../component/TitleBar'
import GalleryFormConst from '../data/GalleryFormConst'

const TAG: string = 'Index'

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

  public addData(index: number, data: mediaLibrary.FileAsset): void {
    this.dataArray.splice(index, 0)
    this.notifyDataAdd(index)
  }
}

@Entry
@Component
struct Index {
  @State imageDatas: MyDataSource = new MyDataSource([])

  async aboutToAppear() {
    let context = getContext(this) as any
    await context.requestPermissionsFromUser(GalleryFormConst.PERMISSIONS)
    let imageDatas = await ImageData.getAllImage(context)
    this.imageDatas = new MyDataSource(imageDatas)
    Logger.info(TAG, `this image number = ${this.imageDatas.totalCount} uri = ${this.imageDatas[0].uri}`)

  }

  build() {
    Row() {
      Column() {
        TitleBar()
        Grid() {
          if (this.imageDatas != new MyDataSource([])) {
            LazyForEach(this.imageDatas, item => {
              GridItem() {
                Image(item.uri)
                  .width('100%')
                  .aspectRatio(1)
                  .objectFit(ImageFit.Cover)
              }
            }, item => item.uri)
          }
        }
        .width('95%')
        .height('95%')
        .maxCount(2)
        .rowsGap('2%')
        .columnsGap('2%')
        .columnsTemplate('1fr 1fr')
        .margin({ top: 10, bottom: 6, left: 6, right: 6 })
      }
      .width('100%')
    }
    .height('100%')
  }
}