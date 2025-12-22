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

import { ComponentCard } from '../../common/Card';

@Entry
@Component
export struct SymbolShadowAndColor {
  scroller: Scroller = new Scroller();
  // [Start shadow_color_1_new]
  @State isActive: boolean = true;

  options: ShadowOptions = {
    radius: 10.0,
    color: Color.Blue,
    offsetX: 10,
    offsetY: 10,
  };
  // [End shadow_color_1_new]

  // [Start shadow_color_2_new]
  radialGradientOptions: RadialGradientOptions = {
    center: ['50%', '50%'],
    radius: '20%',
    colors: [[Color.Red, 0.0], [Color.Blue, 0.3], [Color.Green, 0.5]],
    repeating: true,
  };
  // [End shadow_color_2_new]

  build() {
    NavDestination() {
      Scroll(this.scroller) {
        Column({ space: 12 }) {
          ComponentCard({ title: $r('app.string.SymbolShadowAndColor_title_1') }) {
            // [Start shadow_color_1]
            Column() {
              // 请将$r('app.string.shadow_ability')替换为实际资源文件，在本示例中该资源文件的value值为"阴影能力"
              Text($r('app.string.shadow_ability'));
              SymbolGlyph($r('sys.symbol.ohos_wifi'))
                .fontSize(96)
                .symbolEffect(new HierarchicalSymbolEffect(EffectFillStyle.ITERATIVE), !this.isActive)
                .symbolShadow(this.options)
              // 请将$r('app.string.off')替换为实际资源文件，在本示例中该资源文件的value值为"关闭"
              // 请将$r('app.string.on')替换为实际资源文件，在本示例中该资源文件的value值为"播放"
              Button(!this.isActive ? $r('app.string.off') : $r('app.string.on')).onClick(() => {
                this.isActive = !this.isActive;
              })
            }
            // [End shadow_color_1]
          }
          ComponentCard({ title: $r('app.string.SymbolShadowAndColor_title_2') }) {
            // [Start shadow_color_2]
            Column() {
              // 请将$r('app.string.radial_gradient')替换为实际资源文件，在本示例中该资源文件的value值为"径向渐变"
              Text($r('app.string.radial_gradient'))
                .fontSize(18)
                .fontColor(0xCCCCCC)
                .textAlign(TextAlign.Center)
              SymbolGlyph($r('sys.symbol.ohos_folder_badge_plus'))
                .fontSize(96)
                .shaderStyle([new RadialGradientStyle(this.radialGradientOptions)])
            }
            // [End shadow_color_2]
          }
        }
        .width('100%')
        .padding({ left: 12, right: 12 })
      }.id('scroll_')
    }
    .backgroundColor('#f1f2f3')
    // 请将$r('app.string.SymbolShadowAndColor_title')替换为实际资源文件，
    // 在本示例中该资源文件的value值为"从API version 20开始，支持通过symbolShadow接口实现了symbolGlyph组件显示阴影效果。"
    .title($r('app.string.SymbolShadowAndColor_title'))
  }
}