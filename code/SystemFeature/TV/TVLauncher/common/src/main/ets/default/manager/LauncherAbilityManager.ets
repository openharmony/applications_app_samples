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

import { bundleMonitor, installer, launcherBundleManager } from '@kit.AbilityKit';
import { osAccount, BusinessError } from '@kit.BasicServicesKit';
import { hiSysEvent } from '@kit.PerformanceAnalysisKit';
import { Log } from '../utils/Log';
import { CheckEmptyUtils } from '../utils/CheckEmptyUtils';
import { AppItemInfo } from '../bean/AppItemInfo';
import { CommonConstants } from '../constants/CommonConstants';
import { ResourceManager } from './ResourceManager';
import { EventConstants } from '../constants/EventConstants';

const TAG = 'LauncherAbilityManager';

interface StartAbilitySysEventParams {
  BUNDLE_NAME: string;
  ABILITY_NAME: string;
  MODULE_NAME: string;
}

interface StartAbilitySysEventInfo {
  domain: string;
  name: string;
  eventType: hiSysEvent.EventType;
  params: StartAbilitySysEventParams;
}

interface BundleStatusCallback {
  add: (bundleName: string, userId: number) => void;
  remove: (bundleName: string, userId: number) => void;
  update: (bundleName: string, userId: number) => void;
}

/**
 * Wrapper class for innerBundleManager and formManager interfaces.
 */
class LauncherAbilityManager {
  private static readonly CURRENT_USER_ID = -2;
  private readonly mAppMap = new Map<string, AppItemInfo>();
  private mUserId: number = 100;

  private readonly mBundleStatusCallback: BundleStatusCallback = {
    add: (bundleName: string, userId: number) => {
      Log.showDebug(TAG,
        `mBundleStatusCallback add bundleName: ${bundleName}, userId: ${userId}, mUserId ${this.mUserId}`
      );
      if (this.mUserId == userId) {
        this.notifyLauncherAbilityChange(EventConstants.EVENT_PACKAGE_ADDED, bundleName, userId);
      }
    },
    remove: (bundleName: string, userId: number) => {
      Log.showDebug(TAG,
        `mBundleStatusCallback remove bundleName: ${bundleName}, userId: ${userId}, mUserId ${this.mUserId}`
      );
      if (this.mUserId == userId) {
        this.notifyLauncherAbilityChange(EventConstants.EVENT_PACKAGE_REMOVED, bundleName, userId);
      }
    },
    update: (bundleName: string, userId: number) => {
      Log.showDebug(TAG,
        `mBundleStatusCallback update bundleName: ${bundleName}, userId: ${userId}, mUserId ${this.mUserId}`
      );
      if (this.mUserId == userId) {
        this.notifyLauncherAbilityChange(EventConstants.EVENT_PACKAGE_CHANGED, bundleName, userId);
      }
    }
  };

  private readonly mLauncherAbilityChangeListeners: Array<
    (event: string, bundleName: string, userId: number) => void
  > = [];

  /**
   * Get desktop application information management object
   *
   * @return Desktop application information management object instance
   */
  static getInstance(): LauncherAbilityManager {
    if (globalThis.LauncherAbilityManagerInstance == null) {
      globalThis.LauncherAbilityManagerInstance = new LauncherAbilityManager();
    }
    return globalThis.LauncherAbilityManagerInstance;
  }

  private constructor() {
    const osAccountManager = osAccount.getAccountManager();
    osAccountManager.getOsAccountLocalId((err, localId) => {
      Log.showDebug(TAG, `getOsAccountLocalIdFromProcess localId ${localId}`);
      this.mUserId = localId;
    });
  }

  getUserId(): number {
    return this.mUserId;
  }

