'use static';
/**
 *
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 *
 * All rights reserved.
 * Redistribution and use in source and binary forms, with or without modification,
 * are permitted provided that the following conditions are met:
 *
 * Redistributions of source code must retain the above copyright notice,this
 * list of conditions and the following disclaimer.
 *
 * Redistributions in binary form must reproduce the above copyright notice,
 * this list of conditions and the following disclaimer in the documentation
 * and/or other materials provided with the distribution.
 *
 * THIS IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS 'AS IS' AND ANY EXPRESS OR IMPLIED WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
 * OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS,
 *
 * EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */
import {
  Builder,
  PathShape,
  RelativeContainer,
  HorizontalAlign,
  Column,
  Position,
  Color,
  vp2px,
  VerticalAlign
} from '@ohos.arkui.component';
import { TabItemSelectType } from '../../types/RaisedCircleTypes';
import { SURPLUSRADIUS } from '../../utils/CircleClass';

// 渲染选中时凸起圆
@Builder
export function TabsRaisedCircleSelect(tabItemSelectOptions: TabItemSelectType) {
  RelativeContainer() {
    // 选中时凸起的圆
    Column()
      .aspectRatio(1)
      .height(tabItemSelectOptions.chamfer.circleDiameter)
      .borderRadius(tabItemSelectOptions.chamfer.circleRadius)
      .borderWidth(tabItemSelectOptions.chamfer.circleDiameter * 0.1)
      .borderColor(tabItemSelectOptions.tabsBgColor)
      .radialGradient({
        center: [tabItemSelectOptions.chamfer.circleRadius, tabItemSelectOptions.chamfer.circleRadius],
        radius: tabItemSelectOptions.chamfer.circleRadius,
        colors: [[tabItemSelectOptions.tabsSelectBgColor,
          (tabItemSelectOptions.chamfer.circleDiameter - SURPLUSRADIUS) / tabItemSelectOptions.chamfer.circleDiameter],
          [Color.Transparent, (tabItemSelectOptions.chamfer.circleDiameter - SURPLUSRADIUS) /
          tabItemSelectOptions.chamfer.circleDiameter]]
      })
      .id(tabItemSelectOptions.selectBodyId)
    if (tabItemSelectOptions.chamfer) {
      // 凸起圆 左边 的圆滑过度
      // 知识点：通过裁切+渐变色制作一个平滑的过渡
      Column()
        .width(tabItemSelectOptions.chamfer.chamferXY[0])
        .height(tabItemSelectOptions.chamfer.chamferXY[1])
        .radialGradient({
          center: [0, 0],
          radius: tabItemSelectOptions.chamfer.chamferRadius,
          colors: [[Color.Transparent, 0.0], [Color.Transparent, 1], [tabItemSelectOptions.tabsBgColor, 1]]
        })
        .clipShape(new PathShape({
          commands: `M0 0 L0 ${vp2px(tabItemSelectOptions.chamfer.chamferXY[1])}
          L${vp2px(tabItemSelectOptions.chamfer.chamferXY[0])} ${vp2px(tabItemSelectOptions.chamfer.chamferXY[1])} Z`
        }))
        .zIndex(-1)
        .alignRules({
          'right': { 'anchor': tabItemSelectOptions.selectBodyId, 'align': HorizontalAlign.Center },
          'bottom': { 'anchor': tabItemSelectOptions.selectBodyId, 'align': VerticalAlign.Center }
        })
      // 凸起圆 右边 的圆滑过度
      // 知识点：通过裁切+渐变色制作一个平滑的过渡
      Column()
        .width(tabItemSelectOptions.chamfer.chamferXY[0])
        .height(tabItemSelectOptions.chamfer.chamferXY[1])
        .radialGradient({
          center: [tabItemSelectOptions.chamfer.chamferXY[0], 0],
          radius: tabItemSelectOptions.chamfer.chamferRadius,
          colors: [[Color.Transparent, 0.0], [Color.Transparent, 1], [tabItemSelectOptions.tabsBgColor, 1]]
        })
        .clipShape(new PathShape({
          commands: `M0 ${vp2px(tabItemSelectOptions.chamfer.chamferXY[1])}
          L${vp2px(tabItemSelectOptions.chamfer.chamferXY[0])}
          0 L${vp2px(tabItemSelectOptions.chamfer.chamferXY[0])}
      ${vp2px(tabItemSelectOptions.chamfer.chamferXY[1])} Z`
        }))
        .zIndex(-1)
        .alignRules({
          'left': { 'anchor': tabItemSelectOptions.selectBodyId, 'align': HorizontalAlign.Center },
          'bottom': { 'anchor': tabItemSelectOptions.selectBodyId, 'align': VerticalAlign.Center }
        })
    }
  }
  .width('auto')
  .offset({
    x: -tabItemSelectOptions.chamfer.circleOffsetX,
    y: -tabItemSelectOptions.chamfer.circleOffsetY
  } as Position)
  .zIndex(-1)
  .alignRules({
    'left': {
      'anchor': `${tabItemSelectOptions.tabItemId}${tabItemSelectOptions.selectIndex}`,
      'align': HorizontalAlign.Center
    }
  })
}