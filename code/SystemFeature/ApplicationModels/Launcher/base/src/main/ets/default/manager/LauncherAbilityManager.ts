/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
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

import bundleMgr from '@ohos.bundle'
import launcherBundleManager from '@ohos.bundle.launcherBundleManager';
import bundleMonitor from '@ohos.bundle.bundleMonitor';
import osAccount from '@ohos.account.osAccount'
import { AppItemInfo } from '../bean/AppItemInfo'
import { CheckEmptyUtils } from '../utils/CheckEmptyUtils'
import { CommonConstants } from '../constants/CommonConstants'
import { EventConstants } from '../constants/EventConstants'
import { ResourceManager } from './ResourceManager'
import { Logger } from '../utils/Logger'

const TAG: string = 'LauncherAbilityManager'

/**
 * Wrapper class for innerBundleManager and formManager interfaces.
 */
export class LauncherAbilityManager {
  private static readonly BUNDLE_STATUS_CHANGE_KEY_REMOVE = 'remove'
  private static readonly BUNDLE_STATUS_CHANGE_KEY_ADD = 'add'
  private static launcherAbilityManager: LauncherAbilityManager = undefined
  private readonly mAppMap = new Map<string, AppItemInfo>()
  private mResourceManager: ResourceManager = undefined
  private readonly mLauncherAbilityChangeListeners: any[] = []
  private mUserId: number = 100
  private context: any = undefined

  constructor(context) {
    this.context = context
    this.mResourceManager = ResourceManager.getInstance(context)
    const osAccountManager = osAccount.getAccountManager()
    osAccountManager.getOsAccountLocalIdFromProcess((err, localId) => {
      Logger.debug(TAG, `getOsAccountLocalIdFromProcess localId ${localId}`)
      this.mUserId = localId
    })
  }

  /**
   * Get the application data model object.
   *
   * @return {object} application data model singleton
   */
  static getInstance(context): LauncherAbilityManager {
    if (this.launcherAbilityManager === null || this.launcherAbilityManager === undefined) {
      this.launcherAbilityManager = new LauncherAbilityManager(context)
    }
    return this.launcherAbilityManager
  }

  /**
   * get all app List info from BMS
   *
   * @return 应用的入口Ability信息列表
   */
  async getLauncherAbilityList(): Promise<AppItemInfo[]> {
    Logger.info(TAG, 'getLauncherAbilityList begin')
    let abilityList = await launcherBundleManager.getAllLauncherAbilityInfo(this.mUserId)
    const appItemInfoList = new Array<AppItemInfo>()
    if (CheckEmptyUtils.isEmpty(abilityList)) {
      Logger.info(TAG, 'getLauncherAbilityList Empty')
      return appItemInfoList
    }
    for (let i = 0; i < abilityList.length; i++) {
      let appItem = await this.transToAppItemInfo(abilityList[i])
      appItemInfoList.push(appItem)
    }
    return appItemInfoList
  }

  /**
   * get AppItemInfo from BMS with bundleName
   * @params bundleName
   * @return AppItemInfo
   */
  async getAppInfoByBundleName(bundleName: string): Promise<AppItemInfo | undefined> {
    let appItemInfo: AppItemInfo | undefined = undefined
    // get from cache
    if (this.mAppMap != null && this.mAppMap.has(bundleName)) {
      appItemInfo = this.mAppMap.get(bundleName)
    }
    if (appItemInfo != undefined) {
      Logger.info(TAG, `getAppInfoByBundleName from cache: ${JSON.stringify(appItemInfo)}`)
      return appItemInfo
    }
    // get from system
    let abilityInfos = await launcherBundleManager.getLauncherAbilityInfo(bundleName, this.mUserId)
    if (abilityInfos == undefined || abilityInfos.length == 0) {
      Logger.info(TAG, `${bundleName} has no launcher ability`)
      return undefined
    }
    let appInfo = abilityInfos[0]
    const data = await this.transToAppItemInfo(appInfo)
    Logger.info(TAG, `getAppInfoByBundleName from BMS: ${JSON.stringify(data)}`)
    return data
  }

  private async transToAppItemInfo(info): Promise<AppItemInfo> {
    const appItemInfo = new AppItemInfo()
    appItemInfo.appName = await this.mResourceManager.getAppNameSync(
    info.labelId, info.elementName.bundleName, info.applicationInfo.label
    )
    appItemInfo.isSystemApp = info.applicationInfo.systemApp
    appItemInfo.isUninstallAble = info.applicationInfo.removable
    appItemInfo.appIconId = info.iconId
    appItemInfo.appLabelId = info.labelId
    appItemInfo.bundleName = info.elementName.bundleName
    appItemInfo.abilityName = info.elementName.abilityName
    await this.mResourceManager.updateIconCache(appItemInfo.appIconId, appItemInfo.bundleName)
    this.mAppMap.set(appItemInfo.bundleName, appItemInfo)
    return appItemInfo
  }