  /**
   * Monitor system application status.
   *
   * @params listener: listening object
   */
  registerLauncherAbilityChangeListener(
    listener: ((event: string, bundleName: string, userId: number) => void) | null
  ): void {
    if (listener != null) {
      if (this.mLauncherAbilityChangeListeners.length == 0) {
        try {
          bundleMonitor.on('add', (bundleChangeInfo) => {
            Log.showInfo(TAG, `add bundleName: ${bundleChangeInfo.bundleName} userId: ${bundleChangeInfo.userId}`);
            this.mBundleStatusCallback.add(bundleChangeInfo.bundleName, bundleChangeInfo.userId);
          });
          bundleMonitor.on('update', (bundleChangeInfo) => {
            Log.showInfo(TAG, `update bundleName: ${bundleChangeInfo.bundleName} userId: ${bundleChangeInfo.userId}`);
            this.mBundleStatusCallback.update(bundleChangeInfo.bundleName, bundleChangeInfo.userId);
          });
          bundleMonitor.on('remove', (bundleChangeInfo) => {
            Log.showInfo(TAG, `remove bundleName: ${bundleChangeInfo.bundleName} userId: ${bundleChangeInfo.userId}`);
            this.mBundleStatusCallback.remove(bundleChangeInfo.bundleName, bundleChangeInfo.userId);
          });
          Log.showInfo(TAG, `registerCallback success`);
        } catch (errData) {
          let message = (errData as BusinessError).message;
          let errCode = (errData as BusinessError).code;
          Log.showError(TAG, `registerCallback fail errCode:${errCode}, message:${message}`);
        }
      }
      const index = this.mLauncherAbilityChangeListeners.indexOf(listener);
      if (index == CommonConstants.INVALID_VALUE) {
        this.mLauncherAbilityChangeListeners.push(listener);
      }
    }
  }

  /**
   * Cancel monitoring system application status.
   *
   * @params listener: listening object
   */
  unregisterLauncherAbilityChangeListener(
    listener: ((event: string, bundleName: string, userId: number) => void) | null
  ): void {
    if (listener != null) {
      const index = this.mLauncherAbilityChangeListeners.indexOf(listener);
      if (index != CommonConstants.INVALID_VALUE) {
        this.mLauncherAbilityChangeListeners.splice(index, 1);
      }
      if (this.mLauncherAbilityChangeListeners.length == 0) {
        try {
          bundleMonitor.off('add');
          bundleMonitor.off('update');
          bundleMonitor.off('remove');
          Log.showInfo(TAG, 'unregisterCallback success');
        } catch (errData) {
          let message = (errData as BusinessError).message;
          let errCode = (errData as BusinessError).code;
          Log.showError(TAG, `unregisterCallback fail errCode:${errCode}, message:${message}`);
        }
      }
    }
  }

  private notifyLauncherAbilityChange(event: string, bundleName: string, userId: number): void {
    const listeners = this.mLauncherAbilityChangeListeners;
    for (let index = 0; index < listeners.length; index++) {
      listeners[index](event, bundleName, userId);
    }
  }

  /**
   * get all app List info from BMS
   */
  async getLauncherAbilityList(): Promise<AppItemInfo[]> {
    let abilityList: launcherBundleManager.LauncherAbilityInfo[] = [];
    await launcherBundleManager.getAllLauncherAbilityInfo(LauncherAbilityManager.CURRENT_USER_ID)
      .then((res) => {
        abilityList = res;
      })
      .catch((err: BusinessError) => {
        Log.showError(TAG, `getLauncherAbilityList error: ${JSON.stringify(err)}`);
      });
    const appItemInfoList: AppItemInfo[] = [];
    if (CheckEmptyUtils.isEmpty(abilityList)) {
      Log.showDebug(TAG, 'getLauncherAbilityList Empty');
      return appItemInfoList;
    }
    for (const abilityInfo of abilityList) {
      let appItem = await this.convertToAppItemInfo(abilityInfo);
      appItemInfoList.push(appItem);
    }
    return appItemInfoList;
  }

  async getAppInfoWithBundleNames(orderBundleNames: string[]): Promise<AppItemInfo[]> {
    let abilityList: launcherBundleManager.LauncherAbilityInfo[] = [];
    await launcherBundleManager.getAllLauncherAbilityInfo(LauncherAbilityManager.CURRENT_USER_ID)
      .then((res) => {
        abilityList = res;
      })
      .catch((err: BusinessError) => {
        Log.showError(TAG, `getLauncherAbilityList error: ${JSON.stringify(err)}`);
      });
    let appItemInfoList: AppItemInfo[] = [];

    const bundleNameSet = new Set<string>(orderBundleNames);
    const sourceList = abilityList;
    abilityList = sourceList.filter((item: launcherBundleManager.LauncherAbilityInfo) => {
      return bundleNameSet.has(item.elementName.bundleName);
    });

    if (CheckEmptyUtils.isEmpty(abilityList)) {
      Log.showDebug(TAG, 'getLauncherAbilityList Empty');
      return appItemInfoList;
    }

    for (const abilityInfo of abilityList) {
      let appItem = await this.convertToAppItemInfo(abilityInfo);
      appItemInfoList.push(appItem);
    }
    return appItemInfoList;
  }



