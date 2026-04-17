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

import { deviceInfo } from '@kit.BasicServicesKit';
import { launcherAbilityManager } from '@ohos/common';
import { ResourceManager } from '@ohos/common/src/main/ets/default/manager/ResourceManager';
import { AppItemInfo } from '../../common/bean/AppItemInfo';
import PreferenceUtils from './PreferenceUtil';


const TAG: string = 'dockerAppStorage'

export const preferenceToken = 'shortcuts_preferences'

export class DockerAppStorage {
  // 前2个不可移动  前6个不可移除
  public static defaultOrderBundleNames: string[] =
    ['com.ohos.inputsource', 'com.ohos.demandplayer', 'com.funshion.launcher', 'com.ohos.settings', 'com.samples.album',
      'com.ohos.applicationmanager', 'com.samples.camera', 'ohos.samples.distributedmusicplayer']
  // 不可移动应用
  public static canNotMoveBundleNames: string[] = ['com.ohos.inputsource', 'com.ohos.demandplayer']
  //不可删除应用
  public static canNotRemoveBundleNames: string[] =
    ['com.ohos.inputsource', 'com.ohos.demandplayer', 'com.funshion.launcher', 'com.ohos.settings', 'com.samples.album',
      'com.ohos.applicationmanager']
  private preferenceUtils: PreferenceUtils<string> | undefined = undefined

  constructor() {
    console.log(TAG, `deviceInfo.productModel = ${deviceInfo.productModel}`);
    if (deviceInfo.productModel == 'Hi3751V352') {
      DockerAppStorage.defaultOrderBundleNames.splice(6, 1) // v352裁剪相机
    }

    this.preferenceUtils =
      new PreferenceUtils<string>(globalThis.desktopContext, DockerAppStorage.defaultOrderBundleNames.join())
  }

  private getOrderBundleNames(): string[] {
    let appBundleNames = this.preferenceUtils?.getPreValue(preferenceToken)
    let result = appBundleNames!.split(',')
    console.log(TAG, `getOrderBundleNames = ${result}}`)
    return result
  }

  public setOrderBundleNames(bundleNames: string[]) {
    let str = bundleNames.join()
    console.log(TAG, 'setOrderBundleNames : ' + str)
    this.preferenceUtils?.setPreValue(preferenceToken, bundleNames.join())
  }

  private static setCanMove(app: AppItemInfo) {
    let canMove = !DockerAppStorage.canNotMoveBundleNames.includes(app.bundleName!)
    app.canMove = canMove
  }

  private static setCanRemove(app: AppItemInfo) {
    let canRemove = !DockerAppStorage.canNotRemoveBundleNames.includes(app.bundleName!)
    app.canRemove = canRemove
  }

  private static setIcon(appItem: AppItemInfo) {
    switch (appItem.bundleName) {
      case 'com.ohos.inputsource':
        appItem.icon = '/common/pics/appList/icon_dtv.png'
        appItem.onFocusIcon = '/common/pics/appList/icon_dtv_onFocus.png'
        break
      case 'com.ohos.demandplayer':
        appItem.icon = '/common/pics/appList/icon_demand.png'
        appItem.onFocusIcon = '/common/pics/appList/icon_demand_onFocus.png'
        break
      case 'com.funshion.launcher':
        appItem.icon = '/common/pics/appList/icon_fengxing.png'
        appItem.onFocusIcon = '/common/pics/appList/icon_fengxing_onFocus.png'
        break
      case 'com.ohos.settings':
        appItem.icon = '/common/pics/appList/icon_settings.png'
        appItem.onFocusIcon = '/common/pics/appList/icon_settings_onFocus.png'
        break
      case 'com.samples.album':
        appItem.icon = '/common/pics/appList/icon_picView.png'
        appItem.onFocusIcon = '/common/pics/appList/icon_picView_onFocus.png'
        break
      case 'com.samples.camera':
        appItem.icon = '/common/pics/appList/icon_camera.png'
        appItem.onFocusIcon = '/common/pics/appList/icon_camera_onFocus.png'
        break
      case 'ohos.samples.distributedmusicplayer':
        appItem.icon = '/common/pics/appList/icon_music.png'
        appItem.onFocusIcon = '/common/pics/appList/icon_music_onFocus.png'
        break
      case 'ohos.samples.browser1':
        appItem.icon = '/common/pics/appList/icon_browser.png'
        appItem.onFocusIcon = '/common/pics/appList/icon_browser_onFocus.png'
        break
      case 'com.ohos.applicationmanager':
        appItem.icon = '/common/pics/appList/icon_apps.png'
        appItem.onFocusIcon = '/common/pics/appList/icon_apps_onFocus.png'
        break
      case 'tv.fun.appstore':
        appItem.icon = '/common/pics/appList/icon_chengzi.png'
        appItem.onFocusIcon = '/common/pics/appList/icon_chengzi_onFocus.png'
        break
      case 'com.ohos.file.manager':
        appItem.icon = '/common/pics/appList/icon_file.png'
        appItem.onFocusIcon = '/common/pics/appList/icon_file_onFocus.png'
        break
      case 'com.huawei.ohos.connect':
        appItem.icon = '/common/pics/appList/icon_connect.png'
        appItem.onFocusIcon = '/common/pics/appList/icon_connect_onFocus.png'
        break
      case 'com.laval.betaclub':
        appItem.icon = '/common/pics/appList/icon_betaclub.png'
        appItem.onFocusIcon = '/common/pics/appList/icon_betaclub_onFocus.png'
        break
    }
  }

  static appInit(app: AppItemInfo) {
    DockerAppStorage.setCanMove(app)
    DockerAppStorage.setCanRemove(app)
    DockerAppStorage.setIcon(app)
    if (!app.icon) {
      const appIconId: number = app.appIconId ?? 0
      const bundleName: string = app.bundleName ?? ''
      const moduleName: string = app.moduleName ?? ''
      ResourceManager.getInstance()
        .getAppIconWithCache(appIconId, bundleName, moduleName, '/common/pics/appList/icon_apps.svg',
          (iconString: string | null) => {
            console.log(TAG, app.bundleName + ' getAppIconWithCache ' + (iconString ? iconString.length : 0));
            if (!iconString) {
              return
            }
            app.icon = iconString
            app.onFocusIcon = iconString
            app.useSelfIcon = true
          })
    }
  }

  async getDockerAppItemInfos(): Promise<AppItemInfo[]> {
    let orderBundleNames = this.getOrderBundleNames()
    // TODO 可能需要校验应用是否都存在
    let orderApps: AppItemInfo[] = []
    let apps = await launcherAbilityManager.getAppInfoWithBundleNames(orderBundleNames)

    orderBundleNames.forEach(bundleName => {
      let commonApp = apps.find(item => bundleName == item.bundleName)
      if (commonApp) {
        let app = new AppItemInfo()
        app.cover(commonApp)
        DockerAppStorage.appInit(app)
        orderApps.push(app)
      }
    })
    // 最新的docker bundlename排序
    let latestOrderBundleNames = orderApps.map(o => o.bundleName!)
    this.setOrderBundleNames(latestOrderBundleNames)

    console.log(TAG, `orderApps = ${orderApps.map(o => o.appName + ' ' + o.bundleName)}`)
    return orderApps
  }
}

let dockerAppStorage: DockerAppStorage = new DockerAppStorage()

export default dockerAppStorage