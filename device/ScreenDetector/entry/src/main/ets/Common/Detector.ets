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

import display from '@ohos.display'
import router from '@ohos.router';
import Logger from '../Common/Logger'
import { Warn } from '../Common/Warn'

const TAG: string = '[ScreenDetector]'
const VIRTUAL_SCREEN_MAX: number = 5
const VIRTUAL_SCREEN_MIN: number = 0

var deviceScreens = new Object

@Component
export struct Detector {
  @State allScreens: display.Display[] = []
  private screenIds: number[] = []
  private errorMsg: Resource = undefined
  private limit: string = ""
  private virtualScrNum: number = 0
  private realScrNum: number = 0
  errorDialog: CustomDialogController = new CustomDialogController({
    builder: Warn({
      errMsg: this.errorMsg,
      limit: this.limit
    }),
    autoCancel: true,
    alignment: DialogAlignment.Default
  })
  async refreshScreen() {
    await this.getAllScreens()
    Logger.info(TAG, 'Screen refresh. The Screen number is ' + this.allScreens.length)
  }
  registerListener() {
    display.on('add', (id) => {
      this.refreshScreen()
    })
    display.on('remove', (id) => {
      this.refreshScreen()
    })
  }
  async getAllScreens() {
    this.allScreens = await display.getAllDisplay()
    this.realScrNum = this.allScreens.length
    let defaultScreen = await display.getDefaultDisplay()
    for (let i = 0; i < this.virtualScrNum; i++) {
      this.allScreens.push(defaultScreen);
    }
    Logger.info(TAG, `All Screens = ${JSON.stringify(this.allScreens)}`)
  }
  aboutToAppear() {
    this.registerListener()
    this.getAllScreens()
    this.virtualScrNum = 0
  }
  build() {
    Column() {
        Flex({ wrap: FlexWrap.Wrap }) {
          ForEach(this.allScreens, (item, index) => {
            Row() {
              if (index < this.realScrNum) {
                Text('R' + JSON.stringify(index))
              } else {
                Text('V' + JSON.stringify(index - this.realScrNum))
              }
            }
            .margin({ right: '10%', bottom: '5%' })
            .justifyContent(FlexAlign.Center)
            .backgroundColor('#5dbbff')
            .height('12%').width('18%')
            .onClick(async () => {
              router.push({
                url: 'pages/ScreenInfo',
                params: {
                  scrInfo: item
                }
              });
            })
          })
        }.height('50%').width('100%').padding(10)

        Flex({ alignItems: ItemAlign.End, justifyContent: FlexAlign.End }) {
          Button($r('app.string.add_screen'))
            .fontSize(18)
            .margin({ top: 10, left: 4, right: 4, bottom: 4 })
            .onClick(async () => {
              if (this.virtualScrNum < VIRTUAL_SCREEN_MAX) {
                let defaultScreen = await display.getDefaultDisplay()
                this.allScreens.push(defaultScreen)
                this.virtualScrNum = this.virtualScrNum + 1
                Logger.info(TAG, `add a virtual screen success!`)
              } else {
                this.errorMsg = $r('app.string.err_max_screen')
                this.limit = JSON.stringify(VIRTUAL_SCREEN_MAX)
                this.errorDialog.open()
              }
            })

          Button($r('app.string.remove_screen'))
            .fontSize(18)
            .margin({ top: 10, left: 4, right: 4, bottom: 4 })
            .onClick(async () => {
              if (this.virtualScrNum > VIRTUAL_SCREEN_MIN) {
                this.allScreens.pop();
                this.virtualScrNum = this.virtualScrNum - 1
                Logger.info(TAG, `remove a virtual screen success!`)
              } else {
                this.errorMsg = $r('app.string.err_min_screen')
                this.limit = JSON.stringify(VIRTUAL_SCREEN_MIN)
                this.errorDialog.open()
              }
            })
        }.height('50%')
    }.height('90%')
  }
}