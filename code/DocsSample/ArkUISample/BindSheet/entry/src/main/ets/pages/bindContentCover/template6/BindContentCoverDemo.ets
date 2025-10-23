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

interface PersonList {
  name: string,
  cardnum: string
}

@Entry
@Component
struct BindContentCoverDemo {
  private personList: Array<PersonList> = [
    { name: 'wang**', cardnum: '1234***********789' },
    { name: 'song*', cardnum: '2345***********789' },
    { name: 'xu**', cardnum: '3456***********789' },
    { name: 'tang*', cardnum: '4567***********789' }
  ];
  // 半模态转场控制变量
  @State isSheetShow: boolean = false;
  // 全模态转场控制变量
  @State isPresent: boolean = false;

  @Builder
  MyContentCoverBuilder() {
    Column() {
      Row() {
        Text($r('app.string.bindSheetCmd_label1'))
          .fontSize(20)
          .fontColor(Color.White)
          .width('100%')
          .textAlign(TextAlign.Center)
          .padding({ top: 30, bottom: 15 })
      }
      .backgroundColor(0x007dfe)

      Row() {
        Text($r('app.string.bindSheetCmd_label2'))
          .fontSize(16)
          .fontColor(0x333333)
          .margin({ top: 10 })
          .padding({ top: 20, bottom: 20 })
          .width('92%')
          .borderRadius(10)
          .textAlign(TextAlign.Center)
          .backgroundColor(Color.White)
      }

      Column() {
        ForEach(this.personList, (item: PersonList, index: number) => {
          Row() {
            Column() {
              if (index % 2 == 0) {
                Column()
                  .width(20)
                  .height(20)
                  .border({ width: 1, color: 0x007dfe })
                  .backgroundColor(0x007dfe)
              } else {
                Column()
                  .width(20)
                  .height(20)
                  .border({ width: 1, color: 0x007dfe })
              }
            }
            .width('20%')

            Column() {
              Text(item.name)
                .fontColor(0x333333)
                .fontSize(18)
              Text(item.cardnum)
                .fontColor(0x666666)
                .fontSize(14)
            }
            .width('60%')
            .alignItems(HorizontalAlign.Start)

            Column() {
              Text($r('app.string.bindSheetCmd_label3'))
                .fontColor(0x007dfe)
                .fontSize(16)
            }
            .width('20%')
          }
          .padding({ top: 10, bottom: 10 })
          .border({ width: { bottom: 1 }, color: 0xf1f1f1 })
          .width('92%')
          .backgroundColor(Color.White)
        })
      }
      .padding({ top: 20, bottom: 20 })

      Text($r('app.string.bindSheetCmd_label4'))
        .width('90%')
        .height(40)
        .textAlign(TextAlign.Center)
        .borderRadius(10)
        .fontColor(Color.White)
        .backgroundColor(0x007dfe)
        .onClick(() => {
          this.isPresent = !this.isPresent;
        })
    }
    .size({ width: '100%', height: '100%' })
    .backgroundColor(0xf5f5f5)
  }

  @Builder
  TripInfo() {
    Row() {
      Column() {
        Text('00:25')
        Text($r('app.string.bindSheetCmd_label5'))
      }
      .width('25%')

      Column() {
        Text('G1234')
        Text($r('app.string.bindSheetCmd_label6'))
      }
      .width('25%')

      Column() {
        Text('08:26')
        Text($r('app.string.bindSheetCmd_label7'))
      }
      .width('25%')
    }
  }

  // 第二步：定义半模态展示界面
  // 通过@Builder构建模态展示界面
  @Builder
  MySheetBuilder() {
    Column() {
      Column() {
        this.TripInfo()
      }
      .width('92%')
      .margin(15)
      .backgroundColor(Color.White)
      .shadow({ radius: 30, color: '#aaaaaa' })
      .borderRadius(10)

      Column() {
        Text($r('app.string.MySheetBuilder_text1'))
          .fontSize(18)
          .fontColor(Color.Orange)
          .fontWeight(FontWeight.Bold)
          .padding({ top: 10, bottom: 10 })
          .width('60%')
          .textAlign(TextAlign.Center)
          .borderRadius(15)
          .onClick(() => {
            // 第三步：通过全模态接口调起全模态展示界面，新拉起的模态面板默认显示在最上层
            this.isPresent = !this.isPresent;
          })
          // 通过全模态接口，绑定模态展示界面MyContentCoverBuilder。transition属性支持自定义转场效果，此处定义了x轴横向入场
          .bindContentCover($$this.isPresent, this.MyContentCoverBuilder(), {
            transition: TransitionEffect.translate({ x: 500 }).animation({ curve: curves.springMotion(0.6, 0.8) })
          })
      }
      .padding({ top: 60 })
    }
  }

  build() {
    Column() {
      Row() {
        this.TripInfo()
        Text($r('app.string.MySheetBuilder_text2'))
          .fontColor(Color.Blue)
          .width('25%')
      }
      .width('100%')
      .margin({top: 200, bottom: 30})
      .borderRadius(10)
      .backgroundColor(Color.White)
      .onClick(()=>{
        this.isSheetShow = !this.isSheetShow;
      })
      // 第一步：定义半模态转场效果
      .bindSheet($$this.isSheetShow, this.MySheetBuilder(), {
        height: SheetSize.MEDIUM,
        title: {title: $r('app.string.MySheetBuilder_text3')},
      })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#30aaaaaa')
  }
}