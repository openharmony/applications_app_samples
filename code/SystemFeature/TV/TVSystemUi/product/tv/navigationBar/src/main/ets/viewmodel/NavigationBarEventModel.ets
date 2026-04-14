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
 

import AbilityManager from '../../../../../../../common/src/main/ets/default/abilitymanager/AbilityManager';
// import { commonEventManager } from '@kit.BasicServicesKit';
import { inputEventClient } from '@kit.InputKit';
import { KeyCode } from '@kit.InputKit';
import VolumeWindowController
  from '../../../../../../../features/volumepanelcomponent/src/main/ets/com/ohos/common/VolumeWindowController'
import Log from '../../../../../../../common/src/main/ets/default/Log';

import { commonEventManager } from '@kit.BasicServicesKit';

const TAG = 'NavigationBarEventModel';

// NavigationBarEventModel 负责将 TV 遥控器的物理按键事件路由到对应业务动作。
// 采用 switch-case 按键码分发而非配置化，是因为 TV 遥控器按键映射由硬件固定，
// 运行时不会变化，硬编码保证了零运行时解析开销，对遥控器按键响应延迟敏感场景至关重要。
export class NavigationBarEventModel {
  private setupFirstDownTime: number = -1;

  constructor() {

  }

  distinctionKeyCode(keyEvent) {
    let date = new Date()
    console.log(TAG, 'keyEvent: ' + JSON.stringify(keyEvent) + ' Date: ' + JSON.stringify(Date()) + 'Date.getTime: ' +
    JSON.stringify(date.getTime()));
    let code = keyEvent.keyCode
    let keyType = keyEvent.type

    if (code != KeyCode.KEYCODE_MENU) {
      this.setupFirstDownTime = -1
    }
    switch (code) {
      case 2081:
        console.log(TAG, 'case 1');
        if (keyType == 1) {
          this.homeEvent();
        }
        break;
      case 2:
        console.log(TAG, 'case 2');
        if (keyType == 1) {
          this.sendBackEvent();
        }
        break;
      case 22:
        console.log(TAG, 'case 22');
        if (keyType == 1) {
          this.muteEvent();
        }
        break;
      case 2801:
        console.log(TAG, 'need invoke KEY_SETUP');
        if (keyType == 1) {
          this.setupEvent();
        }
        break;
      case KeyCode.KEYCODE_MENU:
        console.log(TAG, 'need invoke KEY_SETUP_MENU');

        if (keyType == 0) {
          if (this.setupFirstDownTime == -1) {
            this.setupFirstDownTime = date.getTime()
          } else {
            if (date.getTime() - this.setupFirstDownTime >= 3000) {
              Log.showInfo(TAG, `distinctionKeyCode, time space: ${JSON.stringify(date.getTime() -
              this.setupFirstDownTime)} , isSettingsOnForeground: ${JSON.stringify(globalThis.isSettingsOnForeground)}`);
              if (globalThis.isSettingsOnForeground == false) {
                this.setupMenuEvent();
              }
            }
          }
        } else if (keyType == 1) {
          this.setupFirstDownTime = -1
        }
        break;
      default:
        break;
    }
    if (code != 2827 && code != 18 && code != 2067) {
      this.setupCompatibleKey();
    }
  }

  // 静音键触发时同时弹出音量面板，让用户能直观看到当前静音状态，
  // 而非仅静默生效，符合 TV 大屏用户习惯于通过屏幕反馈确认操作结果的交互预期。
  muteEvent() {
    VolumeWindowController.getInstance().setWindowState(true);
    commonEventManager.publish('KEY_MUTE', (err) => {
      if (err?.code) {
        console.error('publish failed ' + JSON.stringify(err));
      } else {
        console.info('publish');
      }
    });
  }

  sendBackEvent() {
    commonEventManager.publish('KEY_BACK', (err) => {
      if (err?.code) {
        console.error('publish failed ' + JSON.stringify(err));
      } else {
        console.info('publish');
      }
    });
  }

  // Home 键同时通过 ServiceExtensionAbility 拉起 Launcher 并广播 KEY_HOME 事件，
  // 双管齐下是为了兼容 Launcher 未在前台时的冷启动场景和已在前台时的热切换场景。
  homeEvent() {
    AbilityManager.startServiceExtensionAbility(
      AbilityManager.getContext(AbilityManager.ABILITY_NAME_NAVIGATION_BAR
      ), {
      bundleName: 'com.ohos.launcher',
      abilityName: 'com.ohos.launcher.MainAbility'
    });

    commonEventManager.publish('KEY_HOME', (err) => {
      if (err?.code) {
        console.error('publish failed ' + JSON.stringify(err));
      } else {
        console.info('publish');
      }
    });
  }

  setupEvent() {
    AbilityManager.startAbility(AbilityManager.getContext(AbilityManager.ABILITY_NAME_NAVIGATION_BAR), {
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

  // Menu 键长按 3 秒才触发 setupMenuEvent，而非单次触发，
  // 是为了区分普通菜单操作和进入隐藏工厂设置的行为，防止用户误触打开敏感设置页面。
  setupMenuEvent() {
    AbilityManager.startServiceExtensionAbility(
      AbilityManager.getContext(AbilityManager.ABILITY_NAME_NAVIGATION_BAR
      ), {
      bundleName: 'com.ohos.settings',
      abilityName: 'com.ohos.settings.menu.ServiceAbility'
    });

    commonEventManager.publish('KEY_SETUPMENU', (err) => {
      if (err?.code) {
        console.error('publish failed ' + JSON.stringify(err));
      } else {
        console.info('publish');
      }
    });
  }

  // 此键值为了规避返回后获取不到焦点的问题
  // setupCompatibleKey 在每次按键事件处理完毕后注入一个延迟 1 秒的虚拟 Tab 键（keyCode 2827），
  // 是为了规避 HarmonyOS TV 焦点引擎在某些页面跳转后焦点丢失的平台 bug，
  // 用模拟按键强制刷新焦点链，保证遥控器方向键始终能正确响应。
  setupCompatibleKey() {
    setTimeout(() => {
      inputEventClient.injectEvent({
        KeyEvent: {
          isPressed: true,
          keyCode: 2827,
          keyDownDuration: 1,
          isIntercepted: false
        }
      })
    }, 1000)
  }
}

let navigationBarEventModel = new NavigationBarEventModel();

export default navigationBarEventModel;
