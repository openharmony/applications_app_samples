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

import missionManager from '@ohos.application.missionManager'
import image from '@ohos.multimedia.image'
import MissionInfo from '../bean/MisssionInfo'
import { LauncherAbilityManager, Logger } from '@ohos/base'

const NUMMAX: number = 20
const TAG: string = 'MissionModel'

class MissionModel {
  async getMissionInfos(context: any) {
    let missionInfoList: Array<MissionInfo> = new Array<MissionInfo>()
    let missionInfos = await missionManager.getMissionInfos('', NUMMAX)
    Logger.info(TAG, `getMissionInfos = ${missionInfos.length}`)
    let launcherAbilityManager = LauncherAbilityManager.getInstance(context)
    for (let recentItem of missionInfos) {
      let missionInfo = new MissionInfo()
      missionInfo.missionId = recentItem.missionId
      missionInfo.bundleName = recentItem.want.bundleName
      missionInfo.abilityName = recentItem.want.abilityName
      missionInfo.lockedState = recentItem.lockedState
      let appInfo = await launcherAbilityManager.getAppInfoByBundleName(missionInfo.bundleName)
      if (appInfo == undefined) {
        continue
      }
      missionInfo.appIconId = appInfo.appIconId
      missionInfo.appName = appInfo.appName
      Logger.info(TAG, `missionInfo = ${JSON.stringify(missionInfo)}`)
      missionInfoList.push(missionInfo)
    }
    Logger.info(TAG, `getMissionInfos result, count= ${JSON.stringify(missionInfoList)}`)
    return missionInfoList
  }

  async getSnapShot(missionId) {
    let missionSnapshot = await missionManager.getMissionSnapShot('', missionId)
    let snapshot: image.PixelMap = missionSnapshot.snapshot
    return snapshot
  }

  async lockMission(missionId: number) {
    await missionManager.lockMission(missionId)
  }

  async unLockMission(missionId: number) {
    await missionManager.unlockMission(missionId)
  }

  async clearMission(missionId: number) {
    await missionManager.clearMission(missionId)
  }

  async clearAllMission() {
    await missionManager.clearAllMissions()
  }
}

export default new MissionModel()