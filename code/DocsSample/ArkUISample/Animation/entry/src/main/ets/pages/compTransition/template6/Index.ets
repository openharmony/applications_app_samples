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
  // [Start transition_animation]
  // 出现时会是所有转场效果的出现效果叠加，消失时会是所有消失转场效果的叠加
  // 说明各个effect跟随的动画参数
  private effect: object =
    TransitionEffect.OPACITY // 创建了透明度转场效果，这里没有调用animation接口，会跟随animateTo的动画参数
      // 通过combine方法，添加缩放转场效果，并指定了springMotion(0.6, 1.2)曲线
      .combine(TransitionEffect.scale({ x: 0, y: 0 }).animation({ curve: curves.springMotion(0.6, 1.2) }))
      // 添加旋转转场效果，这里的动画参数会跟随上面的TransitionEffect，也就是springMotion(0.6, 1.2)
      .combine(TransitionEffect.rotate({ angle: 90 }))
      // 添加平移转场效果，动画参数会跟随其之上带animation的TransitionEffect，也就是springMotion(0.6, 1.2)
      .combine(TransitionEffect.translate({ x: 150, y: 150 }))
      // 添加move转场效果，并指定了springMotion曲线
      .combine(TransitionEffect.move(TransitionEdge.END)).animation({curve: curves.springMotion()})
      // 添加非对称的转场效果，由于这里没有设置animation，会跟随上面的TransitionEffect的animation效果，也就是springMotion
      .combine(TransitionEffect.asymmetric(TransitionEffect.scale({
        x: 0,
        y: 0
      }), TransitionEffect.rotate({ angle: 90 })));
  // [End transition_animation]
  build() {
    Stack() {
      if (this.isPresent) {
        Column() {
          Text('Test')
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

      Column() {
        Button('Click1')
          .margin({ bottom: 10 })
          .onClick(() => {
            // 方式一：直接控制删除或者新增组件，动画参数由TransitionEffect的animation接口配置
            this.isPresent = !this.isPresent;
          })

        Button('Click2')
          .onClick(() => {
            // 方式二：将控制变量放到animateTo闭包内，未通过animation接口定义动画参数的TransitionEffect将跟随animateTo的动画参数
            this.getUIContext()?.animateTo({ curve: curves.springMotion() }, () => {
              this.isPresent = !this.isPresent;
            })
          })
      }
      .margin({ top: 320 })
    }
    .width('100%')
    .height('60%')
  }
}