  /**
   * get AbilityInfos by bundleName from BMS
   *
   * @params bundleName Application package name
   * @return List of entry capabilities information of the target application
   */
  async getLauncherAbilityInfo(bundleName: string): Promise<AppItemInfo[]> {
    let abilityInfos: launcherBundleManager.LauncherAbilityInfo[] = [];
    await launcherBundleManager.getLauncherAbilityInfo(bundleName, this.mUserId)
      .then((res) => {
        abilityInfos = res;
      })
      .catch((err: BusinessError) => {
        Log.showError(TAG, `getLauncherAbilityInfo error: ${JSON.stringify(err)}`);
      });
    const appItemInfoList: AppItemInfo[] = [];
    if (CheckEmptyUtils.isEmpty(abilityInfos)) {
      Log.showDebug(TAG, 'getLauncherAbilityInfo Empty');
      return appItemInfoList;
    }
    for (const abilityInfo of abilityInfos) {
      let appItem = await this.convertToAppItemInfo(abilityInfo);
      appItemInfoList.push(appItem);
    }
    return appItemInfoList;
  }

  /**
   * get AppItemInfo from BMS with bundleName
   * @params bundleName
   * @return AppItemInfo
   */
  async getAppInfoByBundleName(bundleName: string, abilityName?: string): Promise<AppItemInfo | undefined> {
    let appItemInfo: AppItemInfo | undefined = undefined;
    // get from cache
    if (this.mAppMap != null && this.mAppMap.has(bundleName)) {
      appItemInfo = this.mAppMap.get(bundleName);
    }
    if (appItemInfo != undefined) {
      return appItemInfo;
    }
    // get from system
    let abilityInfos: launcherBundleManager.LauncherAbilityInfo[] = [];
    await launcherBundleManager.getLauncherAbilityInfo(bundleName, LauncherAbilityManager.CURRENT_USER_ID)
      .then((res)=>{
        if (res != undefined) {
          abilityInfos = res;
        }
      })
      .catch((err: BusinessError)=>{
        Log.showError(TAG, `getAppInfoByBundleName launcherBundleManager getLauncherAbilityInfos error: ${JSON.stringify(err)}`);
      });

    if (abilityInfos == undefined || abilityInfos.length == 0) {
      Log.showDebug(TAG, `${bundleName} has no launcher ability`);
      return undefined;
    }
    let appInfo: launcherBundleManager.LauncherAbilityInfo | undefined = abilityInfos[0];
    if (abilityName != undefined) {
      appInfo = abilityInfos.find(item => {
        return item.elementName.abilityName === abilityName;
      });
    }
    if (appInfo == undefined) {
      return undefined;
    }
    const data = await this.convertToAppItemInfo(appInfo);
    return data;
  }

  private async convertToAppItemInfo(info: launcherBundleManager.LauncherAbilityInfo): Promise<AppItemInfo> {
    const appItemInfo = new AppItemInfo();
    const bundleName: string = info.elementName.bundleName ?? '';
    const moduleName: string = info.elementName.moduleName ?? '';
    const abilityName: string = info.elementName.abilityName ?? '';
    const appLabel: string = info.applicationInfo.label ?? '';
    appItemInfo.appName = await ResourceManager.getInstance().getAppNameSync(
      info.labelId, bundleName, moduleName, appLabel
    );
    appItemInfo.isSystemApp = info.applicationInfo.systemApp;
    appItemInfo.isUninstallAble = info.applicationInfo.removable;
    appItemInfo.appIconId = info.iconId;
    appItemInfo.appLabelId = info.labelId;
    appItemInfo.bundleName = bundleName;
    appItemInfo.abilityName = abilityName;
    appItemInfo.moduleName = moduleName;
    appItemInfo.keyName =
      bundleName + abilityName + moduleName;
    appItemInfo.typeId = CommonConstants.TYPE_APP;
    appItemInfo.installTime = String(new Date());
    // appItemInfo.badgeNumber = await BadgeManager.getInstance().getBadgeByBundleSync(info.elementName.bundleName);
    await ResourceManager.getInstance()
      .updateIconCache(appItemInfo.appIconId, appItemInfo.bundleName, appItemInfo.moduleName);
    this.mAppMap.set(appItemInfo.bundleName, appItemInfo);
    return appItemInfo;
  }

