/*
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
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
import Logger from '../model/Logger'
import { ShowInfo } from '../common/ShowInfo'
import { DisplayModel } from '../model/DisplayModel'
const TAG: string = '[DisplayDevice]'

@Component
export struct DisplayDevice {
  @State devices: number[] = []
  private screenIds: number[] = []
  private allScreens: display.Display[] = []
  private defaultScreens: display.Display | undefined = undefined
  private defaultOrAllScreen: boolean = false
  private displayModel: DisplayModel = new DisplayModel()
  dialogController: CustomDialogController = new CustomDialogController({
    builder: ShowInfo({
      defaultScreens: this.defaultScreens,
      allScreens: this.allScreens,
      defaultOrAllScreen: this.defaultOrAllScreen
    }),
    autoCancel: true,
    alignment: DialogAlignment.Default
  })

  addWatch() {
    display.on('add', (data) => {
      if (this.devices.length < 1) {
        this.devices.push(this.screenIds[this.screenIds.length - 1])
        Logger.info(TAG, `this push devices = ${JSON.stringify(this.devices)} this id = ${data}`)
      } else {
        Logger.info(TAG, `this screen's number is exceed three`)
      }
    })
  }

  removeWatch() {
    display.on('remove', (result) => {
      this.devices.pop()
      this.screenIds.pop()
      Logger.info(TAG, `this pop devices = ${JSON.stringify(this.devices)} this screenIds = ${JSON.stringify(this.screenIds)} result = ${result}`)
    })
  }

  aboutToAppear() {
    this.addWatch()
    this.removeWatch()
  }

  async getDefaultScreen() {
    this.defaultOrAllScreen = true
    this.defaultScreens = await display.getDefaultDisplay()
    Logger.info(TAG, `This getDefaultScreen = ${JSON.stringify(this.defaultScreens)}`)
  }

  async getAllScreen() {
    this.defaultOrAllScreen = false
    this.allScreens = await display.getAllDisplay()
    Logger.info(TAG, `This getAllScreen = ${JSON.stringify(this.allScreens)}`)
  }

  build() {
    Column() {
      Row() {
        Rect({ width: '40%', height: '23%' })
          .margin({ top: '56px', left: '1%', right: '2%' })
          .id('bigRect')
          .fill('#007dff')
          .onClick(async () => {
            await this.getDefaultScreen()
            Logger.info(TAG, `defaultOrAllScreen = ${this.defaultOrAllScreen}`)
            this.dialogController.open()
          })


        ForEach(this.devices, (item: number, index) => {
          Rect({ width: '40%', height: '23%' })
            .margin({ top: '56px', left: '5%', right: '1%' })
            .fill('#007dff')
            .id('smallRect' + (index + 1))
            .onClick(async () => {
              await this.getAllScreen()
              Logger.info(TAG, `defaultOrAllScreen = ${this.defaultOrAllScreen}`)
              this.dialogController.open()
            })
        })
      }

      Button($r('app.string.add_screen'))
        .width('86%')
        .height('5%')
        .id('addScreen')
        .fontSize(22)
        .backgroundColor('#007dff')
        .type(ButtonType.Capsule)
        .margin({top: '10%', left: '6%', right: '6%', bottom: '3%' })
        .onClick(async () => {
          let result = await this.displayModel.createVirtualScreen(this.screenIds.length)
          Logger.info(TAG, `this createVirtualScreen screen id = ${JSON.stringify(this.screenIds)}`)
          this.screenIds.push(result.id)
        })

      Button($r('app.string.remove_screen'))
        .width('86%')
        .height('5%')
        .id('removeScreen')
        .fontSize(22)
        .backgroundColor('#007dff')
        .type(ButtonType.Capsule)
        .margin({  left: '6%', right: '6%'})
        .onClick(async () => {
          await this.displayModel.destroyVirtualScreen(this.screenIds[this.screenIds.length - 1])
          Logger.info(TAG, `this after destroyVirtualScreen screen id = ${JSON.stringify(this.screenIds)}`)
        })
    }
    .width('100%')
    .height('100%')
  }
}
