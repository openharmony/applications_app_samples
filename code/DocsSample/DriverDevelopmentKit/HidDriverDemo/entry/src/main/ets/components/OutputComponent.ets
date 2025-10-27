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
import { OutputParams } from '../utils/Params';
import { OutputType } from '../utils/RequestCode';


@Component
//@Preview
export struct OutputComponent{
  @State outparams: OutputParams = new OutputParams();
  @State outputType: OutputType = OutputType.SendReport;

  @Styles normalStyle() {
    .backgroundColor(Color.Blue)
  }

  @Styles pressedStyle() {
    .backgroundColor(Color.White)
  }

  build() {
    Column({space: 30}) {
      Row() {
        Row({space: 20}) {
          Column() {
            Text('SendReport')
            Radio({ value: 'SendReport', group: 'outradioGroup', indicatorType:RadioIndicatorType.TICK }).checked(true)
              .height(30)
              .width(30)
              .onChange((isChecked: boolean) => {
                this.outputType = OutputType.SendReport;
              })
          }

          Column() {
            Text('Write')
            Radio({ value: 'Write', group: 'outradioGroup', indicatorType:RadioIndicatorType.TICK }).checked(false)
              .height(30)
              .width(30)
              .onChange((isChecked: boolean) => {
                this.outputType = OutputType.Write;
              })
          }
        }

        Button($r('app.string.str_set'))
          .fontSize(15)
          .height(30)
          .width(70)
          .margin({left:150,top:5})
          .onClick(() => {
            RpcTool.getInstance().setOutput(this.outputType, this.outparams);
          })
          .stateStyles({
            normal: this.normalStyle,
            pressed: this.pressedStyle,
          })
      }
      .width('100%')
      .margin({left: 50})

      Row() {
        Text('Num Lock：')
          .padding({left:10})
          .fontSize(20)
        Toggle({ type: ToggleType.Switch, isOn: false })
          .margin({left:9})
          .onChange((value) => {
            this.outparams.numLock = value;
          })
      }.width('100%')
      .margin({left:35})

      Row() {
        Text('Caps Lock：')
          .padding({left:10})
          .fontSize(20)
        Toggle({ type: ToggleType.Switch, isOn: false })
          .margin({left:9})
          .onChange((value) => {
            this.outparams.capsLock = value;
          })
      }.width('100%')
      .margin({left:30})

      Row() {
        Text('Scroll Lock：')
          .padding({left:10})
          .fontSize(20)
        Toggle({ type: ToggleType.Switch, isOn: false })
          .onChange((value) => {
            this.outparams.scrollLock = value;
          })
      }.width('100%')
      .margin({left:35})
    }.margin({bottom: 100})
  }
}