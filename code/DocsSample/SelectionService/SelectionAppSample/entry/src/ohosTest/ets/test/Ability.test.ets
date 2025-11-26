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

import { hilog } from '@kit.PerformanceAnalysisKit';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import { abilityDelegatorRegistry } from '@ohos.app.ability.abilityDelegatorRegistry';
import { selectionManager, PanelInfo, PanelType, BusinessError } from '@kit.BasicServicesKit';
import { Driver } from '@ohos.UiTest';

export default function abilityTest() {
  describe('ActsAbilityTest', () => {
    /**
     * 打开应用
     */
    it('ArkTSSelectionService_StartAbility_001', 0, async (done: Function) => {
      hilog.info(0x0000, 'ActsAbilityTest', 'StartAbility_001, begin');
      let driver = Driver.create();
      let abilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
      try {
        await abilityDelegator.startAbility({
          bundleName: 'com.selection.selectionapplication',
          abilityName: 'EntryAbility'
        });
      } catch (exception) {
        hilog.info(0x0000, 'ActsAbilityTest', `StartAbility_001 exception = ${JSON.stringify(exception)}`);
        expect().assertFail();
      }
      done();
      hilog.info(0x0000, 'ActsAbilityTest', 'StartAbility_001 end')
    })

    /*
     * 创建弹窗
     */
    it('ArkTSSelectionService_CreatePanel', 0, async (done: Function) => {
      hilog.info(0x0000, 'ActsAbilityTest', 'enter');
      let abilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
      let context = abilityDelegator.getAppContext();
      context.stageMode = true;
      let panelInfo: PanelInfo = {
        panelType: PanelType.MENU_PANEL,
        x: 0,
        y: 0,
        width: 100,
        height: 100
      }
      let panel: selectionManager.Panel | undefined = undefined;
      let bDestroyed = false;
      try {
        panel = await selectionManager.createPanel(context, panelInfo);
        await panel.moveTo(20, 20);
        await selectionManager.destroyPanel(panel);
        bDestroyed = true;
      } catch (error) {
        hilog.info(0x0000, 'ActsAbilityTest', `ArkTSSelectionService_CreatePanel error = ${JSON.stringify(error)}`);
        expect().assertFail();
      } finally {
        if (!bDestroyed) {
          await selectionManager.destroyPanel(panel);
        }
      }
      done();
      hilog.info(0x0000, 'ActsAbilityTest', 'ArkTSSelectionService_CreatePanel end');
    })
  })
}