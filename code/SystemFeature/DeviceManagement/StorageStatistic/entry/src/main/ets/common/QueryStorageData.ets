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

import bundle from '@ohos.bundle.bundleManager'
import storageStatistics from '@ohos.file.storageStatistics'
import { AppData } from '../model/AppData'
import CheckEmptyUtils from '../utils/CheckEmptyUtils'
import Logger from '../utils/Logger'
import ParseData from '../common/ParseData'
import { StorageData } from '../model/StorageData'

const TAG: string = 'QueryStorageData'

export class QueryStorageData {
  // Size data may get 0, so set -1 as default value
  public totalSize: number = -1
  public freeSize: number = -1
  public itemSizeList: number[] = []
  public appDataList: AppData[] = []
  public classifiedDataList: StorageData[] = []
  private context: any = getContext(this) as any

  private async initClassifiedDataList() {
    this.classifiedDataList = []
    let storageStats: storageStatistics.StorageStats = await storageStatistics.getUserStorageStats()
    this.classifiedDataList.push({
      name: $r('app.string.query_data_application'),
      size: storageStats.app,
      color: '#F9A20F',
    })
    this.classifiedDataList.push({
      name: $r('app.string.query_data_audio'),
      size: storageStats.audio,
      color: '#F2400A'
    })
    this.classifiedDataList.push({
      name: $r('app.string.query_data_video'),
      size: storageStats.video,
      color: '#E65392'
    })
    this.classifiedDataList.push({
      name: $r('app.string.query_data_image'),
      size: storageStats.image,
      color: '#A12DF7' })
    this.classifiedDataList.push({
      name: $r('app.string.query_data_file'),
      size: storageStats.file,
      color: '#4B48F7'
    })
    this.classifiedDataList.push({
      name: $r('app.string.query_data_system'),
      size: await storageStatistics.getSystemSize(),
      color: '#007DFF'
    })
    Logger.info(TAG, `classifiedDataList: ${JSON.stringify(this.classifiedDataList)}`)
  }

  private async initAppDataList() {
    this.appDataList = []
    let bundleFlags = bundle.ApplicationFlag.GET_APPLICATION_INFO_DEFAULT | bundle.ApplicationFlag.GET_APPLICATION_INFO_WITH_PERMISSION | bundle.ApplicationFlag.GET_APPLICATION_INFO_WITH_METADATA | bundle.ApplicationFlag.GET_APPLICATION_INFO_WITH_DISABLE;
    let applicationInfo: bundle.ApplicationInfo[] =
      await bundle.getAllApplicationInfo(bundleFlags)
    for (let i = 0; i < applicationInfo.length; i++) {
      let info: bundle.ApplicationInfo = applicationInfo[i]
      let appName: string = await this.getAppNameSync(info.labelId, info.name, info.label)
      this.appDataList.push({
        appName: appName,
        bundleName: info.name,
        bundleStats: await storageStatistics.getBundleStats(info.name),
        hasLabel: this.isAppHasAvailableLabel(appName)
      })
    }
    Logger.info(TAG, `appDataList: ${JSON.stringify(this.appDataList)}`)
  }

  private async initItemSizeList() {
    this.itemSizeList = []
    for (let i = 0; i < this.classifiedDataList.length; i++) {
      this.itemSizeList.push(ParseData.parseSize(this.classifiedDataList[i].size))
    }
    Logger.info(TAG, `itemSizeList: ${JSON.stringify(this.itemSizeList)}`)
  }

  public async initData(callback?: (hasInit: boolean) => void) {
    try {
      await this.initClassifiedDataList()
      await this.initAppDataList()
      await this.initItemSizeList()
      this.totalSize = await storageStatistics.getTotalSize()
      this.freeSize = await storageStatistics.getFreeSize()
    } catch (error) {
      Logger.error(TAG, `Init data failed ! error: ${error}`)
      callback(false)
      return
    }
    callback(true)
    return
  }

  public async getUsedSize(callback: (usedSize: number) => void) {
    if (this.totalSize > -1 && this.freeSize > -1) {
      callback(this.totalSize - this.freeSize)
      return
    }
    Logger.info(TAG, `totalSize or freeSize is -1, init data`)
    await this.initData()
    callback(this.totalSize - this.freeSize)
    return
  }

  private async getAppNameSync(labelId: number, bundleName: string, appName: string): Promise<string> {
    if (CheckEmptyUtils.isEmpty(labelId) || labelId <= 0 || CheckEmptyUtils.checkStrIsEmpty(bundleName)) {
      Logger.info(TAG, `getAppNameSync param empty! appName: ${appName}`)
      return appName
    } else {
      let cacheKey = labelId + bundleName
      Logger.info(TAG, `getAppNameSync getResourceManager cacheKey: ${cacheKey}`)
      if (this.isResourceManagerEmpty()) {
        Logger.info(TAG, 'getAppNameSync resourceManager is empty')
        return appName
      }
      let bundleContext = this.context.createBundleContext(bundleName)
      let resMgrName = await bundleContext.resourceManager.getString(labelId)
      Logger.info(TAG, `getAppNameSync resMgrName: ${resMgrName}`)
      if (resMgrName != null) {
        return resMgrName
      } else {
        return appName
      }
    }
  }

  private isResourceManagerEmpty(): boolean {
    return CheckEmptyUtils.isEmpty(this.context)
    || CheckEmptyUtils.isEmpty(this.context.resourceManager)
  }

  private isAppHasAvailableLabel(appName: string): boolean {
    if (CheckEmptyUtils.checkStrIsEmpty(appName) || appName === 'label') {
      return false
    }

    return true
  }
}

export default new QueryStorageData()