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

const SPECIFIED_NUM = 2

@Entry
@Component
struct Index {
  @State string_str: string = 'string:'
  @State strArray: string = 'stringArray:'
  @State plural: string = 'plural:'
  @State configuration: string = ''
  @State capability: string = ''
  @State media: string = 'icon'
  @State mediaBase: string = 'icon'

  async aboutToAppear() {
    let resourceManager = getContext(this).resourceManager
    this.string_str += await resourceManager.getStringValue($r('app.string.entry_MainAbility').id)
    this.strArray += JSON.stringify(await resourceManager.getStringArrayValue($r('app.strarray.str_array').id))
    this.plural += JSON.stringify(await resourceManager.getPluralStringValue($r('app.plural.eat_apple').id, SPECIFIED_NUM))
    this.capability = await resourceManager.getStringValue($r('app.string.capability').id)
    this.capability += JSON.stringify(await resourceManager.getDeviceCapability())
    this.configuration = await resourceManager.getStringValue($r('app.string.configuration').id)
    this.configuration += JSON.stringify(await resourceManager.getConfiguration())
    this.media += await resourceManager.getStringValue($r('app.string.media').id)
    this.media += (await resourceManager.getMediaContent($r('app.media.app_icon').id)).length
    this.mediaBase += await resourceManager.getStringValue($r('app.string.media_base'))
    this.mediaBase += (await resourceManager.getMediaContentBase64($r('app.media.app_icon').id)).length
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
          Text(this.string_str)
            .fontSize(25)

          Text(this.strArray)
            .fontSize(25)

          Text(this.plural)
            .fontSize(25)

          Text(this.capability)
            .fontSize(25)

          Text(this.configuration)
            .fontSize(25)

          Text(this.media)
            .fontSize(25)

          Text(this.mediaBase)
            .fontSize(25)
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