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
 

import { describe, it, expect } from '@ohos/hypium';
import HeightConfigUtils from '@ohos/common/src/main/ets/default/heightcofigUtils/HeightConfigUtils';

/**
 * HeightConfigUtils 单元测试
 * 验证状态栏与导航栏的高度配置常量及系数契约，
 * TV 屏幕适配时布局计算依赖这些值的稳定性。
 */
export default function heightConfigUtilsTest() {
  describe('HeightConfigUtils_Test', () => {

    // ---- 状态栏高度配置 ----

    it('getStatusMinH_returns_24', 0, () => {
      // 状态栏最小高度为 24，低于此值文字和图标无法完整显示
      const util = new HeightConfigUtils();
      expect(util.getStatusMinH()).assertEqual(24);
    });

    it('getStatusCoefficient_returns_1_0', 0, () => {
      // 系数为 1.0 表示无缩放，是 TV 屏幕的基准比例
      const util = new HeightConfigUtils();
      expect(util.getStatusCoefficient()).assertEqual(1.0);
    });

    it('status_bar_actual_height_equals_min_times_coefficient', 0, () => {
      // 实际高度 = minHeight × coefficient，系数为1时等于最小高度
      const util = new HeightConfigUtils();
      const actual = util.getStatusMinH() * util.getStatusCoefficient();
      expect(actual).assertEqual(24);
    });

    it('status_bar_min_height_is_positive', 0, () => {
      const util = new HeightConfigUtils();
      expect(util.getStatusMinH()).assertLarger(0);
    });

    it('status_bar_coefficient_is_positive', 0, () => {
      const util = new HeightConfigUtils();
      expect(util.getStatusCoefficient()).assertLarger(0);
    });

    // ---- 导航栏高度配置 ----

    it('getminHeight_returns_32', 0, () => {
      // 导航栏最小高度为 32，高于状态栏以容纳更多按键图标
      const util = new HeightConfigUtils();
      expect(util.getminHeight()).assertEqual(32);
    });

    it('getNavHCoefficient_returns_1_0', 0, () => {
      const util = new HeightConfigUtils();
      expect(util.getNavHCoefficient()).assertEqual(1.0);
    });

    it('nav_bar_actual_height_equals_min_times_coefficient', 0, () => {
      const util = new HeightConfigUtils();
      const actual = util.getminHeight() * util.getNavHCoefficient();
      expect(actual).assertEqual(32);
    });

    it('nav_bar_min_height_is_positive', 0, () => {
      const util = new HeightConfigUtils();
      expect(util.getminHeight()).assertLarger(0);
    });

    it('nav_bar_coefficient_is_positive', 0, () => {
      const util = new HeightConfigUtils();
      expect(util.getNavHCoefficient()).assertLarger(0);
    });

    // ---- 状态栏与导航栏对比 ----

    it('nav_bar_min_height_greater_than_status_bar', 0, () => {
      // 导航栏高度 > 状态栏高度，确保布局层叠时不遮挡状态栏内容
      const util = new HeightConfigUtils();
      expect(util.getminHeight()).assertLarger(util.getStatusMinH());
    });

    it('both_coefficients_are_equal', 0, () => {
      // 两个系数均为 1.0，保证等比布局
      const util = new HeightConfigUtils();
      expect(util.getStatusCoefficient()).assertEqual(util.getNavHCoefficient());
    });

    it('multiple_instances_return_same_values', 0, () => {
      // 多个实例返回相同常量值，确认无实例状态影响配置读取
      const u1 = new HeightConfigUtils();
      const u2 = new HeightConfigUtils();
      expect(u1.getStatusMinH()).assertEqual(u2.getStatusMinH());
      expect(u1.getminHeight()).assertEqual(u2.getminHeight());
      expect(u1.getStatusCoefficient()).assertEqual(u2.getStatusCoefficient());
      expect(u1.getNavHCoefficient()).assertEqual(u2.getNavHCoefficient());
    });

    it('status_min_height_is_integer', 0, () => {
      // 像素值必须为整数，避免布局计算出现小数导致模糊渲染
      const util = new HeightConfigUtils();
      expect(util.getStatusMinH() % 1).assertEqual(0);
    });

    it('nav_min_height_is_integer', 0, () => {
      const util = new HeightConfigUtils();
      expect(util.getminHeight() % 1).assertEqual(0);
    });

  });
}
