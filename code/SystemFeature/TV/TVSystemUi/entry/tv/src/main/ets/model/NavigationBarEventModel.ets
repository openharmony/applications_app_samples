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
 

import { BusinessError } from '@kit.BasicServicesKit';
import Log from '@ohos/common/src/main/ets/default/Log';
import { commonEventManager } from '@kit.BasicServicesKit';
import AbilityManager from '@ohos/common/src/main/ets/default/abilitymanager/AbilityManager';
import { Want } from '@kit.AbilityKit';
import { common } from '@kit.AbilityKit';

const TAG = 'NavigationBarEventModel';

// entry 模块的 NavigationBarEventModel 是 TV 导航栏按键的简化版事件处理器，
// 相比 product/tv 版本去掉了遥控器物理键监听，只保留屏幕导航栏按键（返回/Home/信源/设置）的处理，
// 职责边界更清晰，避免在 entry 层引入硬件按键依赖。
export class NavigationBarEventModel {
  sendBackEvent() {
    commonEventManager.publish('KEY_BACK', (err) => {
      if (err?.code) {
        console.error('publish failed ' + JSON.stringify(err));
      } else {
        console.info('publish');
      }
    });
  }

  homeEvent() {
    const context: common.ServiceExtensionContext | common.UIAbilityContext | undefined =
      AbilityManager.getContext(AbilityManager.ABILITY_NAME_ENTRY);
    if (!context) {
      Log.showError(TAG, 'homeEvent context is undefined');
      return;
    }
    context.startServiceExtensionAbility({
      bundleName: 'com.ohos.launcher',
      abilityName: 'com.ohos.launcher.MainAbility'
    }).then(() => {
      Log.showInfo(TAG, 'systemUI拉起Launcher成功');
    }).catch((error: BusinessError) => {
      Log.showError(TAG, `systemUI拉起Launcher失败, error: ${JSON.stringify(error)}`);
    })

    commonEventManager.publish('KEY_HOME', (err) => {
      if (err?.code) {
        console.error('publish failed ' + JSON.stringify(err));
      } else {
        console.info('publish');
      }
    });
  }

  // tvEvent 支持携带 specifySource 参数直接跳转到指定信源，
  // 满足遥控器"看电视键"绑定特定信源的需求，未指定时由信源应用自行决策默认信源。
  tvEvent(specifySource: string) {
    const context: common.ServiceExtensionContext | common.UIAbilityContext | undefined =
      AbilityManager.getContext(AbilityManager.ABILITY_NAME_ENTRY);
    if (!context) {
      Log.showError(TAG, 'tvEvent context is undefined');
      return;
    }
    let want : Want = {
      bundleName: 'com.ohos.inputsource',
      abilityName: 'EntryAbility' }
    if (specifySource && specifySource.trim().length > 0) {
      // 信源应用接收的是字符串类型的参数
      want.parameters = {bundleNames: [specifySource]}
    }

    context.startAbility(want).then(() => {
      Log.showInfo(TAG, 'systemUI拉起inputSource成功');
    }).catch((error: BusinessError) => {
      Log.showError(TAG, `systemUI拉起inputSource失败, error: ${JSON.stringify(error)}`);
    });

    commonEventManager.publish('KEY_SETUP', (err) => {
      if (err?.code) {
        console.error('publish failed ' + JSON.stringify(err));
      } else {
        console.info('publish');
      }
    });
  }

  setupEvent() {
    AbilityManager.startAbility(AbilityManager.getContext(AbilityManager.ABILITY_NAME_ENTRY), {
      bundleName: 'com.ohos.settings',
      abilityName: 'com.ohos.settings.MainAbility'
    })

    commonEventManager.publish('KEY_SETUP', (err) => {
      if (err?.code) {
        console.error('publish failed ' + JSON.stringify(err));
      } else {
        console.info('publish');
      }
    });
  }
}

let navigationBarEventModel = new NavigationBarEventModel();

export default navigationBarEventModel;
