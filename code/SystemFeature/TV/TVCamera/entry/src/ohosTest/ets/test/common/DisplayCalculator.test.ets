/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     `http://www.apache.org/licenses/LICENSE-2.0`
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { describe, beforeEach, it, expect } from '@ohos/hypium';
import DisplayCalculator, { DisplaySize } from '../../../../main/ets/common/DisplayCalculator';
import { Constants } from '../../../../main/ets/common/Constants';

function assertSize(result: DisplaySize, width: number, height: number): void {
  expect(result.width).assertEqual(width);
  expect(result.height).assertEqual(height);
}

export default function DisplayCalculatorTest() {
  describe('DisplayCalculatorTest', () => {
    beforeEach(() => {
      // 业务背景：DisplayCalculator 强依赖 AppStorage 中的设备类型。
      // 这样做是为了把“屏幕方向”和“设备类型”两条分支拆开验证，避免用例彼此串扰。
      AppStorage.setOrCreate('deviceType', Constants.DEFAULT);
    });

    it('DisplayCalculator_DefaultLandscape_ReturnsFullFrame_001', 0, () => {
      // 业务背景：默认设备的大屏场景是电视端主链路。
      // 这里验证满屏比例命中时不应缩放，否则预览会出现不必要的留黑边。
      let result: DisplaySize = DisplayCalculator.calcSurfaceDisplaySize(1920, 1080, 16 / 9);
      assertSize(result, 1920, 1080);
    });

    it('DisplayCalculator_DefaultLandscape_CropsByHeightWhenScreenIsTooWide_002', 0, () => {
      // 业务背景：当外层容器比目标比例更宽时，算法必须以高度为锚点收窄宽度。
      // 这样做能保证预览内容完整，而不是被横向拉伸。
      let result: DisplaySize = DisplayCalculator.calcSurfaceDisplaySize(2560, 1080, 16 / 9);
      assertSize(result, 1920, 1080);
    });

    it('DisplayCalculator_DefaultLandscape_CropsByWidthWhenScreenIsNarrow_003', 0, () => {
      // 业务背景：当容器宽度不足时，算法要守住宽度上限并按目标比例收缩高度。
      // 这是为了避免预览区域超出父容器后遮挡底部控制栏。
      let result: DisplaySize = DisplayCalculator.calcSurfaceDisplaySize(1280, 1080, 16 / 9);
      assertSize(result, 1280, 720);
    });

    it('DisplayCalculator_DefaultLandscape_UsesExactFourByThree_004', 0, () => {
      // 业务背景：4:3 是相机取景的经典比例，很多拍照分支仍依赖它。
      // 这里守住精确结果，能防止后续分辨率切换时出现取景框跳动。
      let result: DisplaySize = DisplayCalculator.calcSurfaceDisplaySize(1024, 768, 4 / 3);
      assertSize(result, 1024, 768);
    });

    it('DisplayCalculator_DefaultLandscape_ShrinksFourByThreeByHeight_005', 0, () => {
      // 业务背景：宽屏承载 4:3 内容时，左右留白比裁切更安全。
      // 这样做可以复用同一套拍照预览布局，而不破坏原始画面比例。
      let result: DisplaySize = DisplayCalculator.calcSurfaceDisplaySize(1920, 768, 4 / 3);
      assertSize(result, 1024, 768);
    });

    it('DisplayCalculator_TabletPortrait_ForcesLandscapeBranch_006', 0, () => {
      // 业务背景：当前实现把 tablet 直接视为大屏设备，即使是竖屏也走横屏分支。
      // 这个回归点很关键，因为 TV 代码在平板调试时必须保持同一套计算习惯。
      AppStorage.setOrCreate('deviceType', Constants.TABLET);
      let result: DisplaySize = DisplayCalculator.calcSurfaceDisplaySize(1024, 1366, 16 / 9);
      assertSize(result, 1024, 576);
    });

    it('DisplayCalculator_TabletPortrait_DiffersFromDefaultBranch_007', 0, () => {
      // 业务背景：同一块屏幕在 default 与 tablet 两个分支下会得出不同结果。
      // 单独比较两种输出，能防止后续重构把设备类型判断误删。
      AppStorage.setOrCreate('deviceType', Constants.TABLET);
      let tabletResult: DisplaySize = DisplayCalculator.calcSurfaceDisplaySize(1024, 1366, 4 / 3);
      AppStorage.setOrCreate('deviceType', Constants.DEFAULT);
      let defaultResult: DisplaySize = DisplayCalculator.calcSurfaceDisplaySize(1024, 1366, 4 / 3);
      assertSize(tabletResult, 1024, 768);
      assertSize(defaultResult, 1024, 1365);
    });

    it('DisplayCalculator_PhonePortrait_UsesPortraitBranch_008', 0, () => {
      // 业务背景：手机竖屏时应以宽度为主要约束，避免画面超出触控区域。
      // 这条用例守住了“手机和电视不同”的核心分支语义。
      AppStorage.setOrCreate('deviceType', Constants.PHONE);
      let result: DisplaySize = DisplayCalculator.calcSurfaceDisplaySize(1080, 1920, 16 / 9);
      assertSize(result, 1080, 1920);
    });

    it('DisplayCalculator_PhonePortrait_SupportsFourByThreePreview_009', 0, () => {
      // 业务背景：拍照分支常切回 4:3 预览，因此手机竖屏不能只验证 16:9。
      // 保留这条测试可以防止拍照模式切换后出现预览高度异常。
      AppStorage.setOrCreate('deviceType', Constants.PHONE);
      let result: DisplaySize = DisplayCalculator.calcSurfaceDisplaySize(1080, 1920, 4 / 3);
      assertSize(result, 1080, 1440);
    });

    it('DisplayCalculator_Landscape_FloorsFractionalResult_010', 0, () => {
      // 业务背景：渲染尺寸最终必须落在像素网格上，带小数会导致预览模糊。
      // 这里验证向下取整行为，避免重构时改成四舍五入造成边缘抖动。
      AppStorage.setOrCreate('deviceType', Constants.DEFAULT);
      let result: DisplaySize = DisplayCalculator.calcSurfaceDisplaySize(1001, 1000, 4 / 3);
      assertSize(result, 1001, 750);
    });

    it('DisplayCalculator_ZeroWidth_ReturnsZeroSurface_011', 0, () => {
      // 业务背景：外层布局初始化阶段可能短暂出现宽度为 0 的测量值。
      // 这类场景不应抛错，返回零尺寸比伪造默认尺寸更容易让上层重算。
      let result: DisplaySize = DisplayCalculator.calcSurfaceDisplaySize(0, 1080, 16 / 9);
      assertSize(result, 0, 0);
    });

    it('DisplayCalculator_ZeroHeight_ReturnsZeroSurface_012', 0, () => {
      // 业务背景：高度测量尚未完成时，预览组件仍可能先触发一次计算。
      // 守住这个行为可以避免首帧阶段出现异常日志或除零问题。
      let result: DisplaySize = DisplayCalculator.calcSurfaceDisplaySize(1920, 0, 16 / 9);
      assertSize(result, 0, 0);
    });

    it('DisplayCalculator_MinScreen_KeepsMathStable_013', 0, () => {
      // 业务背景：极小窗口是多窗口或遥控器缩放模式下的真实场景。
      // 这里关注的是算法稳定性，而不是视觉完美度，所以只验证数学结果。
      let result: DisplaySize = DisplayCalculator.calcSurfaceDisplaySize(320, 480, 16 / 9);
      assertSize(result, 320, 568);
    });
  });
}
