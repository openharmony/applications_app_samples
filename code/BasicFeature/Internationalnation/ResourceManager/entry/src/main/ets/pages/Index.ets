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

import resourceManager from '@ohos.resourceManager'
import { Logger } from '../utils/Logger'

const SPECIFIED_NUM = 2

async function getString(resId: number): Promise<string> {
  let resMgr = getContext(this).resourceManager
  try {
    let value = await resMgr.getStringValue(resId)
    return value
  } catch (error) {
    Logger.error(`getStringValue failed, error code: ${error.code}, message: ${error.message}.`)
  }
}

async function getStringArray(resource: resourceManager.Resource): Promise<Array<string>> {
  let resMgr = getContext(this).resourceManager
  try {
    let value = await resMgr.getStringArrayValue(resource)
    return value
  } catch (error) {
    Logger.error(`getStringArrayValue failed, error code: ${error.code}, message: ${error.message}.`)
  }
}

async function getPluralString(resId: number, num: number): Promise<string> {
  let resMgr = getContext(this).resourceManager
  try {
    let value = await resMgr.getPluralStringValue(resId, num)
    return value
  } catch (error) {
    Logger.error(`getPluralStringValue failed, error code: ${error.code}, message: ${error.message}.`)
  }
}

async function getDeviceCapability(): Promise<resourceManager.DeviceCapability> {
  let resMgr = getContext(this).resourceManager
  try {
    let value = await resMgr.getDeviceCapability()
    return value
  } catch (error) {
    Logger.error(`getDeviceCapability failed, error code: ${error.code}, message: ${error.message}.`)
  }
}

async function getConfiguration(): Promise<resourceManager.Configuration> {
  let resMgr = getContext(this).resourceManager
  try {
    let value = await resMgr.getConfiguration()
    return value
  } catch (error) {
    Logger.error(`getConfiguration failed, error code: ${error.code}, message: ${error.message}.`)
  }
}

async function getMedia(resId: number): Promise<Uint8Array> {
  let resMgr = getContext(this).resourceManager
  try {
    let value = await resMgr.getMediaContent(resId)
    return value
  } catch (error) {
    Logger.error(`getMediaContent failed, error code: ${error.code}, message: ${error.message}.`)
  }
}

async function getMediaBase64(resId: number): Promise<string> {
  let resMgr = getContext(this).resourceManager
  try {
    let value = await resMgr.getMediaContentBase64(resId)
    return value
  } catch (error) {
    Logger.error(`getMediaContentBase64 failed, error code: ${error.code}, message: ${error.message}.`)
  }
}

function getFormatString(resId: number, world: string): string {
  let resMgr = getContext(this).resourceManager
  try {
    let value = resMgr.getStringSync(resId, world)
    return value
  } catch (error) {
    Logger.error(`getStringSync failed, error code: ${error.code}, message: ${error.message}.`)
  }
}

async function getDensityMediaBase64(resId: number, density: number): Promise<string> {
  let resMgr = getContext(this).resourceManager
  try {
    let value = await resMgr.getMediaContentBase64(resId, density)
    return value
  } catch (error) {
    Logger.error(`getDensityMediaBase64 failed, error code: ${error.code}, message: ${error.message}.`)
  }
}

async function getSystemMediaBase64(resId: number): Promise<string> {
  // 获取仅系统资源管理对象
  let sysMgr = resourceManager.getSystemResourceManager()
  try {
    let value = await sysMgr.getMediaContentBase64(resId)
    return value
  } catch (error) {
    Logger.error(`getMediaContentBase64 failed, error code: ${error.code}, message: ${error.message}.`)
  }
}

@Entry
@Component
struct Index {
  @State string_str: string = 'string'
  @State strArray: string = 'stringArray'
  @State plural: string = 'plural'
  @State configuration: string = 'configuration'
  @State capability: string = 'capability'
  @State media: string = 'media'
  @State mediaBase: string = 'mediaBase'
  @State formatStr: string = 'Format String'
  @State densityMedia: string = 'Density Media'
  @State systemRes: string = 'System Res'

  async aboutToAppear() {
    this.string_str = await getString($r('app.string.string_str').id)
    let resource = {
      bundleName: "ohos.samples.resourcemanager",
      moduleName: "entry",
      id: $r('app.strarray.str_array').id
    }
    this.strArray = JSON.stringify(await getStringArray(resource))
    this.plural = await getPluralString($r('app.plural.eat_apple').id, SPECIFIED_NUM)
    this.configuration = JSON.stringify(await getConfiguration())
    this.capability = JSON.stringify(await getDeviceCapability())
    this.media = JSON.stringify((await getMedia($r('app.media.app_icon').id)).length)
    this.mediaBase = JSON.stringify((await getMediaBase64($r('app.media.app_icon').id)).length)
    this.formatStr = getFormatString($r('app.string.formatStr').id,
      await getString($r('app.string.world').id))
    this.densityMedia = await getDensityMediaBase64($r('app.media.density').id, 640)
    this.systemRes = await getSystemMediaBase64($r('sys.media.ohos_app_icon').id)
  }

  build() {
    Column() {
      Text($r("app.string.title"))
        .width('100%')
        .height(50)
        .backgroundColor($r('app.color.text_color'))
        .fontColor(Color.White)
        .fontSize(20)
        .padding({ left: 15 })

      Scroll() {
        Column() {
          Text($r('app.string.stringDesc'))
            .fontSize(25)

          Text(this.string_str)
            .fontSize(25)
            .fontColor('#ffff0000')
            .fontWeight(FontWeight.Bold)

          Text($r('app.string.stringArrayDesc'))
            .fontSize(25)

          Text(this.strArray)
            .fontSize(25)
            .fontColor('#ffff0000')
            .fontWeight(FontWeight.Bold)

          Text($r('app.string.pluralStringDesc'))
            .fontSize(25)

          Text(this.plural)
            .fontSize(25)
            .fontColor('#ffff0000')
            .fontWeight(FontWeight.Bold)

          Text($r('app.string.configurationDesc'))
            .fontSize(25)

          Text(this.configuration)
            .fontSize(25)
            .fontColor('#ffff0000')
            .fontWeight(FontWeight.Bold)

          Text($r('app.string.capabilityDesc'))
            .fontSize(25)

          Text(this.capability)
            .fontSize(25)
            .fontColor('#ffff0000')
            .fontWeight(FontWeight.Bold)

          Text($r('app.string.mediaDesc'))
            .fontSize(25)

          Text(this.media)
            .fontSize(25)
            .fontColor('#ffff0000')
            .fontWeight(FontWeight.Bold)

          Text($r('app.string.mediaBase64Desc'))
            .fontSize(25)

          Text(this.mediaBase)
            .fontSize(25)
            .fontColor('#ffff0000')
            .fontWeight(FontWeight.Bold)

          Text($r('app.string.formatStrDesc'))
            .fontSize(25)

          Text(this.formatStr)
            .fontSize(25)
            .fontColor('#ffff0000')
            .fontWeight(FontWeight.Bold)

          Text($r('app.string.densityMediaDesc'))
            .fontSize(25)

          Image(this.densityMedia)
            .id('getDensityMedia')
            .height('10%')

          Text($r('app.string.systemResDesc'))
            .fontSize(25)

          Image(this.systemRes)
            .id('getSystemMedia')
            .height('10%')
        }
        .width('100%')
        .padding(10)
        .alignItems(HorizontalAlign.Start)
      }
    }
    .width('100%')
    .height('100%')
  }
}