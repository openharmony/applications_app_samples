/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { AbilityConstant, AbilityLifecycleCallback, UIAbility } from '@kit.AbilityKit';
import { BusinessError } from '@ohos.base';
import { window } from '@kit.ArkUI';
import { hilog } from '@kit.PerformanceAnalysisKit';

const TAG: string = '[AbilityLifecycleCallback]';
const DOMAIN: number = 0xFF00;

export class GlobalContext {
  private constructor() {
  }

  private static instance: GlobalContext;
  private _objects = new Map<string, Object>();

  public static getContext(): GlobalContext {
    if (!GlobalContext.instance) {
      GlobalContext.instance = new GlobalContext();
    }
    return GlobalContext.instance;
  }

  getObject(value: string): Object | undefined {
    return this._objects.get(value);
  }

  setObject(key: string, objectClass: Object): void {
    this._objects.set(key, objectClass);
  }
}

// 声明ability生命周期回调，需配置所有回调后才可以在applicationContext注册
let abilityLifecycleCallback: AbilityLifecycleCallback = {
  onAbilityCreate(ability) {
    hilog.info(DOMAIN, TAG, 'AbilityLifecycleCallback onAbilityCreate.');
  },
  onWindowStageCreate(ability, windowStage) {
    hilog.info(DOMAIN, TAG, 'AbilityLifecycleCallback onWindowStageCreate.');
  },
  onWindowStageActive(ability, windowStage) {
    hilog.info(DOMAIN, TAG, 'AbilityLifecycleCallback onWindowStageActive.');
  },
  onWindowStageInactive(ability, windowStage) {
    hilog.info(DOMAIN, TAG, 'AbilityLifecycleCallback onWindowStageInactive.');
  },
  onWindowStageDestroy(ability, windowStage) {
    hilog.info(DOMAIN, TAG, 'AbilityLifecycleCallback onWindowStageDestroy.');
  },
  onAbilityDestroy(ability) {
    hilog.info(DOMAIN, TAG, 'AbilityLifecycleCallback onAbilityDestroy.');
  },
  onAbilityForeground(ability) {
    hilog.info(DOMAIN, TAG, 'AbilityLifecycleCallback onAbilityForeground.');
  },
  onAbilityBackground(ability) {
    hilog.info(DOMAIN, TAG, 'AbilityLifecycleCallback onAbilityBackground.');
  },
  onAbilityContinue(ability) {
    hilog.info(DOMAIN, TAG, 'AbilityLifecycleCallback onAbilityContinue.');
  },
  // 注册监听应用上下文的生命周期后，在UIAbility的[onNewWant]触发后回调。
  onNewWant(ability) {
    hilog.info(DOMAIN, TAG, 'AbilityLifecycleCallback onNewWant');
  },
  // 注册监听应用上下文的生命周期后，在UIAbility的[onNewWant]触发前回调。
  onWillNewWant(ability) {
    hilog.info(DOMAIN, TAG, 'AbilityLifecycleCallback onWillNewWant');
  },
  // 注册监听应用上下文的生命周期后，在UIAbility的[onCreate]触发前回调。
  onAbilityWillCreate(ability) {
    hilog.info(DOMAIN, TAG, 'AbilityLifecycleCallback onAbilityWillCreate');
  },
  // 注册监听应用上下文的生命周期后，在UIAbility的[onWindowStageCreate]触发前回调。
  onWindowStageWillCreate(ability, windowStage) {
    hilog.info(DOMAIN, TAG, 'AbilityLifecycleCallback onWindowStageWillCreate');
  },
  // 注册监听应用上下文的生命周期后，在UIAbility的[onWindowStageDestroy]触发前回调。
  onWindowStageWillDestroy(ability, windowStage) {
    hilog.info(DOMAIN, TAG, 'AbilityLifecycleCallback onWindowStageWillDestroy');
  },
  // 注册监听应用上下文的生命周期后，在UIAbility的[onDestroy]触发前回调。
  onAbilityWillDestroy(ability) {
    hilog.info(DOMAIN, TAG, 'AbilityLifecycleCallback onAbilityWillDestroy');
  },
  // 注册监听应用上下文的生命周期后，在UIAbility的[onForeground]触发前回调。
  onAbilityWillForeground(ability) {
    hilog.info(DOMAIN, TAG, 'AbilityLifecycleCallback onAbilityWillForeground');
  },
  // 注册监听应用上下文的生命周期后，在UIAbility的[onBackground]触发前回调。
  onAbilityWillBackground(ability) {
    hilog.info(DOMAIN, TAG, 'AbilityLifecycleCallback onAbilityWillBackground');
  },
  // 注册监听应用上下文的生命周期后，在UIAbility的[onSaveState]触发前回调。
  onAbilityWillSaveState(ability: UIAbility) {
    hilog.info(DOMAIN, TAG, 'AbilityLifecycleCallback onAbilityWillSaveState.');
  },
  // 注册监听应用上下文的生命周期后，在UIAbility的[onSaveState]触发后回调。
  onAbilitySaveState(ability: UIAbility) {
    hilog.info(DOMAIN, TAG, 'AbilityLifecycleCallback onAbilitySaveState.');
  }
};

