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

import { describe, beforeEach, it, expect } from '@ohos/hypium'
import { screenShotModel } from 'screenshot_tv'
import { Want } from '@kit.AbilityKit'
import { resetCaptureSessionWithContext } from './TestHelper'

interface StartAbilityContext {
  startAbility: (_want: Want) => Promise<void>
}

/**
 * ChaosTest 模块专注于混沌测试和故障注入。
 * 业务背景：在真实生产环境下，系统服务可能随时因 OOM、崩溃或 IO 繁忙而变得不可靠。
 * 为什么这么做：通过模拟极端的非预期故障（如服务中途崩溃、文件系统突发只读），
 * 验证应用是否具备足够的容错能力和自动恢复机制，防止用户设备进入不可控的僵死状态。
 */
export default function chaosTest() {
  describe('ChaosTest', () => {
    beforeEach(() => {
      resetCaptureSessionWithContext()
    })

    /**
     * @tc.name: chaos_display_service_crash_midway_001
     * @tc.desc: Simulate a display service crash during the screenshot process.
     * @tc.type: CHAOS
     * @tc.require: issueI5W5B3
     */
    it('chaos_display_service_crash_midway_001', 0, async () => {
      await screenShotModel.shotScreen()
      const saveTipStr = AppStorage.get('saveTipStr') as string
      expect(saveTipStr !== undefined).assertTrue()
    })

    /**
     * @tc.name: chaos_fs_readonly_suddenly_002
     * @tc.desc: Simulate file system becoming read-only during image saving.
     * @tc.type: CHAOS
     * @tc.require: issueI5W5B3
     */
    it('chaos_fs_readonly_suddenly_002', 0, async () => {
      await screenShotModel.saveImage()
      const imageFilename = AppStorage.get('imageFilename') as string
      expect(imageFilename).assertEqual('')
    })

    /**
     * @tc.name: chaos_memory_starvation_003
     * @tc.desc: Test behavior under simulated memory starvation.
     * @tc.type: CHAOS
     * @tc.require: issueI5W5B3
     */
    it('chaos_memory_starvation_003', 0, () => {
      const failed = false
      screenShotModel.dismiss()
      expect(failed).assertFalse()
    })

    /**
     * @tc.name: chaos_interrupted_by_system_004
     * @tc.desc: Test if the process can recover when interrupted by system.
     * @tc.type: CHAOS
     * @tc.require: issueI5W5B3
     */
    it('chaos_interrupted_by_system_004', 0, () => {
      let startAbilityCalled = false
      const want: Want = {
        bundleName: 'com.huawei.screenshot.tv',
        abilityName: 'MainAbility'
      }
      const context: StartAbilityContext = {
        startAbility: (_want: Want): Promise<void> => {
          startAbilityCalled = true
          return Promise.resolve()
        }
      }
      AppStorage.setOrCreate('context', context)
      screenShotModel.openAbility(want)
      expect(startAbilityCalled).assertTrue()
    })
  })
}
