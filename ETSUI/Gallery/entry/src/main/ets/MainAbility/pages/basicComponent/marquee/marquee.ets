/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
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

import { NavigationBar } from '../../../common/components/navigationBar'
import { MenuComponent } from '../../../common/components/menuComponent'

@Entry
@Component
struct MarqueeSample {
  @State start: boolean = false;
  @State fromStart: boolean = true;
  @State step: number = 50;
  @State loop: number = 2;
  @State src: string = 'Running Marquee starts rolling';
  @State isOn: boolean = false;
  @State content: any[] = [5, 25, 50, 75]

  build() {
    Column() {
      NavigationBar({ title: 'Marquee' })
      Column() {
        Column() {
          Text('Marquee')
            .fontSize(30)
            .fontWeight(FontWeight.Bold)
            .margin({ bottom: 30 })
          Marquee({
            start: this.start,
            step: this.step,
            loop: this.loop,
            fromStart: this.fromStart,
            src: this.src
          })
            .fontColor(Color.White)
            .fontSize(50)
            .allowScale(false)
            .fontWeight(FontWeight.Bold)
            .backgroundColor(Color.Black)
            .onStart(() => {
              console.log('Marquee animation complete onStart')
            })
            .onBounce(() => {
              console.log('Marquee animation complete onBounce')
            })
            .onFinish(() => {
              console.log('Marquee animation complete onFinish')
              this.start = false
            })
        }
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center)
      }
      .width('100%')
      .constraintSize({ minHeight: 218, maxHeight: 302 })
      .backgroundColor('#FFB6C1')
      .padding({ left: 12, right: 12, top: 22, bottom: 22 })

      Scroll() {
        Column() {
          Row() {
            Button('start')
              .borderRadius(14)
              .backgroundColor('#007DFF')
              .fontSize('12fp')
              .fontWeight(FontWeight.Medium)
              .fontColor('#FFFFFF')
              .padding({ left: 8, right: 8, top: 8, bottom: 8 })
              .onClick(() => {
                this.start = true
              })
            Button('stop')
              .borderRadius(14)
              .backgroundColor('#007DFF')
              .fontSize('12fp')
              .fontWeight(FontWeight.Medium)
              .fontColor('#FFFFFF')
              .padding({ left: 8, right: 8, top: 8, bottom: 8 })
              .onClick(() => {
                this.start = false
              })
          }
          .alignItems(VerticalAlign.Center)
          .justifyContent(FlexAlign.SpaceBetween)
          .width('100%')
          .height(35)

          Row() {
            Text('fromStart')
              .fontColor('#182431')
              .fontSize('16fp')
              .fontWeight(FontWeight.Medium)
              .opacity(0.5)

            Blank()

            Toggle({ type: ToggleType.Switch, isOn: this.isOn })
              .width(35)
              .height(20)
              .selectedColor('#007DFF')
              .switchPointColor(0xe5ffffff)
              .onChange((isOn: boolean) => {
                console.info('Component status:' + isOn)
                this.fromStart = !this.fromStart
                this.isOn = !this.isOn
                this.start = false
              })
          }
          .justifyContent(FlexAlign.SpaceBetween)
          .alignItems(VerticalAlign.Center)
          .width('100%')
          .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
          .borderRadius(24)
          .backgroundColor('#FFFFFF')
          .margin({ top: 8 })

          // 控件写法
          MenuComponent({ title: 'step', transferParameters: $content, items: $step })
          Row() {
            Text('loop')
              .fontColor('#182431')
              .fontSize('16fp')
              .fontWeight(FontWeight.Medium)
              .opacity(0.5)

            Blank()

            Text(`${this.loop}`)
              .fontColor('#182431')
              .fontSize('16fp')
              .fontWeight(FontWeight.Medium)
              .width('50%')
              .textAlign(TextAlign.End)
              .bindMenu([
                {
                  value: '-1',
                  action: () => {
                    this.loop = -1
                  }
                },
                {
                  value: '3',
                  action: () => {
                    this.loop = 3
                  }
                },
                {
                  value: '5',
                  action: () => {
                    this.loop = 5
                  }
                },
                {
                  value: '10',
                  action: () => {
                    this.loop = 10
                  }
                },
              ])
          }
          .width('100%')
          .justifyContent(FlexAlign.SpaceBetween)
          .alignItems(VerticalAlign.Center)
          .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
          .borderRadius(24)
          .backgroundColor('#FFFFFF')
          .margin({ top: 8 })

          Row() {
            Text('src')
              .fontColor('#182431')
              .fontSize('16fp')
              .fontWeight(FontWeight.Medium)
              .opacity(0.5)

            Blank()

            Text(`${this.src}`)
              .fontColor('#182431')
              .fontSize('16fp')
              .fontWeight(FontWeight.Medium)
              .width('50%')
              .textAlign(TextAlign.End)
              .bindMenu([
                {
                  value: 'Enter by yourself',
                  action: () => {
                    this.src = 'Enter by yourself'
                  }
                },
                {
                  value: 'Running Marquee starts rolling',
                  action: () => {
                    this.src = 'Running Marquee starts rolling'
                  }
                },
              ])
          }
          .width('100%')
          .justifyContent(FlexAlign.SpaceBetween)
          .alignItems(VerticalAlign.Center)
          .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
          .borderRadius(24)
          .backgroundColor('#FFFFFF')
          .margin({ top: 8 })
        }
      }
      .margin({ top: 24 })
    }
    .height('100%')
    .justifyContent(FlexAlign.Start)
    .alignItems(HorizontalAlign.Center)
    .backgroundColor('#F1F3F5')
    .padding({ left: '3%', right: '3%', bottom: 10 })
  }

  pageTransition() {
    PageTransitionEnter({ duration: 370, curve: Curve.Friction })
      .slide(SlideEffect.Bottom)
      .opacity(0.0)

    PageTransitionExit({ duration: 370, curve: Curve.Friction })
      .slide(SlideEffect.Bottom)
      .opacity(0.0)
  }
}