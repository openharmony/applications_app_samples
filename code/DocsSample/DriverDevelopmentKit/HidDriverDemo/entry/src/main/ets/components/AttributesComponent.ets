/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

import RpcTool from '../tool/RpcTool';
import { RequestCode } from '../utils/RequestCode';
import { hilog } from '@kit.PerformanceAnalysisKit';

@Component
//@Preview
export struct AttributesComponent {
  @Link rawName: string;
  @Link rawUniqueId: string;
  @Link physicalAddress: string;
  @Link rawInfo: string;
  @Link descriptor: string;
  controller: TextAreaController = new TextAreaController();

  @Styles normalStyle() {
    .backgroundColor(Color.Blue)
  }

  @Styles pressedStyle() {
    .backgroundColor(Color.White)
  }

  build() {
    Column({space: 30}) {
      Row() {
        Text('Raw name：')
          .padding({left:10})
          .fontSize(18)
        Text(this.rawName)
          .width('40%')
          .backgroundColor('#0C182431')
          .margin({left: 33})
          .height('6%')
          .fontSize(17)
        Button($r('app.string.get_str'))
          .margin({left: 10})
          .onClick(()=>{
            RpcTool.getInstance().testGetInferface(RpcTool.getInstance().deviceId, RequestCode.GetRawName);
            hilog.info(0, 'testTag ui', ` rawName: ${this.rawName}`);
          })
          .stateStyles({
            normal: this.normalStyle,
            pressed: this.pressedStyle,
          })
      }
      .width('100%')
      .margin({left:35})

      Row() {
        Text('Raw Info：')
          .padding({left:10})
          .fontSize(18)
        Text(this.rawInfo)
          .width('40%')
          .backgroundColor('#0C182431')
          .margin({left: 47})
          .height('6%')
          .fontSize(17)
        Button($r('app.string.get_str'))
          .margin({left: 10})
          .onClick(()=>{
            RpcTool.getInstance().testGetInferface(RpcTool.getInstance().deviceId, RequestCode.GetRawInfo);
          })
          .stateStyles({
            normal: this.normalStyle,
            pressed: this.pressedStyle,
          })
      }
      .width('100%')
      .margin({left:35})
      Row() {
        Text('Raw unique id：')
          .padding({left:10})
          .fontSize(18)
        Text(this.rawUniqueId)
          .width('40%')
          .backgroundColor('#0C182431')
          .margin({left: 1})
          .height('6%')
          .fontSize(17)
        Button($r('app.string.get_str'))
          .margin({left: 10})
          .onClick(()=>{
            RpcTool.getInstance().testGetInferface(RpcTool.getInstance().deviceId, RequestCode.GetRawUniqueId);
            hilog.info(0, 'testTag ui', ` rawUniqueId: ${this.rawUniqueId}`);
          })
          .stateStyles({
            normal: this.normalStyle,
            pressed: this.pressedStyle,
          })
      }
      .width('100%')
      .margin({left:35})

      Row() {
        Text('Physical addr：')
          .padding({left:10})
          .fontSize(18)
        Text(this.physicalAddress)
          .width('40%')
          .backgroundColor('#0C182431')
          .margin({left: 10})
          .height('6%')
          .fontSize(17)
        Button($r('app.string.get_str'))
          .margin({left: 10})
          .onClick(()=>{
            RpcTool.getInstance().testGetInferface(RpcTool.getInstance().deviceId, RequestCode.GetPhysicalAddr);
            hilog.info(0, 'testTag ui', ` physicalAddress: ${this.physicalAddress}`);
          })
          .stateStyles({
            normal: this.normalStyle,
            pressed: this.pressedStyle,
          })
      }
      .width('100%')
      .margin({left:35})

      Row() {
        Text('descriptor：')
          .padding({left:10})
          .fontSize(18)
        TextArea({text: this.descriptor, placeholder: '', controller: this.controller})
          .placeholderFont({ size: 16, weight: 400 })
          .margin({left:35})
          .width('40%')
          .height('45%')
          .fontSize(17)
          .fontColor(Color.Black)
          .enabled(false)
          .backgroundColor('#0C182431')
          .borderStyle(BorderStyle.Solid).borderWidth(1).borderColor('#FF007DFF')
          .onChange((value: string) => {
          })
        Button($r('app.string.get_str'))
          .margin({left: 10})
          .onClick(()=>{
            RpcTool.getInstance().testGetInferface(RpcTool.getInstance().deviceId, RequestCode.GetDescriptor);
            hilog.info(0, 'testTag ui', ` physicalAddress: ${this.descriptor}`);
          })
          .stateStyles({
            normal: this.normalStyle,
            pressed: this.pressedStyle,
          })
      }
      .width('100%')
      .margin({left:35})
    }
  }
}