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
import { curves } from '@kit.ArkUI';

@Entry
@Component
struct TransitionEffectDemo {
  @State isPresent: boolean = false;
  // 第一步，创建TransitionEffect
  private effect: TransitionEffect =
    // 创建默认透明度转场效果，并指定了springMotion(0.6, 0.8)曲线
    TransitionEffect.OPACITY.animation({
      curve: curves.springMotion(0.6, 0.8)
    })// 通过combine方法，这里的动画参数会跟随上面的TransitionEffect，也就是springMotion(0.6, 0.8)
      .combine(TransitionEffect.scale({
        x: 0,
        y: 0
      }))// 添加旋转转场效果，这里的动画参数会跟随上面带animation的TransitionEffect，也就是springMotion(0.6, 0.8)
      .combine(TransitionEffect.rotate({ angle: 90 }))// 添加平移转场效果，这里的动画参数使用指定的springMotion()
      .combine(TransitionEffect.translate({ y: 150 })
        .animation({ curve: curves.springMotion() }))// 添加move转场效果，这里的动画参数会跟随上面的TransitionEffect，也就是springMotion()
      .combine(TransitionEffect.move(TransitionEdge.END));

  build() {
    Stack() {
      if (this.isPresent) {
        Column() {
          Text('ArkUI')
            .fontWeight(FontWeight.Bold)
            .fontSize(20)
            .fontColor(Color.White)
        }
        .justifyContent(FlexAlign.Center)
        .width(150)
        .height(150)
        .borderRadius(10)
        .backgroundColor(0xf56c6c)
        // 第二步：将转场效果通过transition接口设置到组件
        .transition(this.effect)
      }

      // 边框
      Column()
        .width(155)
        .height(155)
        .border({
          width: 5,
          radius: 10,
          color: Color.Black
        })

      // 第三步：新增或者删除组件触发转场，控制新增或者删除组件
      Button('Click')
        .margin({ top: 320 })
        .onClick(() => {
          this.isPresent = !this.isPresent;
        })
    }
    .width('100%')
    .height('60%')
  }
}