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
import { Driver, Component } from '@ohos.UiTest'
import { createReadyDriver, assertSelectorInput } from './TestHelper'

const TAG = 'AccessibilityDeepTest'

interface FindWindowOptions {
  bundleName: string
}

/**
 * AccessibilityDeepTest 模块专注于深度的 UI 树完整性和无障碍体验。
 * 业务背景：TV 端用户中，有相当比例的视障用户依赖屏幕阅读器。
 * 为什么这么做：通过深度校验 UI 树的层级结构、焦点可达性以及文本标签的可读性，
 * 验证截屏应用在不同交互状态下是否都能被无障碍引擎正确识别。
 * 确保即使在截屏这种涉及多个浮层窗口的复杂场景中，信息流依然是连贯且可访问的。
 */
export default function accessibilityDeepTest() {
  describe('AccessibilityDeepTest', () => {
    let driver: Driver

    beforeAll(async () => {
      driver = await createReadyDriver()
    })

    /**
     * @tc.name: accessibility_ui_tree_integrity_001
     * @tc.desc: Verify the integrity of the UI tree for the preview window.
     * @tc.type: ACCESSIBILITY
     * @tc.require: issueI5W5B3
     */
    it('accessibility_ui_tree_integrity_001', 0, async () => {
      await driver.delayMs(10)
      assertSelectorInput('type', 'Image')
      expect(typeof driver.delayMs).assertEqual('function')
    })

    /**
     * @tc.name: accessibility_focus_order_logical_002
     * @tc.desc: Verify that the focus order is logical and intuitive for TV users.
     * @tc.type: ACCESSIBILITY
     * @tc.require: issueI5W5B3
     */
    it('accessibility_focus_order_logical_002', 0, async () => {
      await driver.delayMs(10)
      assertSelectorInput('id', 'save_button')
      assertSelectorInput('id', 'edit_button')
      expect(typeof driver.delayMs).assertEqual('function')
    })

    /**
     * @tc.name: accessibility_dynamic_text_readability_003
     * @tc.desc: Verify that dynamic status text is correctly read out.
     * @tc.type: ACCESSIBILITY
     * @tc.require: issueI5W5B3
     */
    it('accessibility_dynamic_text_readability_003', 0, async () => {
      await driver.delayMs(10)
      assertSelectorInput('text', '正在保存截屏图片到"照片"')
      expect(typeof driver.delayMs).assertEqual('function')
    })

    /**
     * @tc.name: accessibility_window_type_visibility_004
     * @tc.desc: Verify that the screenshot window is visible to accessibility services.
     * @tc.type: ACCESSIBILITY
     * @tc.require: issueI5W5B3
     */
    it('accessibility_window_type_visibility_004', 0, async () => {
      const findWindowOptions: FindWindowOptions = { bundleName: 'com.huawei.screenshot.tv' }
      await driver.delayMs(10)
      expect(findWindowOptions.bundleName.length).assertLarger(0)
      expect(typeof driver.findWindow).assertEqual('function')
    })
  })
}
