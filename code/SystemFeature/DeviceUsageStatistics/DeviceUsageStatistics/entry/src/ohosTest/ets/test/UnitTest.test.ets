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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium'
import { Driver, ON } from '@ohos.UiTest'
import { BundleStateUtil } from 'feature-util'
import Logger from '../utils/Logger'

const TAG = '[Sample_DeviceUsageStatistics]'
const BUNDLE = 'DeviceUsageStatistics_'

export default function abilityTest() {
  describe('unitTest', function () {
    /**
     * 检查是否能获取到所有app的使用时间信息
     */
    it(BUNDLE + 'GetTotalApps_001', 0, async function (done) {
      Logger.info(TAG, BUNDLE + 'GetTotalApps_001 begin')
      let driver = Driver.create()
      let bundleStateUtil = new BundleStateUtil()
      let totalAppList = await bundleStateUtil.getTotalAppList()
      let totalTime = 0;
      await driver.delayMs(500)
      for (let i in totalAppList) {
        Logger.info(TAG, 'bundleName: ' + totalAppList[i].bundleName)
        if(totalAppList[i].bundleName !== undefined) {
          totalTime += totalAppList[i].totalTime;
        }
      }
      await expect(totalTime).assertLarger(0)
      await driver.delayMs(1000)
      Logger.info(TAG, BUNDLE + 'GetTotalApps_001 end')
      done()
    })

    /**
     * 检查是否能获取到不常用应用列表
     */
    it(BUNDLE + 'FreeAppsList_001', 2, async (done) => {
      Logger.info(TAG, BUNDLE + 'FreeAppsList_001 begin')
      let driver = Driver.create()
      let bundleStateUtil = new BundleStateUtil()
      let freeAppList = await bundleStateUtil.getFreeAppList()
      let appCount = 0;
      await driver.delayMs(500)
      for (let i in freeAppList) {
        Logger.info(TAG, 'bundleName: ' + freeAppList[i].bundleName)
        if(freeAppList[i].bundleName !== undefined) {
          appCount++;
        }
      }
      await expect(appCount).assertLarger(0)
      await driver.delayMs(1000)
      Logger.info(TAG, BUNDLE + 'FreeAppsList_001 end')
      done()
    })
  })
}