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

class SetSlt {
  isAnimation: boolean = true

  set(): void {
    this.isAnimation = !this.isAnimation;
  }
}

@Entry
@Component
struct AnimationToAnimationDemo {
  // 第一步：声明相关状态变量
  @State SetAnimation: SetSlt = new SetSlt();

  build() {
    Column() {
      Text('ArkUI')
        .fontWeight(FontWeight.Bold)
        .fontSize(12)
        .fontColor(Color.White)
        .textAlign(TextAlign.Center)
        .borderRadius(10)
        .backgroundColor(0xf56c6c)
        .width(100)
        .height(100)
        .scale({
          // 第二步：将状态变量设置到相关可动画属性接口
          x: this.SetAnimation.isAnimation ? 2 : 1,
          y: this.SetAnimation.isAnimation ? 2 : 1
        })
        .animation({ curve: curves.springMotion(0.4, 0.8) }) // 第四步：通过animation接口开启动画，动画终点值改变时，系统自动添加衔接动画

      Button('Click')
        .margin({ top: 200 })
        .onClick(() => {
          // 第三步：通过点击事件改变状态变量值，影响可动画属性值
          this.SetAnimation.set()
        })
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
  }
}