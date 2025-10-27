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
import { BusinessError } from '@kit.BasicServicesKit';
import RpcTool from '../tool/RpcTool';

interface Options {
   value:string;
}

enum CommandType {
  INQUIRY = 0,
  READ_CAPACITY = 1,
  TEST_UNIT_READY = 2,
  READ = 3,
  WRITE = 4,
  VERIFY = 5,
  REQUEST_SENSE = 6,
}

@Component
@Preview
export struct SendCommandComponent {
  @State commandsArray: Array<Options> = [{value: 'inquiry'}, {value: 'read_capacity'}, {value: 'test_unit_ready'},
                                         {value: 'read'},{value: 'write'}, {value: 'verify'}, {value: 'request_sense'}];

  // 几个组件的值
  @State index: number = 0;
  @State blockStartAddr: number = -1;
  @State blockNum: number = -1;
  @State blockStartAddrStr: string = '';
  @State blockNumStr: string = '';

  // 几个组件的状态标记位
  @State blockStartState: boolean = true;
  @State blockNumState: boolean = true;
  @State textAreaState: boolean = true;

  @Link dataOfSendCommandPage: string;
  @Link execResult: string;

  controller: TextAreaController = new TextAreaController();

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

  build() {
    Column({space: 30}) {
      Row({space: 10}) {
        Text($r('app.string.commands'))
          .padding({left:10})
          .fontSize(18)
        Select(this.commandsArray)
          .selected(this.index)
          .selectedOptionFont({size:20})
          .optionFont({size:20})
          .width('30%')
          .margin({left:20})
          .onSelect((index:number,text?:string|undefined)=>{
            hilog.info(0, 'testTag ui', `SCSI command select Index:${index}`);
            this.index = index;
            switch (this.index) {

              case CommandType.READ:
              case CommandType.VERIFY:
                this.blockStartState = true;
                this.blockNumState = true;
                break;
              case CommandType.WRITE:
                this.blockStartState = true;
                this.blockNumState = true;
                break;
              case CommandType.TEST_UNIT_READY:
              case CommandType.INQUIRY:
              case CommandType.REQUEST_SENSE:
                this.blockStartState = false;
                this.blockNumState = false;
                break;
              case CommandType.READ_CAPACITY:
                this.blockStartState = true;
                this.blockNumState = false;
              default :
                break;
            }
            this.dataOfSendCommandPage = '';
            this.blockStartAddrStr = '';
            this.blockNumStr = '';
            this.execResult = '';
            hilog.info(0, 'testTag ui', `==blockStartAddrStr:${this.blockStartAddrStr}`);
          })
        Button($r('app.string.send'))
          .fontSize(18)
          .width('20%')
          .stateStyles({
            normal: this.normalStyle,
            pressed: this.pressedStyle,
            disabled: this.disableStyle,
          })
          .onClick(()=>{
            switch (this.index) {
              case CommandType.TEST_UNIT_READY:
                RpcTool.getInstance().testUnitReady(this.blockStartAddr, this.blockNum);
                break;
              case CommandType.READ:
              case CommandType.VERIFY:
                if (this.blockStartAddr == -1 || this.blockNum <= 0) {
                  this.popMessage();
                  return;
                }
                if (this.index == CommandType.READ) {
                  RpcTool.getInstance().readBlockData(this.blockStartAddr, this.blockNum);
                } else if (this.index == CommandType.VERIFY) {
                  RpcTool.getInstance().verify(this.blockStartAddr, this.blockNum);
                }
                break;
              case CommandType.WRITE:
                if (this.blockStartAddr == -1 || this.blockNum <= 0 || this.dataOfSendCommandPage.length == 0) {
                  this.popMessage();
                  return;
                }
                RpcTool.getInstance().writeBlockData(this.blockStartAddr, this.blockNum, this.dataOfSendCommandPage);
                break;
              case CommandType.INQUIRY:
                RpcTool.getInstance().inquiry();
                break;
              case CommandType.REQUEST_SENSE:
                RpcTool.getInstance().requestSense();
                break;
              case CommandType.READ_CAPACITY:
                hilog.info(0, 'testTag ui', `==blockStartAddr:${this.blockStartAddr}`);
                if (this.blockStartAddr == -1) {
                  this.popMessage();
                  return;
                }
                RpcTool.getInstance().readCapacity(this.blockStartAddr);
                break;
              default:
                break;
            }
          })
      }
      .width('100%')
      .margin({left:35})

      Row({space: 10}) {
        Text($r('app.string.block_start'))
          .padding({left:10})
          .fontSize(18)
        TextInput({text: this.blockStartAddrStr})
          .width('30%')
          .margin({left:42})
          .type(InputType.Number)
          .backgroundColor(this.blockStartState? '#0C182431' : '#ffa2a5a5')
          .enabled(this.blockStartState)
          .onChange((value) => {
            this.blockStartAddrStr = value;
            if (this.blockStartAddrStr.length == 0) {
              this.blockStartAddr = -1;
            } else {
              this.blockStartAddr = parseInt(value, 10);
            }

            hilog.info(0, 'testTag ui', `==blockStartAddr:${this.blockStartAddr}, blockStartAddrStr:${this.blockStartAddrStr}`);
          })
      }
      .width('100%')
      .margin({left:35})

      Row({space: 10}) {
        Text($r('app.string.block_num_str'))
          .padding({left:10})
          .fontSize(18)
        TextInput({text: this.blockNumStr})
          .width('30%')
          .margin({left:42})
          .type(InputType.Number)
          .backgroundColor(this.blockNumState? '#0C182431' : '#ffa2a5a5')
          .enabled(this.blockNumState)
          .onChange((value) => {
            this.blockNumStr = value;
            if (this.blockNumStr.length == 0) {
              this.blockNum = -1;
            } else {
              this.blockNum = parseInt(value, 10);
            }
          })
      }
      .width('100%')
      .margin({left:35})

      Row({space: 10}) {
        Text($r('app.string.exec_result'))
          .padding({left:10})
          .fontSize(18)
        TextInput({text: this.execResult})
          .width('30%')
          .margin({left:26})
          .enabled(false)
      }
      .width('100%')
      .margin({left:35})

      Column({space: 0}) {
        Text($r('app.string.data'))
          .padding({left: 10})
          .fontSize(18)
          .width('20%')
        TextArea({text: this.dataOfSendCommandPage, placeholder: '如果需要写数据，可以在这里输入...', controller: this.controller})
          .placeholderFont({ size: 16, weight: 400 })
          .margin({left:10})
          .width('83%')
          .height('30%')
          .fontSize(18)
          .fontColor('#182431')
          .enabled(this.textAreaState)
          .backgroundColor('#0C182431')
          .borderStyle(BorderStyle.Solid).borderWidth(1).borderColor('#FF007DFF')
          .onChange((value: string) => {
            this.dataOfSendCommandPage = value;
         })
      }
      .width('100%')
      .margin({left:35})
      .alignItems(HorizontalAlign.Start)
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
  }
}