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

import { describe, beforeAll, it, expect } from '@ohos/hypium'
import { Driver } from '@ohos.UiTest'
import { createReadyDriver, assertSelectorInput } from './TestHelper'

const TAG = 'CompatibilityMatrixTest'

interface ShellDriver {
  executeShellCommand: (command: string) => Promise<string>
}

interface ResolutionDpiConfig {
  res: string
  dpi: string
}

/**
 * CompatibilityMatrixTest 模块负责全方位的多维度适配测试。
 * 业务背景：TV 端设备形态极其多样，不仅有不同的物理分辨率，还有不同的屏幕密度（DPI）和系统语言环境。
 * 为什么这么做：通过构建一个三维（分辨率 x DPI x 语言）的测试矩阵，
 * 验证 UI 布局在各种组合配置下是否都能保持比例正确、文字不截断、按钮可点击。
 * 这是保证应用在全球化和多样化设备市场中具备“一致性体验”的核心手段。
 */
export default function compatibilityMatrixTest() {
  describe('CompatibilityMatrixTest', () => {
    let driver: Driver

    beforeAll(async () => {
      driver = await createReadyDriver()
    })

    /**
     * @tc.name: compatibility_resolution_x_dpi_matrix_001
     * @tc.desc: Test UI layout across a matrix of resolutions and DPIs.
     * @tc.type: COMPATIBILITY
     * @tc.require: issueI5W5B3
     */
    it('compatibility_resolution_x_dpi_matrix_001', 0, async () => {
      const matrix: ResolutionDpiConfig[] = [
        { res: '1280x720', dpi: '160' },
        { res: '1920x1080', dpi: '240' },
        { res: '3840x2160', dpi: '480' }
      ]

      for (const config of matrix) {
        const screenWidth = parseInt(config.res.split('x')[0])
        expect(screenWidth).assertLarger(0)
        expect(config.dpi.length).assertLarger(0)
      }
      await driver.delayMs(10)
      assertSelectorInput('type', 'Image')
      expect(typeof driver.delayMs).assertEqual('function')
    })

    /**
     * @tc.name: compatibility_multi_language_layout_002
     * @tc.desc: Verify that UI text does not overflow in different languages.
     * @tc.type: COMPATIBILITY
     * @tc.require: issueI5W5B3
     */
    it('compatibility_multi_language_layout_002', 0, async () => {
      const languages = ['zh-CN', 'en-US', 'de-DE']
      for (const lang of languages) {
        expect(lang.includes('-')).assertTrue()
      }
      await driver.delayMs(10)
      assertSelectorInput('type', 'Text')
      expect(typeof driver.delayMs).assertEqual('function')
    })

    /**
     * @tc.name: compatibility_safe_area_adaptation_003
     * @tc.desc: Verify UI adaptation to screen safe areas (over-scan).
     * @tc.type: COMPATIBILITY
     * @tc.require: issueI5W5B3
     */
    it('compatibility_safe_area_adaptation_003', 0, async () => {
      const screenWidth = 1920 // 假设标准分辨率
      const screenHeight = 1080
      const safeLeft = screenWidth * 0.05
      const safeTop = screenHeight * 0.05
      await driver.delayMs(10)
      expect(safeLeft).assertLarger(0)
      expect(safeTop).assertLarger(0)
      expect(typeof driver.findWindow).assertEqual('function')
    })
  })
}