  /**
   * 启动应用
   *
   * @params paramAbilityName Ability名
   * @params paramBundleName 应用包名
   */
  startLauncherAbility(paramAbilityName, paramBundleName) {
    Logger.info(TAG, `startApplication abilityName: ${paramAbilityName}, bundleName: ${paramBundleName}`)
    this.context.startAbility({
      bundleName: paramBundleName,
      abilityName: paramAbilityName
    }).then(() => {
      Logger.info(TAG, 'startApplication promise success')
    }, (err) => {
      Logger.error(TAG, `startApplication promise error: ${JSON.stringify(err)}`)
    })
  }

  /**
   * 卸载应用
   *
   * @params bundleName 应用包名
   * @params callback 卸载回调
   */
  async uninstallLauncherAbility(bundleName: string, callback): Promise<void> {
    Logger.info(TAG, `uninstallLauncherAbility bundleName: ${bundleName}`)
    const bundlerInstaller = await bundleMgr.getBundleInstaller()
    bundlerInstaller.uninstall(bundleName, {
      userId: this.mUserId,
      installFlag: 0,
      isKeepData: false
    }, (result) => {
      Logger.info(TAG, `uninstallLauncherAbility result => ${JSON.stringify(result)}`)
      callback(result)
    })
  }

  /**
   * 开始监听系统应用状态.
   *
   * @params listener 监听对象
   */
  registerLauncherAbilityChangeListener(listener: any): void {
    if (!CheckEmptyUtils.isEmpty(listener)) {
      if (this.mLauncherAbilityChangeListeners.length == 0) {
        bundleMonitor.on(LauncherAbilityManager.BUNDLE_STATUS_CHANGE_KEY_ADD, (bundleChangeInfo) => {
          Logger.debug(TAG, `mBundleStatusCallback add bundleName: ${bundleChangeInfo.bundleName},
            userId: ${bundleChangeInfo.userId}, mUserId ${this.mUserId}`)
          if (this.mUserId === bundleChangeInfo.userId) {
            this.notifyLauncherAbilityChange(EventConstants.EVENT_PACKAGE_ADDED,
              bundleChangeInfo.bundleName, bundleChangeInfo.userId)
          }
        })
        bundleMonitor.on(LauncherAbilityManager.BUNDLE_STATUS_CHANGE_KEY_REMOVE, (bundleChangeInfo) => {
          Logger.debug(TAG, `mBundleStatusCallback remove bundleName: ${bundleChangeInfo.bundleName},
            userId: ${bundleChangeInfo.userId}, mUserId ${this.mUserId}`)
          if (this.mUserId === bundleChangeInfo.userId) {
            this.notifyLauncherAbilityChange(EventConstants.EVENT_PACKAGE_REMOVED,
              bundleChangeInfo.bundleName, bundleChangeInfo.userId)
          }
        })
      }
      const index = this.mLauncherAbilityChangeListeners.indexOf(listener)
      if (index == CommonConstants.INVALID_VALUE) {
        this.mLauncherAbilityChangeListeners.push(listener)
      }
    }
  }

  /**
   * 取消监听系统应用状态.
   *
   * @params listener 监听对象
   */
  unregisterLauncherAbilityChangeListener(listener: any): void {
    if (!CheckEmptyUtils.isEmpty(listener)) {
      const index = this.mLauncherAbilityChangeListeners.indexOf(listener)
      if (index != CommonConstants.INVALID_VALUE) {
        this.mLauncherAbilityChangeListeners.splice(index, 1)
      }
      if (this.mLauncherAbilityChangeListeners.length == 0) {
        bundleMonitor.off(LauncherAbilityManager.BUNDLE_STATUS_CHANGE_KEY_ADD)
        bundleMonitor.off(LauncherAbilityManager.BUNDLE_STATUS_CHANGE_KEY_REMOVE)
      }
    }
  }

  private notifyLauncherAbilityChange(event: string, bundleName: string, userId: number): void {
    for (let index = 0; index < this.mLauncherAbilityChangeListeners.length; index++) {
      this.mLauncherAbilityChangeListeners[index](event, bundleName, userId)
    }
  }
}