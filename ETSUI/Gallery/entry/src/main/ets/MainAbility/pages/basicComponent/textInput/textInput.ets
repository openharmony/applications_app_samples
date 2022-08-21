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
import { GetColor } from '../../../common/components/getColor'

@Entry
@Component
struct TextInputSample {
  @State inputType: string = 'Normal'
  @State placeholderColor: string = 'rgba(0,0,0,1)';
  @State placeholderfontSize: number = 20;
  @State placeholderfontWeight: number = 200;
  @State placeholderfontFamily: string = 'Microsoft YaHei';
  @State placeholderfontStyle: string = 'Normal';
  @State enterKeyType: string = 'Done';
  @State caretColor: string = 'rgba(0,0,0,1)';
  @State maxLength: number = 10;
  @State bgColor: string = '#E6E6FA';
  @State textString: string = '';

  build() {
    Column() {
      NavigationBar({ title: 'TextInput' })

      Scroll() {
        Column() {
          Text('文本显示框')
            .fontSize(24)
            .margin({ bottom: 30 })
            .width('100%')
            .textAlign(TextAlign.Center)
          Text(this.textString)
            .fontSize(18).width('100%').textAlign(TextAlign.Start)
        }
        .alignItems(HorizontalAlign.Center)
        .justifyContent(FlexAlign.Center)
        .width('100%')
      }
      .constraintSize({ minHeight: 218, maxHeight: 402 })
      .padding({ left: 12, right: 12, top: 22, bottom: 22 })
      .backgroundColor('#eee')

      Text('textInput输入框')
        .width('100%')
        .height('4%')
        .fontSize(16)
        .fontColor('#111')
        .padding({ left: '3%', right: '3%' })
        .margin({ top: 8, bottom: 8 })

      Row() {
        TextInput({ placeholder: 'input your word textInput' })
          .width('100%')
          .height('100%')
          .type(InputType[this.inputType])
          .placeholderColor(this.placeholderColor)
          .placeholderFont({
            size: this.placeholderfontSize,
            weight: this.placeholderfontWeight,
            family: this.placeholderfontFamily,
            style: FontStyle[this.placeholderfontStyle]
          })
          .enterKeyType(EnterKeyType[this.enterKeyType])
          .caretColor(this.caretColor)
          .maxLength(this.maxLength)
          .onChange((value: string) => {
            this.textString = value;
          })
          .onSubmit((enterKey) => {
            console.log('textInput1')
          })
          .onEditChanged((isEditing) => {
            console.log('textInput2')
          })
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .alignItems(VerticalAlign.Center)
      .height(55)
      .padding({ right: 10 })

      Scroll() {
        Column() {
          Row() {
            Text('inputType')
              .fontSize(16)
              .fontColor('#182431')
              .opacity(0.5)
              .fontWeight(FontWeight.Medium)
            Column() {
              Text(this.inputType)
                .fontSize('16fp')
                .fontWeight(FontWeight.Medium)
                .fontColor('#182431')
            }
            .bindMenu([
              {
                value: 'Normal',
                action: () => {
                  this.inputType = 'Normal'
                },
              },
              {
                value: 'Password',
                action: () => {
                  this.inputType = 'Password'
                },
              },
              {
                value: 'Email',
                action: () => {
                  this.inputType = 'Email'
                },
              },
              {
                value: 'Number',
                action: () => {
                  this.inputType = 'Number'
                },
              },
            ])
          }
          .justifyContent(FlexAlign.SpaceBetween)
          .alignItems(VerticalAlign.Center)
          .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
          .borderRadius(24)
          .backgroundColor('#FFFFFF')
          .height('15%')
          .width('100%')

          Row() {
            Text('placeholderColor')
              .fontSize('16fp')
              .fontColor('#182431')
              .opacity(0.5)
              .fontWeight(FontWeight.Medium)
            Column() {
              GetColor({ colorVal: $placeholderColor })
            }.width(48)
          }
          .justifyContent(FlexAlign.SpaceBetween)
          .alignItems(VerticalAlign.Center)
          .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
          .borderRadius(24)
          .backgroundColor('#FFFFFF')
          .margin({ top: 8 })
          .height('15%')
          .width('100%')

          Row() {
            Text('placeholderfontSize')
              .fontSize('16fp')
              .fontColor('#182431')
              .opacity(0.5)
              .fontWeight(FontWeight.Medium)
            Row() {
              Slider({
                value: this.placeholderfontSize,
                min: 0,
                max: 100,
                step: 1,
                style: SliderStyle.OutSet
              })
                .blockColor('#FFFFFF')
                .trackColor('rgba(24,36,49,0.2)')
                .selectedColor('#007DFF')
                .borderRadius(12)
                .showTips(true)
                .onChange((value: number) => {
                  this.placeholderfontSize = value

                })
              Text(this.placeholderfontSize.toFixed(0))
                .fontSize('16fp')
                .fontWeight(FontWeight.Medium)
                .fontColor('#182431')
            }.width('48%')
          }
          .justifyContent(FlexAlign.Start)
          .alignItems(VerticalAlign.Center)
          .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
          .borderRadius(24)
          .backgroundColor('#FFFFFF')
          .margin({ top: 8 })
          .height('15%')
          .width('100%')

          Row() {
            Text('placeholderfontWeight')
              .fontSize('16fp')
              .fontColor('#182431')
              .opacity(0.5)
              .fontWeight(FontWeight.Medium)
            Row() {
              Slider({
                value: this.placeholderfontWeight,
                min: 100,
                max: 900,
                step: 100,
                style: SliderStyle.OutSet
              })
                .blockColor('#FFFFFF')
                .trackColor('rgba(24,36,49,0.2)')
                .selectedColor('#007DFF')
                .borderRadius(12)
                .showTips(true)
                .onChange((value: number, mode: SliderChangeMode) => {
                  this.placeholderfontWeight = value
                  console.log(`${mode}`)
                })
              Text(this.placeholderfontWeight.toFixed(0))
                .fontSize('16fp')
                .fontWeight(FontWeight.Medium)
                .fontColor('#182431')
            }.width('41%')
          }
          .justifyContent(FlexAlign.Start)
          .alignItems(VerticalAlign.Center)
          .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
          .borderRadius(24)
          .backgroundColor('#FFFFFF')
          .margin({ top: 8 })
          .height('15%')
          .width('100%')

          Row() {
            Text('placeholderfontFamily')
              .fontSize('16fp')
              .fontColor('#182431')
              .opacity(0.5)
              .fontWeight(FontWeight.Medium)
            Column() {
              Text(this.placeholderfontFamily)
                .fontSize('16fp')
                .fontWeight(FontWeight.Medium)
                .fontColor('#182431')
            }
            .bindMenu([
              {
                value: 'Microsoft YaHei',
                action: () => {
                  this.placeholderfontFamily = 'Microsoft YaHei'
                }
              },
              {
                value: 'FangSong',
                action: () => {
                  this.placeholderfontFamily = 'FangSong'
                }
              },
              {
                value: 'SimHei',
                action: () => {
                  this.placeholderfontFamily = 'SimHei'
                }
              },
              {
                value: 'KaiTi',
                action: () => {
                  this.placeholderfontFamily = 'KaiTi'
                }
              }
            ])
          }
          .justifyContent(FlexAlign.SpaceBetween)
          .alignItems(VerticalAlign.Center)
          .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
          .borderRadius(24)
          .backgroundColor('#FFFFFF')
          .margin({ top: 8 })
          .height('15%')
          .width('100%')

          Row() {
            Text('placeholderfontStyle')
              .fontSize('16fp')
              .fontColor('#182431')
              .opacity(0.5)
              .fontWeight(FontWeight.Medium)
            Column() {
              Text(this.placeholderfontStyle)
                .fontSize('16fp')
                .fontWeight(FontWeight.Medium)
                .fontColor('#182431')
            }
            .bindMenu([
              {
                value: 'Normal',
                action: () => {
                  this.placeholderfontStyle = 'Normal'
                }
              },
              {
                value: 'Italic',
                action: () => {
                  this.placeholderfontStyle = 'Italic'
                }
              },
            ])
          }
          .justifyContent(FlexAlign.SpaceBetween)
          .alignItems(VerticalAlign.Center)
          .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
          .borderRadius(24)
          .backgroundColor('#FFFFFF')
          .margin({ top: 8 })
          .height('15%')
          .width('100%')

          Row() {
            Text('enterKeyType')
              .fontSize('16fp')
              .fontColor('#182431')
              .opacity(0.5)
              .fontWeight(FontWeight.Medium)
            Column() {
              Text(this.enterKeyType)
                .fontSize('16fp')
                .fontWeight(FontWeight.Medium)
                .fontColor('#182431')
            }
            .bindMenu([
              {
                value: 'Done',
                action: () => {
                  this.enterKeyType = 'Done'
                },
              },
              {
                value: 'Go',
                action: () => {
                  this.enterKeyType = 'Go'
                },
              },
              {
                value: 'Search',
                action: () => {
                  this.enterKeyType = 'Search'
                },
              },
              {
                value: 'Send',
                action: () => {
                  this.enterKeyType = 'Send'
                },
              },
              {
                value: 'Next',
                action: () => {
                  this.enterKeyType = 'Next'
                },
              },
            ])
          }
          .justifyContent(FlexAlign.SpaceBetween)
          .alignItems(VerticalAlign.Center)
          .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
          .borderRadius(24)
          .backgroundColor('#FFFFFF')
          .margin({ top: 8 })
          .height('15%')
          .width('100%')

          Row() {
            Text('caretColor')
              .fontSize('16fp')
              .fontColor('#182431')
              .opacity(0.5)
              .fontWeight(FontWeight.Medium)
            Column() {
              GetColor({ colorVal: $caretColor })
            }.width(48)

          }
          .justifyContent(FlexAlign.SpaceBetween)
          .alignItems(VerticalAlign.Center)
          .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
          .borderRadius(24)
          .backgroundColor('#FFFFFF')
          .margin({ top: 8 })
          .height('15%')
          .width('100%')

          Row() {
            Text('maxLength')
              .fontSize('16fp')
              .fontColor('#182431')
              .opacity(0.5)
              .fontWeight(FontWeight.Medium)
            Column() {
              Text('' + this.maxLength)
                .fontSize('16fp')
                .fontWeight(FontWeight.Medium)
                .fontColor('#182431')
            }
            .bindMenu([
              {
                value: '10',
                action: () => {
                  this.maxLength = 10
                },
              },
              {
                value: '20',
                action: () => {
                  this.maxLength = 20

                },
              },
              {
                value: '30',
                action: () => {
                  this.maxLength = 30
                },
              }
            ])
          }
          .justifyContent(FlexAlign.SpaceBetween)
          .alignItems(VerticalAlign.Center)
          .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
          .borderRadius(24)
          .backgroundColor('#FFFFFF')
          .margin({ top: 8 })
          .height('15%')
          .width('100%')
        }
        .width('97%')
        .margin({ right: '3%', bottom: 5 })
      }
      .width('100%')
      .height('50%')
      .margin({ bottom: 60 })
    }
    .alignItems(HorizontalAlign.Center)
    .padding({ left: '3%', right: '3%' })
    .height('100%')
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