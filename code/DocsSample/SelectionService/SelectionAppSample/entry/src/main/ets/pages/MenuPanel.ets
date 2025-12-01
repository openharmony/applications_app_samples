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

import { SelectionModel } from '../models/SelectionModel';
import { selectionManager, PanelInfo, BusinessError } from '@kit.BasicServicesKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import Want from '@ohos.app.ability.Want';

@Entry
@Component
struct MenuPanel {
  @State message: string = 'MenuPanel';
  selectionInfo: selectionManager.SelectionInfo | undefined = undefined;

  CreateMainPanel() {
    this.selectionInfo = SelectionModel.getInstance().getSelectionInfo();
    let panelInfo: PanelInfo = {
      PanelType: 2,
      x: 0,
      y: 0,
      width: 1500,
      height: 1000
    }
    selectionManager.createPanel(SelectionModel.getInstance().getContext(), panelInfo)
      .then(async (panel: selectionManager.Panel) => {
        SelectionModel.getInstance().setSelectionPanel(panel);
        hilog.info(0x0000, 'SelectionExtensionAbility', 'Succeed to create main panel');
        if (this.selectionInfo !== undefined) {
          panel.moveTo(this.selectionInfo.startDisplayX + 100, this.selectionInfo.startDisplayY + 100);
        }
        try {
          panel.on('destroyed', () => {
            hilog.info(0x0000, 'SelectionExtensionAbility', 'panel has destroyed');
          })
        } catch (error) {
          hilog.info(0x0000, 'SelectionExtensionAbility', 'Failed to listen window destroy');
        }
        panel.setUiContent('pages/MainPanel')
          .then(() => {
            hilog.info(0x0000, 'SelectionExtensionAbility', 'Succeed to setUiContent [pages/MainPanel].');
          })
          .catch((error: BusinessError) => {
            hilog.info(0x0000, 'SelectionExtensionAbility', `Failed to setUiContent of main panel, error: [${JSON.stringify(error)}]`);
            return;
          });

        await panel.show()
          .then(() => {
            hilog.info(0x0000, 'SelectionExtensionAbility', 'Succeed to show main panel.');
          })
          .catch((error: BusinessError) => {
            hilog.info(0x0000, 'SelectionExtensionAbility', `Failed to show main panel, error: [${JSON.stringify(error)}]`);
            return;
          });
      })
      .catch((error: BusinessError) => {
        hilog.info(0x0000, 'SelectionExtensionAbility', `Failed to createPanel, error: [${JSON.stringify(error)}]`);
        return;
      });
  }

  startEntryAbility() {
    let wantAbility: Want = {
      bundleName: 'com.selection.selectionapplication',
      abilityName: 'EntryAbility',
    };
    let context: SelectionExtensionContext | undefined = SelectionModel.getInstance().getContext();
    if (context !== undefined) {
      context.startAbility(wantAbility)
        .then(() => {
          hilog.info(0x0000, 'SelectionExtensionAbility', `startAbility success, want: ${wantAbility.abilityName}`);
        })
        .catch((error: BusinessError) => {
          hilog.info(0x0000, 'SelectionExtensionAbility', `startAbility failed, error: ${JSON.stringify(error)}`);
        })
    }
  }

  build() {
    Column() {
      Button('click to show MAIN_PANEL')
        .onClick(() => {
          this.CreateMainPanel();
        })
      Button('start EntryAbility')
        .onClick(() => {
          this.startEntryAbility();
        })
    }
    .backgroundColor('#AAFFFF')
    .height('100%')
    .width('100%')
  }
}