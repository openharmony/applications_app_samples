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
import Matrix4 from '@ohos.matrix4'
import { NavigationBar } from '../../../common/components/navigationBar'

@Entry
@Component
struct TransformExample {
  @State rotate: any = { x: 200, y: 200, z: 275 }
  @State translate: any = { x: 200, y: 200, z: 200 }
  @State transform: any = { x: 200, y: 200, z: 200 }
  @State scale: any = { x: 1, y: 1, z: 1 }
  @State rotateCenter: any = { X: 150, Y: 150 }
  @State scaleCenter: any = { X: 150, Y: 150 }
  @State angle: number = 360
  @State index: number = 0
  private controller: TabsController = new TabsController()
  private init() {
    this.rotate = { x: 200, y: 200, z: 275 }
    this.transform = { x: 200, y: 200, z: 200 }
    this.translate = { x: 200, y: 200, z: 200 }
    this.scale = { x: 1, y: 1, z: 1 }
    this.rotateCenter = { X: 150, Y: 150 }
    this.scaleCenter = { X: 150, Y: 150 }
    this.angle = 360
  }

  build() {
    Column() {
      NavigationBar({ title: '图形变换' })
      Column() {
        Scroll() {
          Column() {
            Column() {
              Row()
                .rotate({
                  x: this.rotate.x - 200,
                  y: this.rotate.y - 200,
                  z: this.rotate.z - 200,
                  centerX: `${this.rotateCenter.X - 100}%`,
                  centerY: `${this.rotateCenter.Y - 100}%`,
                  angle: this.angle - 360
                })

                .translate({
                  x: this.translate.x - 200,
                  y: this.translate.y - 200,
                  z: this.translate.z - 200
                })

                .scale({
                  x: this.scale.x,
                  y: this.scale.y,
                  z: this.scale.z,
                  centerX: `${this.scaleCenter.X - 100}%`,
                  centerY: `${this.scaleCenter.Y - 100}%`
                })

                .transform(Matrix4.identity)
                .translate({
                  x: this.transform.x - 200,
                  y: this.transform.y - 200,
                  z: this.transform.z - 200
                })
                .gesture(
                PanGesture()
                  .onActionUpdate((event: GestureEvent) => {
                    this.translate.x = event.offsetX + 200
                    this.translate.y = event.offsetY + 200
                  })
                )
                .width(150)
                .height(150)
                .zIndex(999)
                .backgroundColor('red')
            }
            .width('100%')
            .height('100%')
            .alignItems(HorizontalAlign.Center)
            .justifyContent(FlexAlign.Start)
            .gesture(
            RotationGesture()
              .onActionUpdate((event: GestureEvent) => {
                this.angle = event.angle + 360
              })
            )
          }
          .width('100%')
          .height('100%')
          .backgroundColor('#FFB6C1')
          .zIndex(999)
          .gesture(
          PinchGesture()
            .onActionUpdate((event: GestureEvent) => {
              this.scale.x = event.scale
              this.scale.y = event.scale
              this.scale.z = event.scale
            })
          )
        }
      }
      .height('30%')
      .width('100%')
      .padding(18)
      .backgroundColor('#FFFFFF')

      Column() {
        Tabs({ barPosition: BarPosition.Start, index: this.index, controller: this.controller }) {
          TabContent() {
            Column() {
              Column() {
                Row({ space: FlexAlign.SpaceBetween }) {
                  Text('X')
                    .fontWeight(FontWeight.Medium)
                    .fontColor('#182431')
                    .opacity(0.5)
                    .fontSize('16fp')

                  Blank()

                  Text(`${(this.rotate.x - 200).toFixed(0)}`)
                    .fontWeight(FontWeight.Regular)
                    .fontColor('#000000')
                    .fontSize('16fp')
                }

                Slider({
                  value: this.rotate.x,
                  min: 0,
                  max: 400,
                  step: 1,
                  style: SliderStyle.OutSet
                })
                  .blockColor('#FFFFFF')
                  .trackColor('#182431')
                  .selectedColor('#007DFF')
                  .width('100%')
                  .showSteps(true)
                  .showTips(false)
                  .onChange((value: number) => {
                    this.rotate.x = value
                  })
              }
              .width('100%')
              .justifyContent(FlexAlign.Center)
              .padding({ left: '3%', right: '3%' })
              .borderRadius(24)
              .backgroundColor('#FFFFFF')
              .margin(8)

              Column() {
                Row({ space: FlexAlign.SpaceBetween }) {
                  Text('Y')
                    .fontWeight(FontWeight.Medium)
                    .fontColor('#182431')
                    .opacity(0.5)
                    .fontSize('16fp')

                  Blank()

                  Text(`${(this.rotate.y - 200).toFixed(0)}`)
                    .fontWeight(FontWeight.Regular)
                    .fontColor('#000000')
                    .fontSize('16fp')
                }

                Slider({
                  value: this.rotate.y,
                  min: 0,
                  max: 400,
                  step: 1,
                  style: SliderStyle.OutSet
                })
                  .blockColor('#FFFFFF')
                  .trackColor('#182431')
                  .selectedColor('#007DFF')
                  .width('100%')
                  .showSteps(true)
                  .showTips(false)
                  .onChange((value: number) => {
                    this.rotate.y = value
                  })
              }
              .width('100%')
              .justifyContent(FlexAlign.Center)
              .padding({ left: '3%', right: '3%' })
              .borderRadius(24)
              .backgroundColor('#FFFFFF')
              .margin({ top: 8 })

              Column() {
                Row({ space: FlexAlign.SpaceBetween }) {
                  Text('Z')
                    .fontWeight(FontWeight.Medium)
                    .fontColor('#182431')
                    .opacity(0.5)
                    .fontSize('16fp')

                  Blank()

                  Text(`${(this.rotate.z - 200).toFixed(0)}`)
                    .fontWeight(FontWeight.Regular)
                    .fontColor('#000000')
                    .fontSize('16fp')
                }

                Slider({
                  value: this.rotate.z,
                  min: 0,
                  max: 400,
                  step: 1,
                  style: SliderStyle.OutSet
                })
                  .blockColor('#FFFFFF')
                  .trackColor('#182431')
                  .selectedColor('#007DFF')
                  .width('100%')
                  .showSteps(true)
                  .showTips(false)
                  .onChange((value: number) => {
                    this.rotate.z = value
                  })
              }
              .justifyContent(FlexAlign.Center)
              .width('100%')
              .padding({ left: '3%', right: '3%' })
              .borderRadius(24)
              .backgroundColor('#FFFFFF')
              .margin({ top: 8 })

              Column() {
                Row({ space: FlexAlign.SpaceBetween }) {
                  Text('angle')
                    .fontWeight(FontWeight.Medium)
                    .fontColor('#182431')
                    .opacity(0.5)
                    .fontSize('16fp')

                  Blank()

                  Text(`${(this.angle - 360).toFixed(0)}`)
                    .fontWeight(FontWeight.Regular)
                    .fontColor('#000000')
                    .fontSize('16fp')
                }

                Slider({
                  value: this.angle,
                  min: 0,
                  max: 720,
                  step: 1,
                  style: SliderStyle.OutSet
                })
                  .blockColor('#FFFFFF')
                  .trackColor('#182431')
                  .selectedColor('#007DFF')
                  .width('100%')
                  .showSteps(true)
                  .showTips(false)
                  .onChange((value: number) => {
                    this.angle = value
                  })
              }
              .justifyContent(FlexAlign.Center)
              .width('100%')
              .padding({ left: '3%', right: '3%' })
              .borderRadius(24)
              .backgroundColor('#FFFFFF')
              .margin({ top: 8 })

              Column() {
                Row({ space: FlexAlign.SpaceBetween }) {
                  Text('centerX')
                    .fontWeight(FontWeight.Medium)
                    .fontColor('#182431')
                    .opacity(0.5)
                    .fontSize('16fp')

                  Blank()

                  Text('' + (this.rotateCenter.X - 100).toFixed(0) + '%')
                    .fontWeight(FontWeight.Regular)
                    .fontColor('#000000')
                    .fontSize('16fp')
                }
                .justifyContent(FlexAlign.Center)

                Slider({
                  value: this.rotateCenter.X,
                  min: 0,
                  max: 200,
                  step: 1,
                  style: SliderStyle.OutSet
                })
                  .blockColor('#FFFFFF')
                  .trackColor('#182431')
                  .selectedColor('#007DFF')
                  .width('100%')
                  .showSteps(true)
                  .showTips(false)
                  .onChange((value: number) => {
                    this.rotateCenter.X = value
                  })
              }
              .width('100%')
              .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
              .borderRadius(24)
              .backgroundColor('#FFFFFF')
              .margin({ top: 8 })

              Column() {
                Row({ space: FlexAlign.SpaceBetween }) {
                  Text('centerY')
                    .fontWeight(FontWeight.Medium)
                    .fontColor('#182431')
                    .opacity(0.5)
                    .fontSize('16fp')

                  Blank()

                  Text('' + (this.rotateCenter.Y - 100).toFixed(0) + '%')
                    .fontWeight(FontWeight.Regular)
                    .fontColor('#000000')
                    .fontSize('16fp')
                }

                Slider({
                  value: this.rotateCenter.Y,
                  min: 0,
                  max: 200,
                  step: 1,
                  style: SliderStyle.OutSet
                })
                  .blockColor('#FFFFFF')
                  .trackColor('#182431')
                  .selectedColor('#007DFF')
                  .width('100%')
                  .showSteps(true)
                  .showTips(false)
                  .onChange((value: number) => {
                    this.rotateCenter.Y = value
                  })
              }
              .justifyContent(FlexAlign.Center)
              .width('100%')
              .padding({ left: '3%', right: '3%' })
              .borderRadius(24)
              .backgroundColor('#FFFFFF')
              .margin({ top: 8 })
            }
          }.tabBar('rotate')

          TabContent() {
            Column() {
              Column() {
                Row({ space: FlexAlign.SpaceBetween }) {
                  Text('X')
                    .fontWeight(FontWeight.Medium)
                    .fontColor('#182431')
                    .opacity(0.5)
                    .fontSize('16fp')

                  Blank()

                  Text('' + (this.translate.x - 200).toFixed(0))
                    .fontSize('16fp')
                    .fontWeight(FontWeight.Medium)
                }

                Slider({
                  value: this.translate.x,
                  min: 0,
                  max: 400,
                  step: 0.1,
                  style: SliderStyle.OutSet
                })
                  .blockColor('#FFFFFF')
                  .trackColor('#182431')
                  .selectedColor('#007DFF')
                  .width('100%')
                  .showSteps(true)
                  .showTips(false)
                  .onChange((value: number) => {
                    this.translate.x = value
                  })
              }
              .width('100%')
              .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
              .borderRadius(24)
              .backgroundColor('#FFFFFF')
              .margin(8)

              Column() {
                Row({ space: FlexAlign.SpaceBetween }) {
                  Text('Y')
                    .fontWeight(FontWeight.Medium)
                    .fontColor('#182431')
                    .opacity(0.5)
                    .fontSize('16fp')

                  Blank()

                  Text('' + (this.translate.y - 200).toFixed(0))
                    .fontSize('16fp')
                    .fontWeight(FontWeight.Medium)
                }

                Slider({
                  value: this.translate.y,
                  min: 0,
                  max: 400,
                  step: 1,
                  style: SliderStyle.OutSet
                })
                  .blockColor('#FFFFFF')
                  .trackColor('#182431')
                  .selectedColor('#007DFF')
                  .width('100%')
                  .showSteps(true)
                  .showTips(false)
                  .onChange((value: number) => {
                    this.translate.y = value
                  })
              }
              .width('100%')
              .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
              .borderRadius(24)
              .backgroundColor('#FFFFFF')
              .margin(8)

              Column() {
                Row({ space: FlexAlign.SpaceBetween }) {
                  Text('Z')
                    .fontWeight(FontWeight.Medium)
                    .fontColor('#182431')
                    .opacity(0.5)
                    .fontSize('16fp')

                  Blank()

                  Text('' + (this.translate.z - 200).toFixed(0))
                    .fontSize('16fp')
                    .fontWeight(FontWeight.Medium)
                }

                Slider({
                  value: this.translate.z,
                  min: 0,
                  max: 400,
                  step: 1,
                  style: SliderStyle.OutSet
                })
                  .blockColor('#FFFFFF')
                  .trackColor('#182431')
                  .selectedColor('#007DFF')
                  .width('100%')
                  .showSteps(true)
                  .showTips(false)
                  .onChange((value: number) => {
                    this.translate.z = value
                  })
              }
              .width('100%')
              .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
              .borderRadius(24)
              .backgroundColor('#FFFFFF')
              .margin(8)
            }
          }.tabBar('translate')

          TabContent() {
            Column() {
              Row({ space: FlexAlign.SpaceBetween }) {
                Text('X')
                  .fontWeight(FontWeight.Medium)
                  .fontColor('#182431')
                  .opacity(0.5)
                  .fontSize('16fp')

                Blank()

                Column() {
                  Counter() {
                    Text(this.scale.x.toFixed(1).toString()).fontSize(16)
                  }
                  .height(24)
                  .onInc(() => {
                      this.scale.x < 5 ? this.scale.x += 0.1 : this.scale.x

                  })
                  .onDec(() => {
                      this.scale.x > 0.1 ? this.scale.x -= 0.1 : this.scale.x
                  })
                }
              }
              .alignItems(VerticalAlign.Center)
              .width('100%')
              .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
              .borderRadius(24)
              .backgroundColor('#FFFFFF')
              .margin(8)

              Row({ space: FlexAlign.SpaceBetween }) {
                Text('Y')
                  .fontWeight(FontWeight.Medium)
                  .fontColor('#182431')
                  .opacity(0.5)
                  .fontSize('16fp')

                Blank()

                Column() {
                  Counter() {
                    Text(this.scale.y.toFixed(1).toString()).fontSize(16)
                  }
                  .height(24)
                  .onInc(() => {
                      this.scale.y < 5 ? this.scale.y += 0.1 : this.scale.y

                  })
                  .onDec(() => {
                      this.scale.y > 0.1 ? this.scale.y -= 0.1 : this.scale.y
                  })
                }
              }
              .alignItems(VerticalAlign.Center)
              .width('100%')
              .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
              .borderRadius(24)
              .backgroundColor('#FFFFFF')
              .margin(8)

              Row({ space: FlexAlign.SpaceBetween }) {
                Text('Z')
                  .fontWeight(FontWeight.Medium)
                  .fontColor('#182431')
                  .opacity(0.5)
                  .fontSize('16fp')

                Blank()

                Column() {
                  Counter() {
                    Text(this.scale.z.toFixed(1).toString()).fontSize(16)
                  }
                  .height(24)
                  .onInc(() => {
                      this.scale.z < 5 ? this.scale.z += 0.1 : this.scale.z

                  })
                  .onDec(() => {
                      this.scale.z > 0.1 ? this.scale.z -= 0.1 : this.scale.z
                  })
                }
              }
              .alignItems(VerticalAlign.Center)
              .width('100%')
              .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
              .borderRadius(24)
              .backgroundColor('#FFFFFF')
              .margin(8)

              Column() {
                Row({ space: FlexAlign.SpaceBetween }) {
                  Text('centerX')
                    .fontWeight(FontWeight.Medium)
                    .fontColor('#182431')
                    .opacity(0.5)
                    .fontSize('16fp')

                  Blank()

                  Text('' + (this.scaleCenter.X - 100).toFixed(0) + '%')
                    .fontSize('16fp')
                    .fontWeight(FontWeight.Medium)
                }

                Slider({
                  value: this.scaleCenter.X,
                  min: 0,
                  max: 200,
                  step: 1,
                  style: SliderStyle.OutSet
                })
                  .blockColor('#FFFFFF')
                  .trackColor('#182431')
                  .selectedColor('#007DFF')
                  .width('100%')
                  .showSteps(true)
                  .showTips(false)
                  .onChange((value: number) => {
                    this.scaleCenter.X = value
                  })
              }
              .width('100%')
              .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
              .borderRadius(24)
              .backgroundColor('#FFFFFF')
              .margin(8)

              Column() {
                Row({ space: FlexAlign.SpaceBetween }) {
                  Text('centerY')
                    .fontWeight(FontWeight.Medium)
                    .fontColor('#182431')
                    .opacity(0.5)
                    .fontSize('16fp')

                  Blank()

                  Text('' + (this.scaleCenter.Y - 100).toFixed(0) + '%')
                    .fontSize('16fp')
                    .fontWeight(FontWeight.Medium)
                }

                Slider({
                  value: this.scaleCenter.Y,
                  min: 0,
                  max: 200,
                  step: 1,
                  style: SliderStyle.OutSet
                })
                  .blockColor('#FFFFFF')
                  .trackColor('#182431')
                  .selectedColor('#007DFF')
                  .width('100%')
                  .showSteps(true)
                  .showTips(false)
                  .onChange((value: number) => {
                    this.scaleCenter.Y = value
                  })
              }
              .width('100%')
              .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
              .borderRadius(24)
              .backgroundColor('#FFFFFF')
              .margin(8)
            }
          }.tabBar('scale')

          TabContent() {
            Column() {
              Column() {
                Row({ space: FlexAlign.SpaceBetween }) {
                  Text('X:')
                    .fontWeight(FontWeight.Medium)
                    .fontColor('#182431')
                    .opacity(0.5)
                    .fontSize('16fp')

                  Blank()

                  Text('' + (this.transform.x - 200).toFixed(0))
                    .fontSize('16fp')
                    .fontWeight(FontWeight.Medium)
                }

                Slider({
                  value: this.transform.x,
                  min: 0,
                  max: 400,
                  step: 1,
                  style: SliderStyle.OutSet
                })
                  .blockColor('#FFFFFF')
                  .trackColor('#182431')
                  .selectedColor('#007DFF')
                  .width('100%')
                  .showSteps(true)
                  .showTips(false)
                  .onChange((value: number) => {
                    this.transform.x = value
                  })
              }
              .width('100%')
              .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
              .borderRadius(24)
              .backgroundColor('#FFFFFF')
              .margin(8)

              Column() {
                Row({ space: FlexAlign.SpaceBetween }) {
                  Text('Y')
                    .fontWeight(FontWeight.Medium)
                    .fontColor('#182431')
                    .opacity(0.5)
                    .fontSize('16fp')

                  Blank()

                  Text('' + (this.transform.y - 200).toFixed(0))
                    .fontSize('16fp')
                    .fontWeight(FontWeight.Medium)
                }

                Slider({
                  value: this.transform.y,
                  min: 0,
                  max: 400,
                  step: 1,
                  style: SliderStyle.OutSet
                })
                  .blockColor('#FFFFFF')
                  .trackColor('#182431')
                  .selectedColor('#007DFF')
                  .width('100%')
                  .showSteps(true)
                  .showTips(false)
                  .onChange((value: number) => {
                    this.transform.y = value
                  })
              }
              .width('100%')
              .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
              .borderRadius(24)
              .backgroundColor('#FFFFFF')
              .margin(8)

              Column() {
                Row({ space: FlexAlign.SpaceBetween }) {
                  Text('Z')
                    .fontWeight(FontWeight.Medium)
                    .fontColor('#182431')
                    .opacity(0.5)
                    .fontSize('16fp')

                  Blank()

                  Text('' + (this.transform.z - 200).toFixed(0))
                    .fontSize('16fp')
                    .fontWeight(FontWeight.Medium)
                }

                Slider({
                  value: this.transform.z,
                  min: 0,
                  max: 400,
                  step: 1,
                  style: SliderStyle.OutSet
                })
                  .blockColor('#FFFFFF')
                  .trackColor('#182431')
                  .selectedColor('#007DFF')
                  .width('100%')
                  .showSteps(true)
                  .showTips(false)
                  .onChange((value: number) => {
                    this.transform.z = value
                  })
              }
              .width('100%')
              .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
              .borderRadius(24)
              .backgroundColor('#FFFFFF')
              .margin(8)
            }
          }.tabBar('transform')
        }
        .vertical(false)
        .scrollable(true)
        .barMode(BarMode.Fixed)
        .barWidth(360)
        .animationDuration(400)
        .width('100%')
        .backgroundColor(0xF5F5F5)
        .onChange((index: number) => {
          this.init()
        })
      }
      .width('100%')
      .height('65%')
      .margin({ top: 10 })
    }
    .height('100%')
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