export default class AbilityLifecycle extends UIAbility {
  onCreate() {
    hilog.info(DOMAIN, TAG, 'MyAbilityStage onCreate');

    // 1.通过context属性获取applicationContext
    let applicationContext = this.context.getApplicationContext();
    // 2.通过applicationContext注册监听应用内生命周期
    try {
      let lifecycleId = applicationContext.on('abilityLifecycle', abilityLifecycleCallback);
      GlobalContext.getContext().setObject('lifecycleId', lifecycleId);
      hilog.info(DOMAIN, TAG,
        `registerAbilityLifecycleCallback lifecycleId: ${GlobalContext.getContext().getObject('lifecycleId')}`);
    } catch (paramError) {
      hilog.error(DOMAIN, TAG, `error: ${paramError.code}, ${paramError.message}`);
    }
  }

  onWindowStageCreate(windowStage: window.WindowStage) {
    hilog.info(DOMAIN, TAG, 'onWindowStageCreate');

    let windowClass: window.Window | undefined = undefined;
    windowStage.getMainWindow((err: BusinessError, data) => {
      const errCode: number = err.code;
      if (errCode) {
        hilog.error(DOMAIN, TAG, `Failed to obtain the main window. Cause code: ${err.code}, message: ${err.message}`);
        return;
      }
      windowClass = data;
      let systemBarProperties: window.SystemBarProperties = {
        statusBarColor: '#f1f3f5',
        navigationBarColor: '#f1f3f5',
      };
      try {
        windowClass.setWindowSystemBarProperties(systemBarProperties, (err: BusinessError) => {
          const errCode: number = err.code;
          if (errCode) {
            hilog.error(DOMAIN, TAG,
              `Failed to set the system bar properties. Cause code: ${err.code}, message: ${err.message}`);
            return;
          }
          hilog.info(DOMAIN, TAG, 'Succeeded in setting the system bar properties.');
        });
      } catch (exception) {
        hilog.error(DOMAIN, TAG,
          `Failed to set the system bar properties. Cause code: ${exception.code}, message: ${exception.message}`);
      }
    });

    windowStage.loadContent('abilitypages/UIAbilityContext', (err, data) => {
      if (err.code) {
        return;
      }
    });
  }

  onBackground() {
    hilog.info(DOMAIN, TAG, 'onBackground');
  }

  onForeground() {
    hilog.info(DOMAIN, TAG, 'onBackground');
  }

  onPrepareToTerminate() {
    hilog.info(DOMAIN, TAG, 'onPrepareToTerminate');
    // 开发者定义预关闭动作
    // 例如拉起另一个ability，根据ability处理结果执行异步关闭
    let want: Want = {
      bundleName: 'com.samples.abilityruntime',
      abilityName: 'AbilityLifecycleAbility'
    }
    this.context.startAbilityForResult(want)
      .then((result) => {
        // 获取ability处理结果，当返回结果的resultCode为0关闭当前UIAbility
        hilog.info(DOMAIN, TAG, 'startAbilityForResult success, resultCode is ' + result.resultCode);
        if (result.resultCode === 0) {
          this.context.terminateSelf();
        }
      }).catch((err: BusinessError) => {
      // 异常处理
      hilog.error(DOMAIN, TAG, 'startAbilityForResult failed, err:' + JSON.stringify(err));
      this.context.terminateSelf();
    })

    return true; // 已定义预关闭操作后，返回true表示UIAbility取消关闭
  }

  onWindowStageWillDestroy(windowStage: window.WindowStage) {
    hilog.info(DOMAIN, TAG, 'onWindowStageWillDestroy');
  }

  onWindowStageRestore(windowStage: window.WindowStage) {
    hilog.info(DOMAIN, TAG, 'onWindowStageRestore');
  }

  onSaveState(reason: AbilityConstant.StateType, wantParam: Record<string, Object>): AbilityConstant.OnSaveResult {
    // No need to save state
    hilog.info(DOMAIN, TAG, 'onSaveState');
    return AbilityConstant.OnSaveResult.ALL_REJECT;
  }

  onWindowStageDestroy() {
    hilog.info(DOMAIN, TAG, 'onWindowStageDestroy');
  }

  onDestroy() {
    let applicationContext = this.context.getApplicationContext();
    let lifecycleId = GlobalContext.getContext().getObject('lifecycleId') as number;
    try {
      // 3.通过applicationContext注销监听应用内生命周期
      applicationContext.off('abilityLifecycle', lifecycleId, (error) => {
        if (error && error.code !== 0) {
          hilog.error(DOMAIN, TAG, `unregisterAbilityLifecycleCallback fail, error: ${JSON.stringify(error)}`);
        } else {
          hilog.info(DOMAIN, TAG, 'unregisterAbilityLifecycleCallback success.');
        }
      });
    } catch (paramError) {
      hilog.error(DOMAIN, TAG,
        `error: ${(paramError as BusinessError).code}, ${(paramError as BusinessError).message}`);
    }
  }
}