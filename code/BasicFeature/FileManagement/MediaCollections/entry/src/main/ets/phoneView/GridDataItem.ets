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

import { gridData } from '../model/GridData'

@Component
export struct GridDataItem {
  @State bgrColor: string = '#222324'
  @Link isBom: boolean
  @Link isTitle: string
  @Link isXComponent: boolean
  @Link @Watch('clickSetBgrColor') clickIndex: number
  private context: any
  private item: gridData
  private index: number = -1
  @State videoText:string = ''
  async aboutToAppear() {
    this.videoText = await this.convertResourceToString($r('app.string.phoneMain_video'))
  }
  async convertResourceToString(resource: Resource){
    return await this.context.resourceManager.getString(resource)
  }
  clickSetBgrColor() {
    if (this.index !== this.clickIndex) {
      this.bgrColor = '#222324'
    } else {
      this.bgrColor = 'rgba(255,255,255,0.1)'
    }
  }

  build() {
    Column() {
      Image(this.item.icon).width(40).height(40)
      Text(this.item.textStr)
        .margin({ top: 5 })
        .fontSize(16)
        .fontColor('rgba(255,255,255,0.90)')
        .fontStyle(FontStyle.Normal)
        .fontWeight(400)
        .textAlign(TextAlign.Center)
        .fontFamily('HarmonyHeiTi')
    }
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .width(95)
    .height(95)
    .borderRadius(12)
    .backgroundColor(this.bgrColor)
    .onClick(() => {
      this.clickIndex = this.index
      this.isBom = !this.isBom
      this.isTitle = this.item.textStr
      if (this.isTitle == this.videoText ) {
        this.isXComponent = true
      }
    })
  }
}