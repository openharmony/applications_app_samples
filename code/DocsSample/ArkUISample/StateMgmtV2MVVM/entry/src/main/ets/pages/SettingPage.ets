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
 *
*/

// src/main/ets/pages/SettingPage.ets

import { AppStorageV2 } from '@kit.ArkUI';
import { common } from '@kit.AbilityKit';

@ObservedV2
export class Setting {
  @Trace public showCompletedTask: boolean = true;
}

@Entry
@ComponentV2
struct SettingPage {
  @Local setting: Setting = AppStorageV2.connect(Setting, 'Setting', () => new Setting())!;
  private context = getContext(this) as common.UIAbilityContext;

  build(){
    Column(){
      Text($r('app.string.Setting'))
        .fontSize(40)
        .margin({ bottom: 10 })
      Row() {
        Text($r('app.string.Show_finished_tasks'))
        Toggle({ type: ToggleType.Switch, isOn:this.setting.showCompletedTask })
          .onChange((isOn) => {
            this.setting.showCompletedTask = isOn;
          })
      }
      Button($r('app.string.Back'))
        .onClick(()=>this.context.terminateSelf())
        .margin({ top: 10 })
    }
    .alignItems(HorizontalAlign.Start)
  }
}