//@ts-nocheck
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
 

import getSingleInstance from '../../../../../../../common/src/main/ets/default/SingleInstanceHelper';
import TintStateManager, { TintState, TintStateListener
} from '../../../../../../../common/src/main/ets/default/TintStateManager';
import { NavigationBarComponentData, NAVIGATIONBAR_HIDE_EVENT } from '../common/constants';
import { featureAbility } from '@kit.AbilityKit';
import { DataAbilityHelper } from 'ability/dataAbilityHelper';
import { settings } from '@kit.BasicServicesKit';
import { commonEventManager } from '@kit.BasicServicesKit';
import AbilityManager from '../../../../../../../common/src/main/ets/default/abilitymanager/AbilityManager';
import CommonConstants from '../../../../../../../common/src/main/ets/default/Constants';

import Log from '@ohos/common/src/main/ets/default/Log';
import WindowManager,{WindowType} from '@ohos/common/src/main/ets/default/WindowManager'

const TAG = 'NavigationBarViewModel';

const NAVIGATION_BAE_VIEW_MODEL_KEY = 'AppStorage_NavigationBarViewModel';

const NAVIGATION_BAR_COMPONENT_DATA_KEY = 'AppStorage_NavigationBarComponentData';

// NavigationBarViewModel 通过监听 Settings 数据库中的 navigationbar_status 字段来决定导航栏的显示与隐藏。
// 之所以用 DataAbilityHelper 而非直接读取，是为了能在设置变更时实时收到回调，
// 支持手势导航与三键导航之间的运行时无缝切换，无需重启 SystemUI。
export default class NavigationBarViewModel {
  private readonly settingDataKey = 'settings.display.navigationbar_status';
  private readonly urivar: string;
  private readonly helper: DataAbilityHelper;
  private readonly navigationBarStatusDefaultValue = '1';
  private isDisplay = true;
  public mNavigationBarComponentData: NavigationBarComponentData  = {
    ...new NavigationBarComponentData()
  };
  public mUseCount = 0;

  static getInstance(): NavigationBarViewModel {
    return getSingleInstance(NavigationBarViewModel, NAVIGATION_BAE_VIEW_MODEL_KEY);
  }

  constructor() {
    Log.showInfo(TAG, 'constructor');
    this.mNavigationBarComponentData =
    AppStorage.setAndLink(NAVIGATION_BAR_COMPONENT_DATA_KEY, this.mNavigationBarComponentData).get()
    this.urivar = settings.getUriSync(this.settingDataKey);
    if (AbilityManager.getContext(AbilityManager.ABILITY_NAME_NAVIGATION_BAR) == null) {
      Log.showError(TAG, 'AbilityManager.getContext() is null');
    } else {
      Log.showInfo(TAG, 'context: ' + AbilityManager.getContext(AbilityManager.ABILITY_NAME_NAVIGATION_BAR));
    }
    this.helper = featureAbility.acquireDataAbilityHelper(CommonConstants.URI_VAR);
    this.initNavigationBarStatus();
  }

  // install/uninstall 使用引用计数（mUseCount）而非简单布尔值，
  // 是因为导航栏页面可能被多个宿主同时持有（如分屏场景），
  // 只有最后一个宿主卸载时才真正注销 TintState 监听，防止提前注销导致主题色失效。
  install(): void {
    Log.showDebug(TAG, `install, useCount: ${this.mUseCount}`);
    if (!this.mUseCount) {
      TintStateManager.getInstance().registerListener('navigation', this as TintStateListener);
    }
    this.mUseCount++;
  }

  uninstall(): void {
    Log.showDebug(TAG, `uninstall, useCount: ${this.mUseCount}`);
    this.mUseCount--;
    if (this.mUseCount) {
      TintStateManager.getInstance().unregisterListener('navigation');
    }
  }

  getNavigationBarComponentData(): NavigationBarComponentData {
    Log.showDebug(TAG, 'getNavigationBarComponentData');
    return this.mNavigationBarComponentData;
  }

