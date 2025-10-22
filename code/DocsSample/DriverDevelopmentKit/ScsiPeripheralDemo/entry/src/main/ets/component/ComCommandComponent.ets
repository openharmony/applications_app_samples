/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { hilog } from '@kit.PerformanceAnalysisKit';
import { promptAction } from '@kit.ArkUI';
import RpcTool from '../tool/RpcTool';
import { BusinessError } from '@kit.BasicServicesKit';
import { DirectionType } from '../utils/RequestCode';

interface Options {
  value:string;
}

@Component
@Preview
export struct ComCommandComponent {
  @State dataOfCDB: number[] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
  @Link dataOfComCommandPage: string;
  @Link execResultOfComCommandPage: string;
  @State cdbLen: number = 0;
  @State dirType: DirectionType = DirectionType.None;
  controller: TextAreaController = new TextAreaController();
  @State selectArray: Array<Options> = [{value: 'None'}, {value: 'To dev'}, {value: 'From dev'}, {value: 'To And From dev'}];

  hexToNum(value: string): number {
    if (value.length == 0) {
      return 0;
    }

    let num: number = parseInt(value, 16);
    hilog.info(0, 'testTag ui', `hexToNum: ${value}`);
    return num;
  }

  popMessage(): void {
    try {
      promptAction.showToast({
        message: '请正确填写！',
        duration: 2000
      });
    } catch (error) {
      let message = (error as BusinessError).message;
      let code = (error as BusinessError).code;
      hilog.info(0, 'testTag ui', `showToast args error code is ${code}, message is ${message}`);
    };
  }

  @Styles normalStyle() {
    .backgroundColor(Color.Blue)
  }

  @Styles pressedStyle() {
    .backgroundColor(Color.White)
  }

  @Styles disableStyle() {
    .backgroundColor(Color.Gray)
  }

  @Builder
  renderComponent(name: string, row: number, byteNum: number):void {
    GridItem() {
      Text(name)
        .borderStyle(BorderStyle.Solid).borderWidth(1).borderColor(Color.Black)
        .fontSize(15)
        .width('100%')
        .height('100%')
    }
    .rowStart(row)
    .rowEnd(row)
    .columnStart(0)
    .columnEnd(0)

    GridItem() {
      TextInput()
        .fontSize(15)
        .width('100%')
        .height('100%')
        .backgroundColor(Color.White)
        .borderStyle(BorderStyle.Solid).borderWidth(1).borderColor(Color.Black).borderRadius(0)
        .onChange((value) => {
          hilog.info(0, 'testTag ui', `row:${row}, byteNum:${byteNum}}`);
          let regex = /^[0-9a-fA-F]*$/;

          // 输入长度不超过2，并且只能输入0-9、a-f、A-F
          if (value.length > 2 || !regex.test(value)) {
            this.popMessage();
            return;
          }

          this.dataOfCDB[byteNum] = this.hexToNum(value);
        })
    }
    .rowStart(row)
    .rowEnd(row)
    .columnStart(1)
    .columnEnd(1)
  }

