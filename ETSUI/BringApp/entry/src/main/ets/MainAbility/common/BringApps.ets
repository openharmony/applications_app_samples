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

import prompt from '@ohos.prompt'
import { Apps } from '../model/Apps'
import Logger from '../model/Logger'
import featureAbility from '@ohos.ability.featureAbility'

const TAG = '[BringApps]'

class BasicDataSource implements IDataSource {
  private listeners: DataChangeListener[] = []

  public totalCount() {
    return 0
  }

  public getData(index: number) {
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

class MyDataSource extends BasicDataSource {
  private dataArray: any[] = Apps

  public totalCount() {
    return this.dataArray.length
  }

  public getData(index: number) {
    return this.dataArray[index]
  }

  public addData(index: number) {
    this.dataArray.splice(index, 0)
    this.notifyDataAdd(index)
  }

  public pushData(index: number) {
    this.dataArray.push()
    this.notifyDataAdd(this.dataArray.length - 1)
  }

  public deleteData() {
    this.dataArray.pop()
    this.notifyDataAdd(this.dataArray.length - 1)
  }
}

@Component
export struct BringApp {
  @State text: string = ''
  @State app: MyDataSource = new MyDataSource()

  build() {
    Scroll() {
      Column() {
        LazyForEach(this.app, (item, index) => {
          Row() {
            Image(item.img)
              .margin(5)
              .width('20%')
              .height('60%')
              .objectFit(ImageFit.Contain)

            Text(item.name)
              .margin(5)
              .fontSize(20)
              .textAlign(TextAlign.Start)

            Blank()
              .width('10%')

            Image($r('app.media.right'))
              .margin(10)
              .width('15%')
              .height('20%')
              .objectFit(ImageFit.Contain)
          }
          .margin(5)
          .width('95%')
          .height('12%')
          .borderRadius(20)
          .backgroundColor('#f6f6f6')
          .key('app' + (index + 1))
          .onClick(() => {
            try {
              featureAbility.startAbility(
                {
                  want:
                  {
                    bundleName: item.bundleName,
                    abilityName: item.abilityName,
                  },
                }
              ).then((data) => {
                this.text = 'Success!'
                Logger.info(TAG, `End ability data is ${data}} `)
              })
            } catch (err) {
              this.text = 'Error!'
              Logger.info(TAG, `err is ${err}`)
            }
            prompt.showToast({
              message: this.text,
              duration: 1500
            })
          })
        }, item => item.toString())
      }
    }
    .width('100%')
    .height('100%')
    .layoutWeight(1)
  }
}