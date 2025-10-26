/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

// [Start Direction_Gradient_Effect]
@Entry
@Component
struct SweepGradientDemo {
  build() {
    Grid() {
      GridItem() {
        Column() {
          Text('center: 50')
            .fontSize(15)
        }
        .width(100)
        .height(100)
        .justifyContent(FlexAlign.Center)
        .borderRadius(10)
        .sweepGradient({
          center: [50, 50], // 角度渐变中心点
          start: 0, // 角度渐变的起点
          end: 360, // 角度渐变的终点。
          repeating: true, // 渐变效果在重复
          colors: [
            // 当前组件中，按照中心点和渐变的起点和终点值,
            // 角度区域为0-0.125的范围，从颜色断点1的颜色渐变到颜色断点2的颜色,
            // 角度区域0.125到0.25的范围，从颜色断点2的颜色渐变到颜色断点3的颜色,
            // 因为repeating设置为true，角度区域0.25到1的范围，重复区域0到0.25的颜色渐变效果
            [0xf56c6c, 0], // 颜色断点1的颜色和比重，对应角度为0*360°=0°，角点为中心点
            [0xffffff, 0.125], // 颜色断点2的颜色和比重
            [0x409EFF, 0.25]// 颜色断点3的颜色和比重
          ]
        })
      }

      GridItem() {
        Column() {
          Text('center: 0')
            .fontSize(15)
        }
        .width(100)
        .height(100)
        .justifyContent(FlexAlign.Center)
        .borderRadius(10)
        .sweepGradient({
          center: [0, 0], // 角度渐变中心点，当前为组件的左上角坐标
          start: 0,
          end: 360,
          repeating: true,
          colors: [
            // 当前组件中，因为角度渐变中心是组件的左上角，所以从颜色断点1到颜色断点3的角度范围，恰好可以覆盖整个组件
            [0xf56c6c, 0], // 颜色断点1的颜色和比重，对应角度为0*360°=0°
            [0xffffff, 0.125], // 颜色断点2的颜色和比重，对应角度为0.125*360°=45°
            [0x409EFF, 0.25]// 颜色断点3的颜色和比重，对应角度为0.25*360°=90°
          ]
        })
      }

      GridItem() {
        Column() {
          Text('repeat: true')
            .fontSize(15)
        }
        .width(100)
        .height(100)
        .justifyContent(FlexAlign.Center)
        .borderRadius(10)
        .sweepGradient({
          center: [50, 50],
          start: 0,
          end: 360,
          repeating: true,
          colors: [
            [0xf56c6c, 0],
            [0xffffff, 0.125],
            [0x409EFF, 0.25]
          ]
        })
      }

      GridItem() {
        Column() {
          Text('repeat: false')
            .fontSize(15)
        }
        .width(100)
        .height(100)
        .justifyContent(FlexAlign.Center)
        .borderRadius(10)
        .sweepGradient({
          center: [50, 50],
          start: 0,
          end: 360,
          repeating: false, //只在颜色断点角度覆盖范围内产生颜色渐变效果，其余范围内不重复
          colors: [
            [0xf56c6c, 0],
            [0xffffff, 0.125],
            [0x409EFF, 0.25]
          ]
        })
      }
    }
    .columnsGap(10)
    .rowsGap(10)
    .columnsTemplate('1fr 1fr')
    .rowsTemplate('1fr 1fr 1fr')
    .width('100%')
    .height(437)
  }
}
// [End Direction_Gradient_Effect]