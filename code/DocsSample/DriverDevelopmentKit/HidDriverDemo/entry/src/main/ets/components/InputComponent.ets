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
import { InputParams } from '../utils/Params';
import { InputType } from '../utils/RequestCode';

@Component
export struct InputComponent{
  @Link inputParams: InputParams;
  @State inputType: InputType = InputType.GetReport;
  @State tipStr: string = '请按下键盘按键的同时点击获取按钮';
  controller: TextAreaController = new TextAreaController();

  @Styles normalStyle() {
    .backgroundColor(Color.Blue)
  }

  @Styles pressedStyle() {
    .backgroundColor(Color.White)
  }

  @Styles disableStyle() {
    .backgroundColor(Color.Gray)
  }

  build() {
    Column({space: 30}) {
      Row() {
        Row({space: 20}) {
          Column() {
            Text('GetReport')
            Radio({ value: 'GetReport', group: 'radioGroup', indicatorType:RadioIndicatorType.TICK }).checked(true)
              .height(30)
              .width(30)
              .onChange((isChecked: boolean) => {
                this.inputType = InputType.GetReport;
                this.tipStr = '请按下键盘按键的同时点击获取按钮';
              })
          }

          Column() {
            Text($r('app.string.read_block'))
            Radio({ value: 'Read(阻塞)', group: 'radioGroup', indicatorType:RadioIndicatorType.TICK }).checked(false)
              .height(30)
              .width(30)
              .onChange((isChecked: boolean) => {
                this.inputType = InputType.ReadBlock;
                this.tipStr = '点击获取按钮按钮灰化后，点击键盘按键即可，只按一个按键';
              })
          }
          Column() {
            Text($r('app.string.read_nonblock'))
            Radio({ value: 'Read(非阻塞)', group: 'radioGroup', indicatorType:RadioIndicatorType.TICK }).checked(false)
              .height(30)
              .width(30)
              .onChange((isChecked: boolean) => {
                this.inputType = InputType.ReadNonBlock;
                this.tipStr = '先点击键盘按键再点击获取按钮，只按一个按键';
              })
          }
        }

        Button($r('app.string.get_str'))
          .fontSize(15)
          .height(30)
          .width(70)
          .margin({left:80,top:5})
          .enabled(this.inputParams.freshUI)
          .onClick(() => {
            this.inputParams.freshUI = false;
            RpcTool.getInstance().getInput(RpcTool.getInstance().deviceId, this.inputType);
          })
          .stateStyles({
            normal: this.normalStyle,
            pressed: this.pressedStyle,
            disabled: this.disableStyle,
          })
      }


      Row() {
        Text('Left Ctrl：')
          .padding({left:10})
          .fontSize(20)
        Toggle({ type: ToggleType.Switch, isOn: this.inputParams.stateOfE0 })
          .margin({left:13})
          .enabled(false)
          .backgroundColor('#0c3d6086')
        Text('Left Shift：')
          .padding({left:100})
          .fontSize(20)
        Toggle({ type: ToggleType.Switch, isOn: this.inputParams.stateOfE1 })
          .margin({left:11})
          .enabled(false)
          .backgroundColor('#0c3d6086')
      }.width('100%')
      .margin({left:35})

      Row() {
        Text('Left Alt：')
          .padding({left:10})
          .fontSize(20)
        Toggle({ type: ToggleType.Switch, isOn: this.inputParams.stateOfE2 })
          .margin({left:21})
          .enabled(false)
          .backgroundColor('#0c3d6086')
        Text('Left Win：')
          .padding({left:100})
          .fontSize(20)
        Toggle({ type: ToggleType.Switch, isOn: this.inputParams.stateOfE3 })
          .margin({left:19})
          .enabled(false)
          .backgroundColor('#0c3d6086')
      }.width('100%')
      .margin({left:35})

      Row() {
        Text('Right Ctrl：')
          .padding({left:10})
          .fontSize(20)
        Toggle({ type: ToggleType.Switch, isOn: this.inputParams.stateOfE7 })
          .margin({left:5})
          .enabled(false)
          .backgroundColor('#0c3d6086')
        Text('Right shift：')
          .padding({left:97})
          .fontSize(20)
        Toggle({ type: ToggleType.Switch, isOn: this.inputParams.stateOfE4 })
          .margin({left:3})
          .enabled(false)
          .backgroundColor('#0c3d6086')
      }.width('100%')
      .margin({left:30})

      Row() {
        Text('Right Alt：')
          .padding({left:10})
          .fontSize(20)
        Toggle({ type: ToggleType.Switch, isOn: this.inputParams.stateOfE5 })
          .margin({left:10})
          .enabled(false)
          .backgroundColor('#0c3d6086')
        Text('Right Win：')
          .padding({left:97})
          .fontSize(20)
        Toggle({ type: ToggleType.Switch, isOn: this.inputParams.stateOfE6 })
          .margin({left:9})
          .enabled(false)
          .backgroundColor('#0c3d6086')
      }.width('100%')
      .margin({left:35})

      Column({space: 0}) {
        Text('数据')
          .padding({left: 10})
          .fontSize(18)
          .width('20%')
        TextArea({text: this.inputParams.data, placeholder: this.tipStr, controller: this.controller})
          .placeholderFont({ size: 16, weight: 400 })
          .margin({left:10})
          .width('83%')
          .height('20%')
          .fontSize(21)
          .fontColor('#182431')
          .enabled(false)
          .backgroundColor('#0C182431')
          .borderStyle(BorderStyle.Solid).borderWidth(1).borderColor('#FF007DFF')
          .onChange((value: string) => {
          })
      }
      .width('100%')
      .margin({left:35})
      .alignItems(HorizontalAlign.Start)
    }
  }
}