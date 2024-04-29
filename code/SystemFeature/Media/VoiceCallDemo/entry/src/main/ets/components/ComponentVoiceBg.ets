/*
 * Copyright (c) 2023 Hunan OpenValley Digital Industry Development Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *  http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import Caller from '../bean/Caller';
import ComponentPerson from '../components/ComponentPerson';
import ComponentSingletonTimer from '../components/ComponentSingletonTimer';
import FloatWindowController from '../controller/FloatWindowController';

/**
 * 通用背景组件，包含
 *    悬浮窗切换按钮
 *    头像名称
 *    提示语/计时组件
 *    单个@BuilderParam，可以以闭包形式传入按钮group，实现不同页面的不同操作按钮
 */
@Component
export default struct ComponentVoiceBg {
  @Link mPerson: Caller;
  @BuilderParam options: () => void;
  private showTimer?: boolean;
  private tips?: string | Resource;

  build() {
    Column() {
      Column() {
        Row() {
          Blank()
          Button() {
            Image($r('app.media.icon_openvalley_reduce'))
              .width(40)
              .height(40)
          }
          .width(64)
          .height(64)
          .id('switch_window_to_float')
          .type(ButtonType.Circle)
          .backgroundColor($r('app.color.color_transparent'))
          .onClick(() => {
            FloatWindowController.getInstance().hideMain();
          })
        }.width('80%')
        .height(64)

        ComponentPerson({ mPerson: $mPerson })

        Column().height(24)

        if (this.showTimer) {
          ComponentSingletonTimer({ mTextColor: $r('app.color.color_fff'), mTextSize: 18 })
        } else if (this.tips) {
          Text(this.tips)
            .fontColor($r('app.color.color_fff'))
            .fontSize(18)
            .fontWeight(FontWeight.Regular)
            .fontFamily('HarmonyOS Sans SC')
        }
      }

      this.options()
    }
    .padding({ bottom: 104, top: 56 })
    .justifyContent(FlexAlign.SpaceBetween)
    .backgroundColor($r('app.color.color_voice_background'))
    .width('100%')
    .height('100%')
  }
}