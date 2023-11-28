/*
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
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

import common from '@ohos.app.ability.common';
import LiteStore from '../model/LiteStore';
import Logger from '../model/Logger';
import { SyncState } from '../model/LiteStore';
import { TitleBar } from '../common/TitleBar';

const TAG: string = 'Settings';

@Entry
@Component
struct Settings {
  @State syncState: string = SyncState.ManualSync;
  private liteStore = new LiteStore('sync_state', getContext(this) as common.UIAbilityContext);

  aboutToAppear() {
    this.liteStore.getValue().then((value) => {
      Logger.info(TAG, `liteStore getValue: ${value}`);
      this.syncState = `${value}`;
    })
  }

  @Builder SwitchBar(key: string, text: Resource, switchOn: string, onChange: (isOn: boolean) => void) {
    Row() {
      Text(text)
        .fontSize(22)
        .fontWeight(FontWeight.Bold)
        .layoutWeight(1)
      Column() {
        Toggle({ type: ToggleType.Switch, isOn: this.syncState === switchOn })
          .id((key) + 'Toggle')
          .onChange(onChange)
      }
    }
    .width('95%')
    .padding(16)
    .margin({ top: 10 })
    .backgroundColor(Color.White)
    .borderRadius(16)
  }

  build() {
    Column() {
      TitleBar({ hasBackPress: true })
      this.SwitchBar('automatic', $r('app.string.automatic'), SyncState.AutomaticSync, (isOn: boolean) => {
        Logger.info(TAG, `automatic swtich is: ${isOn}`);
        if (isOn) {
          this.syncState = SyncState.AutomaticSync;
        } else {
          this.syncState = SyncState.ManualSync;
        }
        this.liteStore.setValue(this.syncState);
      })

      this.SwitchBar('manual', $r('app.string.manual'), SyncState.ManualSync, (isOn: boolean) => {
        Logger.info(TAG, `manualmatic swtich is: ${isOn}`);
        if (isOn) {
          this.syncState = SyncState.ManualSync;
        } else {
          this.syncState = SyncState.AutomaticSync;
        }
        this.liteStore.setValue(this.syncState);
      })
    }
    .height('100%')
    .width('100%')
    .backgroundColor('#F9F9F9')
  }
}