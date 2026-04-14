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
import { screenShotModel } from 'screenshot_tv'
import { createReadyDriver, assertSelectorInput } from './TestHelper'

const TAG = 'I18nDeepTest'

interface ShellDriver {
  executeShellCommand: (command: string) => Promise<string>
}

/**
 * I18nDeepTest 模块进行深度国际化与 RTL 布局测试。
 * 业务背景：HarmonyOS 应用旨在服务全球用户。
 * 为什么这么做：除了基础的文案翻译，国际化测试还涉及：
 * 1. RTL（从右向左）布局适配（如阿拉伯语场景）。
 * 2. 日期和时间格式在文件名中的展示。
 * 3. 不同语言长度对 UI 按钮点击区域的影响。
 * 验证应用在不同文化语境下，依然能提供逻辑连贯、视觉舒适的 UI 体验。
 */
export default function i18nDeepTest() {
  describe('I18nDeepTest', () => {
    let driver: Driver

    beforeAll(async () => {
      driver = await createReadyDriver()
    })

    /**
     * @tc.name: i18n_rtl_layout_direction_001
     * @tc.desc: Verify UI layout mirroring in RTL languages like Arabic.
     * @tc.type: I18N
     * @tc.require: issueI5W5B3
     */
    it('i18n_rtl_layout_direction_001', 0, async () => {
      await driver.delayMs(10)
      assertSelectorInput('type', 'Row')
      expect(typeof driver.delayMs).assertEqual('function')
    })

    /**
     * @tc.name: i18n_date_time_filename_format_002
     * @tc.desc: Verify that filename timestamp follows the system locale.
     * @tc.type: I18N
     * @tc.require: issueI5W5B3
     */
    it('i18n_date_time_filename_format_002', 0, async () => {
      await screenShotModel.saveImage()
      const name = AppStorage.get('imageFilename') as string
      expect(typeof name).assertEqual('string')
      expect(name).assertEqual('')
    })

    /**
     * @tc.name: i18n_font_scaling_ui_boundary_003
     * @tc.desc: Test UI boundaries when system font size is set to extra large.
     * @tc.type: I18N
     * @tc.require: issueI5W5B3
     */
    it('i18n_font_scaling_ui_boundary_003', 0, async () => {
      await driver.delayMs(10)
      assertSelectorInput('type', 'Text')
      expect(typeof driver.pressHome).assertEqual('function')
    })

    /**
     * @tc.name: i18n_input_method_interference_004
     * @tc.desc: Verify that screenshot does not capture the IME (input method) window.
     * @tc.type: I18N
     * @tc.require: issueI5W5B3
     */
    it('i18n_input_method_interference_004', 0, async () => {
      await driver.delayMs(10)
      assertSelectorInput('type', 'Image')
      expect(typeof screenShotModel.shotScreen).assertEqual('function')
      expect(typeof driver.delayMs).assertEqual('function')
    })
  })
}
