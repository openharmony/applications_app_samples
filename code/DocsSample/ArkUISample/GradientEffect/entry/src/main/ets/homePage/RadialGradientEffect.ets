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

// [Start Radial_Gradient_Effect]
@Entry
@Component
struct RadialGradientDemo {
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
        .radialGradient({
          center: [50, 50], // 径向渐变中心点
          radius: 100, // 径向渐变半径
          repeating: true, // 允许在组件内渐变范围外重复按照渐变范围内效果着色
          colors: [
            // 组件内以[50，50]为中心点，在半径为0到12.5的范围内从颜色断点1的颜色渐变到颜色断点2的颜色,
            // 在半径为12.5到25的范围内从颜色断点2的颜色渐变到颜色断点3的颜色,
            // 组件外其他半径范围内按照半径为0到25的渐变效果重复着色
            [0xf56c6c, 0], // 颜色断点1的颜色和比重，对应半径为0*100=0
            [0xffffff, 0.125], // 颜色断点2的颜色和比重，对应半径为0.125*100=12.5
            [0x409EFF, 0.25]// 颜色断点3的颜色和比重，对应半径为0.25*100=25
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
        .radialGradient({
          center: [0, 0], // 径向渐变中心点，当前为组件左上角坐标
          radius: 100,
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
          Text('repeat: true')
            .fontSize(15)
        }
        .width(100)
        .height(100)
        .justifyContent(FlexAlign.Center)
        .borderRadius(10)
        .radialGradient({
          center: [50, 50],
          radius: 100,
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
        .radialGradient({
          center: [50, 50],
          radius: 100,
          repeating: false, // 在组件内渐变范围外不重复按照渐变范围内效果着色
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
    .height('100%')
  }
}
// [End Radial_Gradient_Effect]