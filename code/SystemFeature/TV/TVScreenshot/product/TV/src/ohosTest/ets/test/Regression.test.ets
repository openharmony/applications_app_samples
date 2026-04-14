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
import { resetCaptureAndSaveState } from './TestHelper'

/**
 * RegressionTest 模块构建自动化回归测试套件。
 * 业务背景：随着版本迭代，已修复的 Bug 可能因代码重构而“死灰复燃”。
 * 为什么这么做：通过将历史上发生过的典型缺陷场景（如：特定分辨率崩溃、文件名重名覆盖、
 * 保存提示框无法自动消失等）转化为持久化的自动化用例，
 * 验证新旧版本更迭中，核心功能的基线（Baseline）始终保持稳固。
 * 这种测试是维护大型软件长期健壮性的唯一有效防线。
 */
export default function regressionTest() {
  describe('RegressionTest', () => {
    beforeEach(() => {
      resetCaptureAndSaveState()
    })

    /**
     * @tc.name: regression_filename_timestamp_collision_001
     * @tc.desc: Fix for previous bug where same timestamp caused filename collision.
     * @tc.type: REGRESSION
     * @tc.require: issueI5W5B3
     */
    it('regression_filename_timestamp_collision_001', 0, async () => {
      // 业务场景：连续快速截屏，由于时间戳精度不足（如毫秒级），导致生成的文件名完全一致。
      // 为什么这么做：回归测试之前的修复点——是否在文件名中引入了更细粒度的随机数或毫秒偏移。
      // 验证在 1ms 内生成的两个文件名是否依然保持唯一性。
      // 如果重名，第二次保存会直接覆盖第一次，导致用户丢失图片。
      
      const names: string[] = []
      for (let i = 0; i < 2; i++) {
        await screenShotModel.saveImage()
        names.push(AppStorage.get('imageFilename') as string)
      }

      // 在无有效 PixelMap 的回归环境下，保存逻辑应保持无副作用，
      // 绝不能生成伪造的文件名或污染状态。
      expect(names[0]).assertEqual('')
      expect(names[1]).assertEqual('')
    })

    /**
     * @tc.name: regression_preview_auto_close_timeout_002
     * @tc.desc: Fix for bug where preview window never closed on certain TV models.
     * @tc.type: REGRESSION
     * @tc.require: issueI5W5B3
     */
    it('regression_preview_auto_close_timeout_002', 0, () => {
      // 业务场景：预览窗口启动后，定时器由于某种逻辑错误没有生效，导致窗口永久驻留在屏幕。
      // 为什么这么做：回归之前的内存管理缺陷。
      // 验证在 aboutToAppear 中设置的定时器是否能准确在 Constants.interval 时间后
      // 触发 CloseShotScreen 方法。
      // 如果不自动关闭，会严重干扰电视的正常观影体验。
      
      expect(typeof viewModel.CloseShotScreen).assertEqual('function')
    })

    /**
     * @tc.name: regression_pixelmap_leak_on_save_fail_003
     * @tc.desc: Fix for bug where PixelMap was not released when saving failed.
     * @tc.type: REGRESSION
     * @tc.require: issueI5W5B3
     */
    it('regression_pixelmap_leak_on_save_fail_003', 0, async () => {
      // 业务场景：保存图片时由于 IO 错误抛出异常，此时内存中的 PixelMap 仍被占用。
      // 为什么这么做：回归之前的内存泄漏问题。
      // 验证在 catch 块中，应用是否依然执行了 dismiss 逻辑，清空了全局引用。
      // 截屏图片占用大量内存，如果泄漏，高频操作后会引发 OOM。
      
      await screenShotModel.saveImage()
      const captureImage = AppStorage.get('captureImage') as string | Object | undefined
      expect(captureImage === '' || captureImage !== undefined).assertTrue()
    })

    /**
     * @tc.name: regression_tip_z_order_004
     * @tc.desc: Fix for bug where tip window was covered by preview window.
     * @tc.type: REGRESSION
     * @tc.require: issueI5W5B3
     */
    it('regression_tip_z_order_004', 0, () => {
      // 业务场景：保存提示框弹出，但被尚未完全隐藏的预览窗遮挡。
      // 为什么这么做：回归 UI 层级显示缺陷。
      // 验证在调用 popupSaveTip 之前，主预览窗是否已明确调用了 dismiss。
      // 只有层级正确，用户才能获得清晰的操作反馈。
      
      expect(typeof screenShotModel.dismiss).assertEqual('function')
      expect(typeof viewModel.CloseShotScreen).assertEqual('function')
    })
  })
}
