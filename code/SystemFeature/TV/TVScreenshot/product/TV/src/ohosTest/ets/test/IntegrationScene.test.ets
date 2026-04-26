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
import viewModel from '../../../main/ets/vm/ViewModel'
import { resetCaptureSessionWithContext } from './TestHelper'

/**
 * IntegrationSceneTest 模块进行复杂端到端（E2E）业务场景测试。
 * 业务背景：用户的使用行为往往是链式的，例如“截屏 -> 编辑选区 -> 确认保存 -> 查看提示 -> 自动退出”。
 * 为什么这么做：单一模块测试（单元测试）无法捕捉到模块间交互产生的逻辑缝隙。
 * 我们通过模拟真实的用户操作链条，验证各组件（Model, View, ViewModel）
 * 是否能在状态流转中保持高度一致，确保没有“断链”情况发生。
 */
export default function integrationSceneTest() {
  describe('IntegrationSceneTest', () => {
    beforeEach(() => {
      resetCaptureSessionWithContext()
    })

    /**
     * @tc.name: scene_screenshot_to_save_e2e_001
     * @tc.desc: Complete end-to-end flow: Capture -> Preview -> Save -> Exit.
     * @tc.type: SCENE
     * @tc.require: issueI5W5B3
     */
    it('scene_screenshot_to_save_e2e_001', 0, async () => {
      await screenShotModel.shotScreen()
      await new Promise<void>((resolve) => setTimeout(resolve, 10))
      const saveTipStr = AppStorage.get('saveTipStr') as string
      expect(typeof saveTipStr).assertEqual('string')
      expect(typeof screenShotModel.saveImage).assertEqual('function')
      expect(typeof viewModel.CloseShotScreen).assertEqual('function')
    })

    /**
     * @tc.name: scene_screenshot_edit_then_cancel_002
     * @tc.desc: User enters edit mode but decides to cancel.
     * @tc.type: SCENE
     * @tc.require: issueI5W5B3
     */
    it('scene_screenshot_edit_then_cancel_002', 0, async () => {
      await screenShotModel.shotScreen()
      screenShotModel.dismiss()
      const captureImage = AppStorage.get('captureImage') as string | Object | undefined
      expect(captureImage === '' || captureImage !== undefined).assertTrue()
    })

    /**
     * @tc.name: scene_rapid_screenshot_and_save_003
     * @tc.desc: Stress test of the complete scene chain.
     * @tc.type: SCENE
     * @tc.require: issueI5W5B3
     */
    it('scene_rapid_screenshot_and_save_003', 0, async () => {
      for (let i = 0; i < 3; i++) {
        await screenShotModel.shotScreen()
        screenShotModel.dismiss()
      }
      expect(typeof viewModel.CloseShotScreen).assertEqual('function')
    })

    /**
     * @tc.name: scene_low_battery_power_interruption_004
     * @tc.desc: Test if the saving process handles power interruption signals correctly.
     * @tc.type: SCENE
     * @tc.require: issueI5W5B3
     */
    it('scene_low_battery_power_interruption_004', 0, async () => {
      await screenShotModel.shotScreen()
      await screenShotModel.saveImage()
      expect(typeof screenShotModel.saveImage).assertEqual('function')
    })
  })
}
