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
import { NavigationBar } from '../../common/components/navigationBar'
import { GetColor } from '../../common/components/getColor'

@Entry
@Component
struct BasicComponentTemplate {
  @State value: string = 'hello world'
  @State color: Color = Color.Black
  @State fontColor: string = '#182431';
  @State backgroundColor: string = '#2b57f1'
  @State setValue: number = 10;
  @State setBackgroundColor: Color = Color.White;
  @State setProgressColor: Color = Color.Black;
  @State setProgressStyle: number  = ProgressStyle.Linear;
  @State setSliderShowSteps: boolean = true;
  @State setSliderShowTips: boolean = true;
  @State setSliderStep: number = 1;
  @State setSliderStyle: SliderStyle = SliderStyle.OutSet;

  build() {
    Column() {
      NavigationBar({ title: '样式模板' })
      Scroll() {
        Column() {
          Text('显示效果')
            .fontSize(24)
            .fontColor(this.fontColor)
          Text('显示效果')
            .fontSize(24)
            .fontColor(this.fontColor)
          Text('显示效果')
            .fontSize(24)
            .fontColor(this.fontColor)
          Text('显示效果')
            .fontSize(24)
            .fontColor(this.fontColor)
          Text('显示效果')
            .fontSize(24)
            .fontColor(this.fontColor)
          Text('显示效果')
            .fontSize(24)
            .fontColor(this.fontColor)
          Text('显示效果')
            .fontSize(24)
            .fontColor(this.fontColor)
          Text('显示效果')
            .fontSize(24)
            .fontColor(this.fontColor)
          Text('显示效果')
            .fontSize(24)
            .fontColor(this.fontColor)
          Text('显示效果')
            .fontSize(24)
            .fontColor(this.fontColor)
          Text('显示效果')
            .fontSize(24)
            .fontColor(this.fontColor)
          Text('显示效果')
            .fontSize(24)
            .fontColor(this.fontColor)
          Text('显示效果')
            .fontSize(24)
            .fontColor(this.fontColor)
        }
        .width('97%')
        .margin({ right: '3%' })
      }
      .height('45%')
      .padding({ left: 12, right: 12, top: 22, bottom: 22 })
      .backgroundColor(this.backgroundColor)

      Scroll() {
        Column() {

          Row() {
            Text('value')
              .fontSize('16fp')
              .fontColor('#182431')
              .opacity(0.5)
              .fontWeight(FontWeight.Medium)
            Blank()
            Column() {
              Text(`${this.value}`)
                .fontSize('16fp')
                .fontColor('#182431')
                .fontWeight(FontWeight.Medium)
                .width('50%')
                .textAlign(TextAlign.End)
                .bindMenu([
                  {
                    value: 'hello world',
                    action: () => {
                      this.value = 'hello world'
                    }
                  },
                  {
                    value: 'just do it',
                    action: () => {
                      this.value = 'just do it'
                    }
                  },
                  {
                    value: 'to be No.1',
                    action: () => {
                      this.value = 'to be No.1'
                    }
                  },
                ])
            }

          }
          .width('100%')
          .padding('3%')
          .borderRadius(24)
          .backgroundColor('#FFFFFF')

          Row() {
            Text('布尔值')
              .fontSize('16fp')
              .fontColor('#182431')
              .opacity(0.5)
              .fontWeight(FontWeight.Medium)
            Blank()
            Toggle({ type: ToggleType.Switch, isOn: false })
              .height(24)
              .selectedColor('#007DFF')
              .switchPointColor(0xe5ffffff)
              .onChange((isOn: boolean) => {
                console.info('Component status:' + isOn)
              })
          }
          .width('100%')
          .borderRadius(24)
          .backgroundColor('#FFFFFF')
          .margin({ top: 8 })

          Column() {
            Row() {
              Text('progress value')
                .fontSize('16fp')
                .fontColor('#182431')
                .opacity(0.5)
                .fontWeight(FontWeight.Medium)

              Blank()

              Text(this.setValue.toFixed(0))
                .fontSize('16fp')
                .fontColor('#182431')
                .fontWeight(FontWeight.Medium)
            }
            .width('100%')

            Slider({
              value: this.setValue,
              min: 0,
              max: 100,
              step: this.setSliderStep,
              style: this.setSliderStyle
            })
              .width('100%')
              .blockColor('#FFFFFF')
              .trackColor('#183431')
              .selectedColor('#007DFF')
              .borderRadius(12)
              .borderColor('rgba(0,0,0,0.04)')
              .showTips(this.setSliderShowTips)
              .showSteps(this.setSliderShowSteps)
              .onChange((value: number, mode: SliderChangeMode) => {
                this.setValue = value
                console.info('value:' + value + 'mode:' + mode.toString())
              })
          }
          .padding('3%')
          .borderRadius(24)
          .backgroundColor('#FFFFFF')
          .margin({ top: 8 })

          Row() {
            Text('backgroundColor')
              .fontSize('16fp')
              .fontColor('#182431')
              .opacity(0.5)
              .fontWeight(FontWeight.Medium)
            Blank()
            Column() {
              GetColor({ colorVal: $backgroundColor })
            }.width(48)
          }
          .width('100%')
          .padding('3%')
          .borderRadius(24)
          .backgroundColor('#FFFFFF')
          .margin({ top: 8 })

          Row() {
            Text('fontColor')
              .fontSize('16fp')
              .fontColor('#182431')
              .opacity(0.5)
              .fontWeight(FontWeight.Medium)
            Blank()
            Column() {
              GetColor({ colorVal: $fontColor })
            }.width(48)

          }
          .width('100%')
          .padding('3%')
          .borderRadius(24)
          .backgroundColor('#FFFFFF')
          .margin({ top: 8 })

        }
        .width('97%')
        .margin({ right: '3%' })
      }
      .scrollBar(BarState.Off)
      .height('55%')
      .margin({ top: 24 })
    }
    .height('100%')
    .padding({ left: '3%', right: '3%', bottom: 10 })
    .backgroundColor('#F1F3F5')
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
