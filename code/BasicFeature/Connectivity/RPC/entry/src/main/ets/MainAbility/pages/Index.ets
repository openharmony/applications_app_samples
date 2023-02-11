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

import rpc from '@ohos.rpc'
import { TitleBar } from '../common/TitleBar'
import { FlexList } from '../common/FlexList'
import ReceivedData from '../model/ReceivedData'
import { ProcessData } from '../model/ProcessData'
import { Logger } from '../common/Logger'

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

let TAG: string = '[eTSRPC.Index]'
const REQUEST_CODE: number = 1

@Entry
@Component
struct Index {
  @State send: string = ''
  @State result: number = 0
  private Process: ProcessData = new ProcessData()
  private options: Array<any> = [
    {
      category: 'Veggie',
      subcategory: ['potato', 'cabbage', 'eggplant']
    },
    {
      category: 'Fruit',
      subcategory: ['apple', 'banana', 'peach']
    },
    {
      category: 'Meat',
      subcategory: ['beef', 'pork', 'chicken']
    },
    {
      category: 'Snacks',
      subcategory: ['biscuits', 'chips', 'candy']
    }
  ]
  private selectStuffs: Array<any> = new Array(4).fill({ subcategory: '', count: 0 })

  selectStuff(index: number, good: string, count: number) {
    console.info(`${TAG} index=  ${index}, count= ${count}, good= ${good}`)
    this.selectStuffs[index] = { subcategory: good, count: count }
  }

  async sortString(sendData: Array<string>) {
    console.log(`${TAG} sortString is ${sendData}`)
    console.log(`${TAG} sendData typeof ${typeof (sendData)}`)
    let option: rpc.MessageOption = new rpc.MessageOption()
    let data: rpc.MessageParcel = rpc.MessageParcel.create()
    let reply: rpc.MessageParcel = rpc.MessageParcel.create()
    console.log(`${TAG} getCallingUid: ${ReceivedData.getCallingUid()}  getCallingPid: ${ReceivedData.getCallingPid()}`)
    try {
      data.writeStringArray(sendData)
      await ReceivedData.sendRequest(REQUEST_CODE, data, reply, option)
      this.result = reply.readInt()
      reply.reclaim()
    } catch (err) {
      Logger.error(`sortString failed, code is ${err.code}, message is ${err.message}`)
    }
  }

  build() {
    Scroll() {
      Column() {
        TitleBar()
        LazyForEach(new MyDataSource(this.options), (item, index) => {
          Row() {
            FlexList({
              category: item.category,
              menu: item.subcategory,
              index: index,
              selectStuff: this.selectStuff.bind(this)
            })
          }
        }, item => JSON.stringify(item))

        Column() {
          Row() {
            Text($r('app.string.final_price'))
              .width('65%')
              .height(25)
              .fontSize(18)
              .textAlign(TextAlign.Center)
            Text(this.result.toString())
              .height(25)
              .fontSize(20)
              .margin({ left: '5%' })
              .textAlign(TextAlign.Center)
          }
          .justifyContent(FlexAlign.Center)
          .width('80%')

          Button($r('app.string.confirm'))
            .key('confirmOrderBtn')
            .width('80%')
            .height(40)
            .margin({ top: 30 })
            .onClick(() => {
              let priceArray = this.Process.getPrice(this.selectStuffs)
              console.info(`${TAG} priceArray= ${priceArray}`)
              this.sortString(priceArray)
            })
        }
        .width('100%')
        .justifyContent(FlexAlign.Center)
        .margin({ top: 20 })
        .height('30%')
      }
      .width('100%')
    }
  }
}