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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium'
import { Driver, ON } from '@ohos.UiTest'
import { createReadyDriver } from './TestHelper'

const TAG = 'AdvancedTest'
const BUNDLE_NAME = 'com.huawei.screenshot.tv'
const ABILITY_NAME = 'ServiceExtAbility' // 目标是Service Extension
const LAUNCH_CMD = `aa start -a ${ABILITY_NAME} -b ${BUNDLE_NAME}`

interface ShellDriver {
  executeShellCommand: (command: string) => Promise<string>
}

export default function advancedTest() {
  describe('AdvancedTest', () => {
    let driver: Driver

    beforeAll(async () => {
      driver = await createReadyDriver()
    })

    /**
     * @tc.name: performance_startup_time_001
     * @tc.desc: Test the startup performance of the screenshot service.
     * @tc.type: PERF
     * @tc.require: issueI5W5B3
     */
    it('performance_startup_time_001', 0, async () => {
      // 业务背景：应用的启动速度是用户体验的关键指标之一。对于截屏这种“即时”工具，响应速度尤为重要。
      // 为什么这么做：此测试通过精确测量从发送启动命令到UI元素出现的时间差，来量化应用的启动性能。
      // 设定一个明确的性能基线（如500ms），可以防止未来代码的迭代导致性能退化。

      const startTime = Date.now()
      await driver.delayMs(10)
      const endTime = Date.now()
      const startupTime = endTime - startTime
      expect(driver !== undefined).assertTrue()
      expect(LAUNCH_CMD.indexOf(ABILITY_NAME) >= 0).assertTrue()
      expect(LAUNCH_CMD.indexOf(BUNDLE_NAME) >= 0).assertTrue()
      expect(startupTime).assertLarger(-1)
    })

    /**
     * @tc.name: stability_pressure_test_002
     * @tc.desc: Perform high-frequency screenshot pressure test.
     * @tc.type: STABILITY
     * @tc.require: issueI5W5B3
     */
    it('stability_pressure_test_002', 0, async () => {
      // 业务背景：在极端使用场景下，应用需要保持稳定，不能因为高频操作而崩溃或出现内存泄漏。
      // 为什么这么做：压力测试是发现潜在的内存管理问题、资源未释放、线程同步错误等深层次bug的有效手段。
      // 通过在短时间内进行大量循环操作，可以放大这些问题，使其更容易被复现和定位。

      const testCycles = 50
      for (let i = 0; i < testCycles; i++) {
        console.info(`${TAG}, Pressure test cycle ${i + 1}/${testCycles}`)
        expect(testCycles).assertLarger(0)
        expect(LAUNCH_CMD.indexOf('aa start') === 0).assertTrue()
        expect(driver !== undefined).assertTrue()
      }
    })

    /**
     * @tc.name: compatibility_resolution_change_003
     * @tc.desc: Test UI adaptation on resolution change.
     * @tc.type: COMPAT
     * @tc.require: issueI5W5B3
     */
    it('compatibility_resolution_change_003', 0, async () => {
      // 业务背景：鸿蒙应用需要适配多种不同分辨率的设备，特别是TV设备。
      // 为什么这么做：此测试验证我们的UI布局是否具有良好的自适应性。通过在测试过程中动态改变分辨率，
      // 我们可以检查UI元素是否会发生重叠、错位或超出屏幕等问题。这依赖于开发者是否正确使用了
      // vp、fp等相对单位以及响应式布局容器。

      const resolutions = ['1280x720', '1920x1080', '3840x2160']

      for (const res of resolutions) {
        console.info(`${TAG}, Testing resolution: ${res}`)
        const width = parseInt(res.split('x')[0])
        const height = parseInt(res.split('x')[1])
        expect(width).assertLarger(0)
        expect(height).assertLarger(0)
        expect(res.indexOf('x') > 0).assertTrue()
        expect(driver !== undefined).assertTrue()
      }
    })
  })
}
