/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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

// [Start quick_start]
import { window } from '@kit.ArkUI'
import common from '@ohos.app.ability.common';
import { Callback } from '@kit.BasicServicesKit';
import { display } from '@kit.ArkUI';

@Entry
@Component
struct Index {
  @State currentOrientation: string = 'UNSPECIFIED';
  private stage: window.WindowStage = (this.getUIContext().getHostContext() as common.UIAbilityContext).windowStage;

  aboutToAppear() {
    let ret: boolean = false;
    ret = display.isFoldable();
    if (ret) {
      let callback: Callback<display.FoldDisplayMode> = (data: display.FoldDisplayMode) => {
        console.info(`Listening enabled. Data: ${data}`);
        this.getBreakPointAndSetOrientation();
      };
      display.on('foldDisplayModeChange', callback);
    } else {
      this.getBreakPointAndSetOrientation();
    }
  }

  private getBreakPointAndSetOrientation(): void {
    let displayInfo = display.getDefaultDisplaySync();
    let displayWidth = displayInfo.width;
    let displayHeight = displayInfo.height;
    let heightBp = displayHeight / displayWidth;
    if(displayWidth > displayHeight) {
      let temp = displayWidth;
      displayWidth = displayHeight;
      displayHeight = temp;
    }
    // 建议使用单一策略如"FOLLOW_DESKTOP"来应对设备的差异化，如单一策略无法满足需求，可参考断点机制，屏蔽设备差异
    // 此处是举的特殊示例，原则上支持横屏的应用，旋转策略应该是支持4个方向可旋转，此处是为了说明断点的使用方式，才举此例
    // 600为宽度断点枚举值其中的边界值， 0.8为高宽比断点枚举值其中的边界值
    if (displayWidth >= 600 && heightBp < 0.8) {
      this.stage.getMainWindowSync().setPreferredOrientation(window.Orientation.LANDSCAPE);
      this.currentOrientation = 'LANDSCAPE';
    } else {
      this.stage.getMainWindowSync().setPreferredOrientation(window.Orientation.PORTRAIT);
      this.currentOrientation = 'PORTRAIT';
    }
  }
  build() {
    RelativeContainer() {
      Text(this.currentOrientation)
        .fontWeight(600)
        .fontSize(30)
        .textAlign(TextAlign.Center)
        .position({y: 300})
        .width('100%')
    }
    .height('100%')
    .width('100%')
  }
}
// [End quick_start]