  /**
   * uninstall application, notice the userId need to be the login user
   *
   * @params bundleName application bundleName
   * @params callback to get result
   */
  async uninstallLauncherAbility(bundleName: string, callback: (resultCode: number) => void): Promise<void> {
    Log.showInfo(TAG, `uninstallLauncherAbility bundleName: ${bundleName}`);
    try {
      const bundlerInstaller = await installer.getBundleInstaller();
      bundlerInstaller.uninstall(bundleName, {
        userId: this.mUserId,
        installFlag: 0,
        isKeepData: false
      }, (err: BusinessError) => {
        if (err) {
          callback(CommonConstants.INVALID_VALUE);
          Log.showError(TAG, `uninstallLauncherAbility failed: ${JSON.stringify(err)}`);
        } else {
          callback(CommonConstants.UNINSTALL_SUCCESS);
          Log.showDebug(TAG, `uninstallLauncherAbility successfully: ${JSON.stringify(err)}`);
        }
      });
    } catch (err) {
      let errCode = (err as BusinessError).code;
      let errMsg = (err as BusinessError).message;
      Log.showError(TAG, `uninstallLauncherAbility errCode: ${errCode}, errMsg: ${errMsg}`);
    }
  }

  /**
   * start the app
   *
   * @params paramAbilityName: Ability name
   * @params paramBundleName: Application package name
   */
  startLauncherAbility(paramAbilityName: string, paramBundleName: string, paramModuleName: string,
    allBundleNames?: string[]) {
    globalThis.desktopContext.startAbility({
      bundleName: paramBundleName,
      abilityName: paramAbilityName,
      moduleName: paramModuleName,
      parameters: { bundleNames: allBundleNames }
    }).then(() => {
      Log.showDebug(TAG, 'startApplication promise success');
    }, (err: BusinessError) => {
      Log.showError(TAG, `startApplication promise error: ${JSON.stringify(err)}`);
    });

    const sysEventInfo: StartAbilitySysEventInfo = {
      domain: 'LAUNCHER_APP',
      name: 'START_ABILITY',
      eventType: hiSysEvent.EventType.BEHAVIOR,
      params: {
        'BUNDLE_NAME': paramBundleName,
        'ABILITY_NAME': paramAbilityName,
        'MODULE_NAME': paramModuleName
      }
    };
    hiSysEvent.write(sysEventInfo,
      (err: BusinessError) => {
        if (err) {
          Log.showError(TAG, `startApplication hiSysEvent write error: ${err.code}`);
        } else {
          Log.showDebug(TAG, 'startApplication hiSysEvent write success');
        }
    })
  }

  /**
   * start form config ability
   *
   * @params paramAbilityName
   * @params paramBundleName
   */
  startAbilityFormEdit(
    paramAbilityName: string, paramBundleName: string, paramModuleName: string, paramCardId: number
  ) {
    Log.showDebug(
      TAG,
      `startAbility abilityName: ${paramAbilityName},bundleName: ${paramBundleName}, ` +
      `moduleName: ${paramModuleName} ,paramCardId: ${paramCardId}`
    );
    globalThis.desktopContext.startAbility({
      bundleName: paramBundleName,
      abilityName: paramAbilityName,
      moduleName: paramModuleName,
      parameters:
        {
          formId: paramCardId.toString()
        }
    }).then((ret: object) => {
      Log.showDebug(TAG, `startAbility ret: ${JSON.stringify(ret)}`);
    }, (err: BusinessError) => {
      Log.showError(TAG, `startAbility catch error: ${JSON.stringify(err)}`);
    });
  }

  async getShortcutInfo(
    paramBundleName: string, callback: (bundleName: string, shortcutInfo: launcherBundleManager.ShortcutInfo[]) => void
  ) {
    Log.showDebug(TAG, `getShortcutInfo bundleName: ${paramBundleName}`);
    await launcherBundleManager.getShortcutInfo(paramBundleName)
      .then((shortcutInfo: launcherBundleManager.ShortcutInfo[]) => {
        callback(paramBundleName, shortcutInfo);
      })
      .catch((_err: BusinessError) => {
      });
  }

  /**
   * start application by uri
   *
   * @params paramBundleName application bundle name
   * @params paramAbilityName application abilit uri
   */
  startLauncherAbilityByUri(paramBundleName: string, abilityUri: string) {
    Log.showInfo(TAG, `startLauncherAbilityByUri bundleName:${paramBundleName} abilityUri:${abilityUri}`);
    const result: Promise<void> = globalThis.desktopContext.startAbility({
      bundleName: paramBundleName,
      uri: abilityUri
    }).then(() => {
      Log.showDebug(TAG, 'startLauncherAbilityByUri promise success');
    }, (err: BusinessError) => {
      Log.showError(TAG, `startLauncherAbilityByUri promise error: ${JSON.stringify(err)}`);
    });
    Log.showDebug(TAG, `startLauncherAbilityByUri AceApplication : startAbility : ${result}`);
  }
}

export const launcherAbilityManager = LauncherAbilityManager.getInstance();