  build() {
    Column({space: 15}) {
      Row({space: 10}) {
        Row({space: 0}) {
          Text($r('app.string.direction'))
            .fontSize(15)
            .padding({left:10})
          Select(this.selectArray)
            .value(this.selectArray[0].value)
            .selectedOptionFont({size:15})
            .optionFont({size:15})
            .height(30)
            .width(100)
            .onSelect((index:number,text?:string|undefined)=>{
              switch (index) {
                case 0:
                  this.dirType = DirectionType.None;
                  break;
                case 1:
                  this.dirType = DirectionType.ToDev;
                  break;
                case 2:
                  this.dirType = DirectionType.FromDev;
                  break;
                case 3:
                  this.dirType = DirectionType.ToFromDev;
                  break;
                default :
                  break;
              }
              hilog.info(0, 'testTag ui', `dirType:${this.dirType}`);
            })
        }.padding({left: 0})

        Row({space: 0}) {
          Text($r('app.string.result'))
            .padding({left:10})
            .fontSize(15)
          TextInput({text: this.execResultOfComCommandPage})
            .height(30)
            .width(60)
            .margin({left:0})
            .enabled(false)
        }

        Button($r('app.string.send'))
          .fontSize(15)
          .height(30)
          .width(70)
          .margin({left:5,top:10})
          .stateStyles({
            normal: this.normalStyle,
            pressed: this.pressedStyle,
            disabled: this.disableStyle,
          })
          .onClick(() => {
            RpcTool.getInstance().sendCommonCDBData(this.dataOfCDB, this.dataOfComCommandPage, this.cdbLen, this.dirType
            );
          })
      }.width('100%')

      Column({space: 0}) {
        Row({space:30}) {
          Text($r('app.string.cdb_data'))
            .margin({left: 0})
            .fontSize(15)
            .width('40%')
            .align(Alignment.Start)
          Row({space:0}) {
            Text($r('app.string.cdb_data_bit'))
              .margin({left: 0})
              .fontSize(15)
              .width('60%')
              .align(Alignment.Start)

            TextInput()
              .fontSize(15)
              .width('30%')
              .height(30)
              .onChange((value)=>{
                this.cdbLen = parseInt(value, 10);
              })
          }
          .width('40%')
        }
        .margin({left: 0})
        .height('9%')

        Row({space:10}) {
          Grid() {
            this.renderComponent('byte 0', 0, 0);
            this.renderComponent('byte 1', 1, 1);
            this.renderComponent('byte 2', 2, 2);
            this.renderComponent('byte 3', 3, 3);
            this.renderComponent('byte 4', 4, 4);
            this.renderComponent('byte 5', 5, 5);
            this.renderComponent('byte 6', 6, 6);
            this.renderComponent('byte 7', 7, 7);
          }
          .columnsTemplate('1.4fr 3fr')
          .rowsTemplate('1fr 1fr 1fr 1fr 1fr 1fr 1fr 1fr')
          .columnsGap(0)
          .rowsGap(0)
          .width('45%')
          .margin({left: 10})

          Grid() {
            this.renderComponent('byte 8', 0, 8);
            this.renderComponent('byte 9', 1, 9);
            this.renderComponent('byte 10', 2, 10);
            this.renderComponent('byte 11', 3, 11);
            this.renderComponent('byte 12', 4, 12);
            this.renderComponent('byte 13', 5, 13);
            this.renderComponent('byte 14', 6, 14);
            this.renderComponent('byte 15', 7, 15);
          }
          .columnsTemplate('1.6fr 3fr')
          .rowsTemplate('1fr 1fr 1fr 1fr 1fr 1fr 1fr 1fr')
          .columnsGap(0)
          .rowsGap(0)
          .width('45%')
        }
        .width('95%')
        .height('95%')
        .align(Alignment.Center)
      }
      .width('100%')
      .height('60%')

      Column({space: 0}) {
        Text('数据')
          .padding({left: 0})
          .fontSize(15)
          .width('20%')
        TextArea({text: this.dataOfComCommandPage, placeholder: '如果需要写数据，可以在这里输入...', controller: this.controller})
          .placeholderFont({ size: 16, weight: 400 })
          .margin({left:0})
          .width('100%')
          .height('60%')
          .fontSize(15)
          .fontColor('#182431')
          .backgroundColor('#0C182431')
          .borderStyle(BorderStyle.Solid).borderWidth(1).borderColor('#FF007DFF')
          .onChange((value: string) => {
            this.dataOfComCommandPage = value;
          })
      }
      .width('100%')
      .height('30%')
      .padding({left:20, top: 10, right:20})
      .alignItems(HorizontalAlign.Start)
    }
    .width('100%')
    .height('100%')
  }
}
