/*
 * Copyright (c) 2021-2023 Huawei Device Co., Ltd.
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
import ReceivedData from '../model/ReceivedData'
import { ProcessData } from '../model/ProcessData'
import { Logger } from '../common/Logger'
import { MyDataSource } from '../model/OptionsData'
import { OPTIONS } from '../muck/MyData'
import { TitleBar } from '../common/TitleBar'
import { FlexList } from '../common/FlexList'

const REQUEST_CODE: number = 1
type SelectType = {
  subcategory: string,
  count: number
}

@Entry
@Component
struct Index {
  @State send: string = ''
  @State result: number = 0
  private Process: ProcessData = new ProcessData()
  private selectStuffs: Array<SelectType> = new Array(4).fill({ subcategory: '', count: 0 })

  selectStuff(index: number, good: string, count: number) {
    Logger.info(`index=  ${index}, count= ${count}, good= ${good}`)
    this.selectStuffs[index] = { subcategory: good, count: count }
  }

  async sortString(sendData: Array<string>) {
    Logger.info(`sortString is ${sendData}`)
    Logger.info(`sendData typeof ${typeof (sendData)}`)
    let option: rpc.MessageOption = new rpc.MessageOption()
    let data: rpc.MessageSequence = rpc.MessageSequence.create()
    let reply: rpc.MessageSequence = rpc.MessageSequence.create()
    Logger.info(`getCallingUid: ${ReceivedData.getCallingUid()}  getCallingPid: ${ReceivedData.getCallingPid()}`)
    data.writeStringArray(sendData)
    try {
      await ReceivedData.sendMessageRequest(REQUEST_CODE, data, reply, option)
    } catch (err) {
      Logger.error(`sortString failed, ${JSON.stringify(err)}`)
    }
    this.result = reply.readInt()
    reply.reclaim()
  }

  build() {
    Scroll() {
      Column() {
        TitleBar()
        LazyForEach(new MyDataSource(OPTIONS), (item, index) => {
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
              Logger.info(`priceArray= ${priceArray}`)
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