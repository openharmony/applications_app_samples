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
struct DividerSample {
  @State list: number[] = [1, 2, 3, 4, 5, 6, 7, 8]
  @State title: string[] = ['控制台', '备案', '工单', '产品分类', '联系我们']
  @State phoneParams: object[] =
    [
      { type: '网络类型', value: '双模5G' }, { type: '屏幕尺寸', value: '8英寸' },
      { type: '电池容量', value: '4500mAh' }, { type: '拍照像素', value: '4800万像素' },
      { type: '65w', value: '充电功率' }
    ]
  @State getColorVal: string = 'Black'
  @State strokeWidth: number = 1
  @State lineCap: string = 'Butt'

  build() {
    Column() {
      NavigationBar({ title: 'Divider' })
      Column() {
        Column() {
          Text('Divider-Vertical')
            .fontWeight(FontWeight.Bold)
            .height('50%')
          Row({ space: FlexAlign.SpaceAround }) {
            ForEach(this.title, (item) => {
              Text(item)
                .fontSize('25fp')
                .fontColor('#bbb')
                .textAlign(TextAlign.Center)
              if (item != '联系我们') {
                Divider().vertical(true).color('#fff')
              }
            })
          }.height('50%').alignItems(VerticalAlign.Center).backgroundColor('#363636')
        }
        .alignItems(HorizontalAlign.Start)
        .justifyContent(FlexAlign.Start)
        .width('100%')
        .height('13%')

        Column() {
          Text('Divider-Horizontal').height('10%')
            .fontWeight(FontWeight.Bold)
          Scroll() {
            Column() {
              ForEach(this.list, (item) => {
                Row() {
                  Image($r('app.media.image01')).width('30%')
                  Column() {
                    Row() {
                      Text('HuaWei Mate-x2')
                    }

                    Row({ space: FlexAlign.SpaceAround }) {
                      ForEach(this.phoneParams, (item) => {
                        Column() {
                          Text(item.value).fontSize('12vp')
                          Text(item.type).fontSize('12vp').fontColor('#999')
                        }
                      })
                    }.width('100%').margin({bottom: 10})

                    Row() {
                      Text('￥').fontColor('#f03726').fontSize('20fp')
                      Text('18388').fontColor('#f03726')
                      Text('折后价').fontColor('#f03726').fontSize('25fp').margin({ left: 10 })
                      Text('￥').fontColor('#999').fontSize('30fp').margin({ left: 10 })
                      Text('20000').fontColor('#999').fontSize('25fp')
                    }.margin({ top: 10 })
                  }.padding({ top: 20, bottom: 20, left: 10, right: 10 }).alignItems(HorizontalAlign.Start)
                }
                .justifyContent(FlexAlign.Start)
                .width('96%')
                .backgroundColor('#fff')
                .height(200)
                .margin(10)
                .borderRadius(24)

                Divider().width('88%')
                  .color(this.getColorVal)
                  .strokeWidth(this.strokeWidth)
                  .lineCap(LineCapStyle[this.lineCap])
              })
              Row() {
                Text('没有更多了').fontSize('20fp').margin(10)
              }
            }.backgroundColor('#ccc').padding({ top: 20, bottom: 20 }).width('100%')
          }.width('100%').height('90%')
        }
        .alignItems(HorizontalAlign.Start)
        .justifyContent(FlexAlign.Start)
        .width('100%')
        .height('55%')

        Scroll() {
          Column() {
            Row({ space: FlexAlign.SpaceBetween }) {
              Text('color')
                .fontWeight(FontWeight.Medium)
                .fontColor('#182431')
                .opacity(0.5)
                .fontSize('16fp')

              Blank()

              Column() {
                Row() {
                  GetColor({ colorVal: $getColorVal })
                }
                .width(100)
                .height(24)
              }
            }
            .alignItems(VerticalAlign.Center)
            .width('100%')
            .borderRadius(24)
            .backgroundColor('#FFFFFF')
            .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })

            Row({ space: FlexAlign.SpaceBetween }) {
              Text('width')
                .fontWeight(FontWeight.Medium)
                .fontColor('#182431')
                .opacity(0.5)
                .fontSize('16fp')

              Blank()

              Column() {
                Counter() {
                  Text(this.strokeWidth.toString())
                    .fontWeight(FontWeight.Regular)
                    .fontColor('#000000')
                    .fontSize('10fp')
                }
                .onInc(() => {
                  this.strokeWidth++
                })
                .onDec(() => {
                  this.strokeWidth--
                })
                .height(24)
              }
            }
            .alignItems(VerticalAlign.Center)
            .width('100%')
            .borderRadius(24)
            .backgroundColor('#FFFFFF')
            .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
            .margin({ top: 8 })

            Row({ space: FlexAlign.SpaceBetween }) {
              Text('type')
                .fontWeight(FontWeight.Medium)
                .fontColor('#182431')
                .opacity(0.5)
                .fontSize('16fp')

              Blank()

              Column() {
                Text(`${this.lineCap}`)
                  .fontSize('10fp')
                  .fontColor('#182431')
                  .fontWeight(FontWeight.Medium)
                  .width('50%')
                  .textAlign(TextAlign.End)
              }
              .bindMenu([
                {
                  value: 'Butt',
                  action: () => {
                    this.lineCap = 'Butt'
                  }
                },
                {
                  value: 'Round',
                  action: () => {
                    this.lineCap = 'Round'
                  }
                },
                {
                  value: 'Square',
                  action: () => {
                    this.lineCap = 'Square'
                  }
                },
              ])
            }
            .alignItems(VerticalAlign.Center)
            .width('100%')
            .padding({ left: '3%', right: '3%', top: 12, bottom: 12 })
            .borderRadius(24)
            .backgroundColor('#FFFFFF')
            .margin({ top: 8 })
          }
          .margin({top: 10})
          .width('100%')
          .height('40%')
        }
        .width('100%')
      }
      .flexGrow(1)
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