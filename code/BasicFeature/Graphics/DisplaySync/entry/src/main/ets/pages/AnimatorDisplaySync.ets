/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import animator, { AnimatorResult } from '@ohos.animator';
import router from '@ohos.router';

@Entry
@Component
struct AnimatorTest {
  private TAG: string = '[AnimatorTest]';
  private backAnimator10: AnimatorResult | undefined = undefined;
  private backAnimator30: AnimatorResult | undefined = undefined;
  private backAnimator60: AnimatorResult | undefined = undefined;
  private flag: boolean = false;
  @State wid10: number = 20;
  @State hei10: number = 20;
  @State wid30: number = 20;
  @State hei30: number = 20;
  @State wid60: number = 20;
  @State hei60: number = 20;

  create() {
    let _this = this
    // 创建一个动画类
    this.backAnimator10 = animator.create({
      duration: 2000,
      easing: "ease", // 动画开始和结束时的速度较慢
      delay: 0,
      fill: "forwards", // 在动画结束后，目标将保留动画结束时的状态（在最后一个关键帧中定义）
      direction: "normal", // 动画正向循环播放
      iterations: 1, // 动画播放次数
      begin: 100,
      end: 200
    })

    let expectedFrameRate10: ExpectedFrameRateRange = {
      min: 0,
      max: 120,
      expected: 10
    }
    // 设置期望的帧率范围，预期帧率为10hz
    this.backAnimator10.setExpectedFrameRateRange(expectedFrameRate10);
    // 每帧回调设置长和宽
    this.backAnimator10.onFrame = (value: number) => {
      _this.wid10 = value
      _this.hei10 = value
    }

    this.backAnimator30 = animator.create({
      duration: 2000,
      easing: "ease", // 动画开始和结束时的速度较慢
      delay: 0,
      fill: "forwards", // 在动画结束后，目标将保留动画结束时的状态（在最后一个关键帧中定义）
      direction: "normal", // 动画正向循环播放
      iterations: 1, // 动画播放次数
      begin: 100,
      end: 200
    })

    let expectedFrameRate30: ExpectedFrameRateRange = {
      min: 0,
      max: 120,
      expected: 30
    }
    // 设置期望的帧率范围，预期帧率为30hz
    this.backAnimator30.setExpectedFrameRateRange(expectedFrameRate30);
    // 每帧回调设置长和宽
    this.backAnimator30.onFrame = (value: number) => {
      _this.wid30 = value
      _this.hei30 = value
    }

    this.backAnimator60 = animator.create({
      duration: 2000,
      easing: "ease", // 动画开始和结束时的速度较慢
      delay: 0,
      fill: "forwards", // 在动画结束后，目标将保留动画结束时的状态（在最后一个关键帧中定义）
      direction: "normal", // 动画正向循环播放
      iterations: 1, // 动画播放次数
      begin: 100,
      end: 200
    })

    let expectedFrameRate60: ExpectedFrameRateRange = {
      min: 0,
      max: 120,
      expected: 60
    }
    // 设置期望的帧率范围，预期帧率为60hz
    this.backAnimator60.setExpectedFrameRateRange(expectedFrameRate60);
    // 每帧回调设置长和宽
    this.backAnimator60.onFrame = (value: number) => {
      _this.wid60 = value
      _this.hei60 = value
    }
  }

  aboutToDisappear() {
    // 由于backAnimator在onFrame中引用了this, this中保存了backAnimator，
    // 在自定义组件消失时应该将保存在组件中的backAnimator置空，避免内存泄漏
    this.backAnimator10 = undefined;
    this.backAnimator30 = undefined;
    this.backAnimator60 = undefined;
  }

  build() {
    Column() {
      Row() {
        Text('10fps')
          .fontWeight(FontWeight.Bold)
          .fontSize(12)
          .fontColor(Color.Black)
          .textAlign(TextAlign.Start)
          .width(40)
          .height(150)
        Column() {
          Column()
            // 设置容器的长和宽
            .width(this.wid10)
            .height(this.hei10)
            .backgroundColor(Color.Red)
        }
        .alignItems(HorizontalAlign.Center)
        .width('60%')
      }.height('30%')

      Row() {
        Text('30fps')
          .fontWeight(FontWeight.Bold)
          .fontSize(12)
          .fontColor(Color.Black)
          .textAlign(TextAlign.Start)
          .width(40)
          .height(30)
        Column() {
          Column()
            // 设置容器的长和宽
            .width(this.wid30)
            .height(this.hei30)
            .backgroundColor(Color.Green)
        }
        .alignItems(HorizontalAlign.Center)
        .width('60%')
      }.height('30%')

      Row() {
        Text('60fps')
          .fontWeight(FontWeight.Bold)
          .fontSize(12)
          .fontColor(Color.Black)
          .textAlign(TextAlign.Start)
          .width(40)
          .height(30)
        Column() {
          Column()
            // 设置容器的长和宽
            .width(this.wid60)
            .height(this.hei60)
            .backgroundColor(Color.Blue)
        }
        .alignItems(HorizontalAlign.Center)
        .width('60%')
      }.height('30%')


      Row() {
        Button('Create')
          .id('AnimatorCreate')
          .fontSize(14)
          .fontWeight(500)
          .margin({ bottom: 10, left: 5 })
          .fontColor(Color.White)
          .onClick(() => {
            this.create()
          })
          .width('30%')
          .height(40)
          .shadow(ShadowStyle.OUTER_DEFAULT_LG)

        Button('Play')
          .id('AnimatorPlay')
          .fontSize(14)
          .fontWeight(500)
          .margin({ bottom: 10, left: 5 })
          .fontColor(Color.White)
          .onClick(() => {
            this.flag = false
            // 启动动画
            this.backAnimator10?.play()
            this.backAnimator30?.play()
            this.backAnimator60?.play()
          })
          .width('30%')
          .height(40)
          .shadow(ShadowStyle.OUTER_DEFAULT_LG)

        Button('Back')
          .id('AnimatorBack')
          .fontSize(14)
          .fontWeight(500)
          .margin({ bottom: 10, left: 5 })
          .fontColor(Color.White)
          .onClick((): void => {
            router.back();
          })
          .width('30%')
          .height(40)
          .shadow(ShadowStyle.OUTER_DEFAULT_LG)
      }
      .width('100%')
      .justifyContent(FlexAlign.Center)
      .shadow(ShadowStyle.OUTER_DEFAULT_SM)
      .alignItems(VerticalAlign.Bottom)
      .layoutWeight(1)
    }
  }
}