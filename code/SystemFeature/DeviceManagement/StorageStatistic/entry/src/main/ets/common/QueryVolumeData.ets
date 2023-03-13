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

import storageStatistics from '@ohos.file.storageStatistics'
import volumeManager from '@ohos.file.volumeManager'
import CheckEmptyUtils from '../utils/CheckEmptyUtils'
import Logger from '../utils/Logger'
import { VolumeData } from '../model/VolumeData'

const TAG: string = 'QueryVolumeData'

export class QueryVolumeData {
  public volumeSizeList: VolumeData[] = []
  private volumeDataList: volumeManager.Volume[] = []

  private async initVolumeDataList() {
    this.volumeDataList = []
    this.volumeDataList = await volumeManager.getAllVolumes()
    Logger.info(TAG, `volumeDataList ${this.volumeDataList}`)
  }

  private async initVolumeSizeList() {
    this.volumeSizeList = []
    for (let i = 0; i < this.volumeDataList.length; i++) {
      let volumeData: volumeManager.Volume = this.volumeDataList[i]
      this.volumeSizeList.push({
        totalSize: await storageStatistics.getTotalSizeOfVolume(volumeData.uuid),
        freeSize: await storageStatistics.getFreeSizeOfVolume(volumeData.uuid),
        description: volumeData.description
      })
    }
    Logger.info(TAG, `volumeSizeList ${this.volumeSizeList}`)
  }

  public async initVolumeData(callback: (hasInit: boolean) => void){
    try {
      await this.initVolumeDataList()
      await this.initVolumeSizeList()
    } catch (error) {
      Logger.error(TAG, `initVolumeData failed! error: ${error}`)
      callback(false)
      return
    }

    if (!CheckEmptyUtils.isEmptyArr(this.volumeDataList)) {
      Logger.info(TAG, `VolumeDataList ${this.volumeDataList}`)
      callback(true)
      return
    }

    Logger.info(TAG, `No volume currently available`)
    callback(false)
    return
  }
}