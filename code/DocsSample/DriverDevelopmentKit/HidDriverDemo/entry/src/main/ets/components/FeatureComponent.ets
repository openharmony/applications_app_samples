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
import { hilog } from '@kit.PerformanceAnalysisKit';

const TURN_ON_LIGHT:string = '07,ff,ff,00,0d,00,00,00';
const TURN_OFF_LIGHT:string = '07,ff,ff,00,00,00,00,00';

@Component
export struct FeatureComponent{
  @Link featureData: string;
  @State setData: string = '';
  controller: TextAreaController = new TextAreaController();

  @Styles normalStyle() {
    .backgroundColor(Color.Blue)
  }

  @Styles pressedStyle() {
    .backgroundColor(Color.White)
  }

  build() {
    Column({space: 60}) {
      Column({space: 20}) {
        Row() {
          Button($r('app.string.get_str'))
            .fontSize(18)
            .height(30)
            .width(70)
            .margin({left:20,top:5})
            .onClick(() => {
              RpcTool.getInstance().getFeature();
            })
            .stateStyles({
              normal: this.normalStyle,
              pressed: this.pressedStyle,
            })
        }
        .width('100%')
        .margin({left:30})

        Column({space: 0}) {
          Text($r('app.string.get_str'))
            .padding({left: 10})
            .fontSize(16)
            .width('20%')
          TextArea({text: this.featureData, placeholder: '此处用于显示获取的特性数据', controller: this.controller})
            .placeholderFont({ size: 16, weight: 400 })
            .margin({left:10})
            .width('83%')
            .height('20%')
            .fontSize(18)
            .fontColor('#182431')
            .enabled(false)
            .backgroundColor('#0C182431')
            .borderStyle(BorderStyle.Solid).borderWidth(1).borderColor('#FF007DFF')
            .onChange((value: string) => {
              hilog.info(0, 'testTag ui', 'feature value:' + this.featureData);
              this.featureData = value;
            })
        }
        .width('100%')
        .margin({left:35})
        .alignItems(HorizontalAlign.Start)
      }
      .width('100%')

      Row() {
        Text($r('app.string.set_led'))
          .padding({left:10})
          .fontSize(18)
        Toggle({ type: ToggleType.Switch, isOn: false })
          .margin({left:21})
          .onChange((value)=>{
            if (value) {
              this.setData = TURN_ON_LIGHT;
            } else {
              this.setData = TURN_OFF_LIGHT;
            }

            RpcTool.getInstance().setFeature(this.setData);
          })
      }
      .width('100%')
      .margin({left:35})

    }.margin({bottom: 100})
  }
}