  // TintState 由全屏应用（如视频播放器）下发，用于通知 SystemUI 切换导航栏前景色，
  // 避免白色图标在白色背景上不可见。TV 场景下此回调还控制窗口可见性，
  // 全屏播放时完全隐藏导航栏以保证沉浸式体验。
  onTintStateChange(tintState: TintState): void {
    Log.showDebug(TAG, `onTintStateChange, tintState: ${JSON.stringify(tintState)}`);
    if (typeof (tintState.isEnable) == 'boolean') {
      this.setWindowEnable(tintState.isEnable);
    }
    if (tintState.backgroundColor) {
      this.mNavigationBarComponentData.backgroundColor = tintState.backgroundColor;
    }
    if (tintState.contentColor) {
      this.mNavigationBarComponentData.contentColor = tintState.contentColor;
    }
    Log.showDebug(TAG, `onTintStateChange, backgroundColor ${this.mNavigationBarComponentData.backgroundColor},
      contentColor ${this.mNavigationBarComponentData.contentColor}`);
  }

  setWindowEnable(isEnable: boolean): void {
    Log.showDebug(TAG, `setWindowEnable, isEnable ${String(isEnable)}`);
    if (this.mNavigationBarComponentData.isEnable == isEnable) {
      return;
    }
    this.mNavigationBarComponentData.isEnable = isEnable;
    if (isEnable && this.isDisplay) {
      WindowManager.showWindow(WindowType.NAVIGATION_BAR).then(() => {
      }).catch((err) => {
      });
    } else {
      WindowManager.hideWindow(WindowType.NAVIGATION_BAR).then(() => {
      }).catch((err) => {
      });
    }
  }

  // setValue/getValue/registerListenForDataChanges 三者构成对 Settings 数据库的完整读写订阅闭环，
  // 将 navigationbar_status 的变更（如用户在设置中切换导航模式）实时反映到窗口状态，
  // 无需重启 SystemUI 进程即可完成导航栏的动态开关。
  private setValue(value: string): void {
    settings.setValueSync(this.helper, this.settingDataKey, value);
  }

  private getValue(defaultValue?: string): string {
    return settings.getValueSync(
      this.helper, this.settingDataKey, defaultValue ? defaultValue : this.navigationBarStatusDefaultValue
    );
  }

  private registerListenForDataChanges(callback: (data) => void): void {
    this.helper.on('dataChange', this.urivar, (data) => {
      callback(data);
    });
  }

  /**
   * Initialize the NavigationBar status.
   */
  initNavigationBarStatus(): void {
    try {
      let initValue = this.getValue();
      Log.showInfo(TAG, `initNavigationBarStatus initValue ${initValue}`);
      this.windowSwitches(initValue);
      this.registerListenForDataChanges(this.dataChangesCallback.bind(this));
    } catch (e) {
      Log.showError(TAG, `initNavigationBarStatus error:  ${e.toString()}`);
    }
  }

  /**
   * Get NavigationBar status data.
   * @return
   */
  dataChangesCallback(data): void {
    if (data.code !== 0) {
      Log.showError(TAG, `dataChangesCallback failed, because ${data.message}`);
      return;
    } else {
      let getRetValue = this.getValue();
      Log.showInfo(TAG, `dataChangesCallback initValue ${getRetValue}`);
      this.windowSwitches(getRetValue);
    }
  }

  // 切换到手势导航时，必须先隐藏导航栏再向 Launcher 发布广播，
  // 保证 Launcher 收到通知时导航栏窗口已完全隐藏，防止 Dock 栏上移动画与导航栏同帧出现造成视觉闪烁。
  private windowSwitches(navigationBarStatusValue: string): void {
    this.isDisplay = navigationBarStatusValue == '1' ? true : false;
    if (!this.isDisplay) {
      //For gesture navigation scenarios
      //Systemui hides the navigation bar,and then notifies the launcher that it can start moving down the dock bar.
      WindowManager.hideWindow(WindowType.NAVIGATION_BAR).then(() => {
        commonEventManager.publish(NAVIGATIONBAR_HIDE_EVENT, (err) => {
          if (err.code) {
            Log.showError(TAG, `${NAVIGATIONBAR_HIDE_EVENT} PublishCallBack err: ${JSON.stringify(err)}`);
          } else {
            Log.showInfo(TAG, `${NAVIGATIONBAR_HIDE_EVENT} Publish sucess`);
          }
        })
      }).catch((err) => {
        Log.showError(TAG, `${NAVIGATIONBAR_HIDE_EVENT} Publish catch err: ${JSON.stringify(err)}`);
      });
    } else {
      WindowManager.showWindow(WindowType.NAVIGATION_BAR).then(() => {
      }).catch((err) => {
      });
    }
  }
}
