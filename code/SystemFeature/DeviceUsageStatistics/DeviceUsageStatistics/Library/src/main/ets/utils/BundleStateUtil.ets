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

import usageStatistics from '@ohos.resourceschedule.usageStatistics'
import AppTime from '../model/AppTime'
import Logger from './Logger'
import { AppInfo, appInit } from '../model/AppInfo'
import { getAppName, getAppIcon, getTimStr } from './Util'

const TAG: string = 'BundleStateUtil'
const BEGIN_HOURS: number = 0
const BEGIN_MINUTES: number = 0
const BEGIN_SECONDS: number = 0
const END_HOURS: number = 23
const END_MINUTES: number = 59
const END_SECONDS: number = 59

export class BundleStateUtil {
  private apps: Array<AppInfo> = appInit()
  private freeApps: Array<AppInfo> = []

  /**
   * 获取不常用应用列表
   */
  async getFreeAppList(): Promise<Array<AppInfo>> {
    for (let appsKey in this.apps) {
      let bundleName = this.apps[appsKey].bundleName
      let isIdleState = await usageStatistics.isIdleState(bundleName)
      if (isIdleState) {
        this.freeApps.push({ bundleName: bundleName, name: getAppName(bundleName), icon: getAppIcon(bundleName) })
      }
      Logger.info(TAG, `freeApps=${JSON.stringify(this.freeApps)}`)
    }
    return this.freeApps
  }

  /**
   * 获取所有应用使用时间列表
   */
  async getTotalAppList(): Promise<Array<AppTime>> {
    let dateBegin = new Date()
    // 设置开始时间为00:00:00
    dateBegin.setHours(BEGIN_HOURS)
    dateBegin.setMinutes(BEGIN_MINUTES)
    dateBegin.setSeconds(BEGIN_SECONDS)
    Logger.info(TAG, `dateBegin= ${getTimStr(dateBegin)} ${dateBegin.toString()}`)
    let dateEnd = new Date()
    // 设置结束时间为23:59:59
    dateEnd.setHours(END_HOURS)
    dateEnd.setMinutes(END_MINUTES)
    dateEnd.setSeconds(END_SECONDS)
    Logger.info(TAG, `dateEnd= ${getTimStr(dateEnd)} ${dateEnd.toString()}`)
    let res = await usageStatistics.queryBundleStatsInfos(Date.parse(dateBegin.toString()), Date.parse(dateEnd.toString()))
    Logger.info(TAG, `queryBundleStateInfos promise success`)
    let list: Array<AppTime> = []
    for (let key in res) {
      if (res.hasOwnProperty(key)) {
        Logger.info(TAG, `queryBundleStateInfos promise result ${JSON.stringify(res[key])}`)
        let appTime = new AppTime(res[key].bundleName, res[key].abilityPrevAccessTime, res[key].abilityInFgTotalTime)
        list.push(appTime)
      }
    }
    return list
  }
}
