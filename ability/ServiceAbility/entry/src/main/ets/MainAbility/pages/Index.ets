/*
 * Copyright (c) 2021 Huawei Device Co., Ltd.
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
import rpc from "@ohos.rpc"
import { TitleBar } from '../component/TitleBar'
import { OperateView } from '../component/OperateView'
import { ServiceModel } from '../model/ServiceModel'
import { Logger } from '../component/Logger'

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

  public addData(index: number, data: Resource): void {
    this.dataArray.splice(index, 0)
    this.notifyDataAdd(index)
  }
}

let TAG: string = '[ServiceAbility.index]'

@Entry
@Component
struct Index {
  private btnResources: MyDataSource = new MyDataSource([$r('app.string.connect_service'), $r('app.string.disconnect_service'), $r('app.string.sort_string')])
  private serviceModel = new ServiceModel()
  @State beforeSortString: string = ''
  @State afterSortString: string = ''

  async sortString() {
    console.log(`${TAG} sortString begin`)
    let mRemote = this.serviceModel.getRemoteObject()
    if (mRemote === null) {
      prompt.showToast({
        message: 'please connect service'
      })
      return
    }
    if (this.beforeSortString.length === 0) {
      prompt.showToast({
        message: 'please input a string'
      })
      return
    }
    let option: rpc.MessageOption = new rpc.MessageOption()
    let data: rpc.MessageParcel = rpc.MessageParcel.create()
    let reply: rpc.MessageParcel = rpc.MessageParcel.create()
    data.writeString(this.beforeSortString)
    try {
      await mRemote.sendRequest(1, data, reply, option)
    } catch (err) {
      Logger.error(`sendRequest failed, code is ${err.code}, message is ${err.message}`)
    }
    let msg = reply.readString()
    this.afterSortString = msg
  }

  build() {
    Column() {
      TitleBar()
      Scroll() {
        Column() {
          OperateView({ before: $beforeSortString, after: $afterSortString })
          LazyForEach(this.btnResources, (item, index) => {
            Button() {
              Text(item)
                .fontColor(Color.White)
                .fontSize(20)
            }
            .type(ButtonType.Capsule)
            .backgroundColor('#0D9FFB')
            .width('94%')
            .height(50)
            .margin(10)
            .onClick(() => {
              console.info(`${TAG} button clicked,index=${index}`)
              switch (index) {
                case 0:
                  this.serviceModel.connectService()
                  break
                case 1:
                  this.serviceModel.disconnectService()
                  break
                case 2:
                  this.sortString()
                  break
                default:
                  break
              }
            })
          }, item => JSON.stringify(item))
        }
      }
      .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
  }
}