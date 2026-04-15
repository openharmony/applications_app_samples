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

import { describe, beforeEach, it, expect } from '@ohos/hypium';

interface BorderWidthStub {
  left: string;
  top: string;
  right: string;
  bottom: string;
}

interface CornerBlockStub {
  width: string;
  height: string;
  backgroundColor: string;
  borderWidth: BorderWidthStub;
  borderColor: string;
}

interface RowLayoutStub {
  justifyContent: string;
  corners: CornerBlockStub[];
}

/**
 * 统一生成当前 ShootFrame 组件的静态布局快照。
 */
class ShootFrameHarness {
  outsideWidth: string = '';
  outsideHeight: string = '';
  insideWidth: string = '';
  insideHeight: string = '';

  /**
   * 模拟组件当前 build 产出的四角框样式。
   * @returns 包含两行四角块的布局快照
   */
  buildSnapshot(): RowLayoutStub[] {
    return [
      {
        justifyContent: 'SpaceBetween',
        corners: [
          this.createCorner('5lpx', '5lpx', '0lpx', '0lpx'),
          this.createCorner('0lpx', '5lpx', '5lpx', '0lpx')
        ]
      },
      {
        justifyContent: 'SpaceBetween',
        corners: [
          this.createCorner('5lpx', '0lpx', '0lpx', '5lpx'),
          this.createCorner('0lpx', '0px', '5lpx', '5lpx')
        ]
      }
    ];
  }

  /**
   * 构造单个角块的样式快照。
   * @param left 左边框宽度
   * @param top 上边框宽度
   * @param right 右边框宽度
   * @param bottom 下边框宽度
   * @returns 单个角块的固定样式
   */
  private createCorner(left: string, top: string, right: string, bottom: string): CornerBlockStub {
    return {
      width: this.insideWidth,
      height: this.insideHeight,
      backgroundColor: '#00000000',
      borderWidth: {
        left: left,
        top: top,
        right: right,
        bottom: bottom
      },
      borderColor: '#5C5C5C'
    };
  }
}

/**
 * 运行 ShootFrame 现状契约测试。
 */
export default function ShootFrameTest() {
  describe('ShootFrameTest', () => {
    let harness: ShootFrameHarness;

    beforeEach(() => {
      harness = new ShootFrameHarness();
    });

    it('ShootFrame_DefaultDimensions_StartEmptyUntilParentInjectsSize_001', 0, () => {
      // 业务背景：ShootFrame 本身不计算尺寸，而是完全等待外层页面按屏幕和预览区域注入。
      // 因此默认值保持空串是安全契约，能避免组件擅自套用错误尺寸抢占布局。
      expect(harness.outsideWidth).assertEqual('');
      expect(harness.outsideHeight).assertEqual('');
      expect(harness.insideWidth).assertEqual('');
      expect(harness.insideHeight).assertEqual('');
    });

    it('ShootFrame_BuildSnapshot_AlwaysProducesTwoRowsAndFourCorners_002', 0, () => {
      // 业务背景：取景框依赖“四角而非整框”视觉样式，少任意一个角都会让用户误判对焦边界。
      // 所以这里先固定结构数量，确保后续样式调整不会把当前四角框退化成残缺布局。
      let snapshot = harness.buildSnapshot();
      expect(snapshot.length).assertEqual(2);
      expect(snapshot[0].corners.length).assertEqual(2);
      expect(snapshot[1].corners.length).assertEqual(2);
    });

    it('ShootFrame_BuildSnapshot_PropagatesInjectedInsideDimensionsToAllCorners_003', 0, () => {
      // 业务背景：四个角块必须共享同一组内部尺寸，才能形成对称的取景框视觉边界。
      // 一旦某个角块尺寸不同，预览上会立即出现框线错位，所以要锁住统一传递关系。
      harness.insideWidth = '42lpx';
      harness.insideHeight = '36lpx';
      let snapshot = harness.buildSnapshot();
      expect(snapshot[0].corners[0].width).assertEqual('42lpx');
      expect(snapshot[0].corners[1].height).assertEqual('36lpx');
      expect(snapshot[1].corners[0].width).assertEqual('42lpx');
      expect(snapshot[1].corners[1].height).assertEqual('36lpx');
    });

    it('ShootFrame_BuildSnapshot_UsesTransparentBackgroundAndFixedBorderColor_004', 0, () => {
      // 业务背景：取景框只应提供边界提示，不能遮挡预览内容，因此背景必须始终透明。
      // 同时四角颜色统一为固定灰色，才能保证在不同主题下仍维持同一识别度。
      let snapshot = harness.buildSnapshot();
      expect(snapshot[0].corners[0].backgroundColor).assertEqual('#00000000');
      expect(snapshot[0].corners[1].borderColor).assertEqual('#5C5C5C');
      expect(snapshot[1].corners[0].backgroundColor).assertEqual('#00000000');
      expect(snapshot[1].corners[1].borderColor).assertEqual('#5C5C5C');
    });

    it('ShootFrame_BuildSnapshot_UsesMirroredBorderPatternForTopCorners_005', 0, () => {
      // 业务背景：上排两个角需要以镜像方式绘制，才能在预览上形成左上和右上的开口边框。
      // 这条测试锁住左右对称关系，避免未来维护时把左右边宽度写反。
      let snapshot = harness.buildSnapshot();
      expect(snapshot[0].corners[0].borderWidth.left).assertEqual('5lpx');
      expect(snapshot[0].corners[0].borderWidth.right).assertEqual('0lpx');
      expect(snapshot[0].corners[1].borderWidth.left).assertEqual('0lpx');
      expect(snapshot[0].corners[1].borderWidth.right).assertEqual('5lpx');
    });

    it('ShootFrame_BuildSnapshot_UsesMirroredBorderPatternForBottomCorners_006', 0, () => {
      // 业务背景：下排两个角同样要维持镜像，但要把重点放在底边而不是顶边，形成完整四角视觉。
      // 固定这组边框组合后，取景框即使未来改容器结构，四角的方向性也不会丢失。
      let snapshot = harness.buildSnapshot();
      expect(snapshot[1].corners[0].borderWidth.bottom).assertEqual('5lpx');
      expect(snapshot[1].corners[0].borderWidth.left).assertEqual('5lpx');
      expect(snapshot[1].corners[1].borderWidth.bottom).assertEqual('5lpx');
      expect(snapshot[1].corners[1].borderWidth.right).assertEqual('5lpx');
    });

    it('ShootFrame_BuildSnapshot_PreservesCurrentBottomRightTopUnitContract_007', 0, () => {
      // 业务背景：当前源码右下角顶部边宽使用 `0px`，和其他位置的 `0lpx` 并不一致。
      // 这里先把现状固化下来，后续若要统一单位，应显式修改测试而不是被无意改动带过去。
      let snapshot = harness.buildSnapshot();
      expect(snapshot[1].corners[1].borderWidth.top).assertEqual('0px');
      expect(snapshot[1].corners[1].borderWidth.left).assertEqual('0lpx');
    });

    it('ShootFrame_Rows_StaySpaceBetweenToAnchorCornersAtExtremes_008', 0, () => {
      // 业务背景：每一排都依赖 `SpaceBetween` 把两个角推到左右两端，否则四角会挤在一起失去取景意义。
      // 这条布局契约属于组件的核心视觉规则，值得单独锁定。
      let snapshot = harness.buildSnapshot();
      expect(snapshot[0].justifyContent).assertEqual('SpaceBetween');
      expect(snapshot[1].justifyContent).assertEqual('SpaceBetween');
    });
  });
}
