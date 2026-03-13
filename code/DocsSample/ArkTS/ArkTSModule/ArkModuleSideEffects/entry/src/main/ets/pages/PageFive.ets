/*
* Copyright (C) 2026 Huawei Device Co., Ltd.
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

import { router } from '@kit.ArkUI';
// [Start import_modulePartFive]
// PageFive.ets（执行入口）
import { data1 } from './ModulePartFive';
import { data2 } from './SideEffectModuleFive';
import { useGlobalVar } from './ModuleUseGlobalVarFive';

useGlobalVar();
function maybeNotCalledAtAll() {
  console.info('data1 is ', data1);
  console.info('data2 is ', data2);
}
// [End import_modulePartFive]

let globalLogUpdate: ((msg: string, isError: boolean) => void) | undefined;

function testImportData() {
  useGlobalVar();
  console.info('data1 is ', data1);
  console.info('data2 is ', data2);
}

@Entry
@Component
struct IndexArkTs {
  @State currentState: string | ResourceStr = $r('app.string.uninitialized');
  @State logMessages: string | ResourceStr = $r('app.string.no_log_info');
  pageStack: NavPathStack = new NavPathStack();

  aboutToAppear(): void {
    globalLogUpdate = (msg, isError) => this.updateLogInfo(msg, isError);
  }

  updateLogInfo(msg: string, isError: boolean): void {
    const timestamp = new Date().toLocaleTimeString();
    const prefix = isError ? '[ERROR]' : '[INFO]';
    this.logMessages = `[${timestamp}] ${prefix} ${msg}`;
  }

  build() {
    Navigation(this.pageStack) {
      Scroll() {
        Column() {
          Column() {
            Text($r('app.string.status_info_title'))
              .fontSize(18)
              .fontWeight(600)
              .margin({ bottom: 12 })

            Column() {
              Text($r('app.string.current_status'))
                .fontSize(14)
                .fontWeight(600)
                .margin({ bottom: 8 })
              Text(this.currentState)
                .fontSize(14)
                .fontColor('#007DFF')
                .width('100%')
                .padding(10)
                .backgroundColor('#F0F0F0')
                .borderRadius(8)
            }
            .width('100%')
            .alignItems(HorizontalAlign.Start)
            .margin({ bottom: 12 })

            Column() {
              Text($r('app.string.log_info'))
                .fontSize(14)
                .fontWeight(600)
                .margin({ bottom: 8 })
              Scroll() {
                Text(this.logMessages)
                  .fontSize(12)
                  .fontColor('#52C41A')
                  .width('100%')
                  .padding(10)
                  .backgroundColor('#F0F0F0')
                  .borderRadius(8)
              }
              .width('100%')
            }
            .width('100%')
            .alignItems(HorizontalAlign.Start)
            .margin({ bottom: 10 })
          }
          .width('100%')
          .padding(18)
          .backgroundColor(Color.White)
          .borderRadius(8)
          .margin({ bottom: 16 })

          Column() {
            Text($r('app.string.test_page_five')).fontColor(Color.Black).fontSize(14)
          }
          .backgroundColor(Color.White)
          .borderRadius(20)
          .width('90%')
          .height(32)
          .justifyContent(FlexAlign.Center)
          .margin({ bottom: 12 })
          .onClick(() => {
            testImportData();
            this.currentState = $r('app.string.test_page_five_complete');
          })
        }
        .height('100%')
        .width('100%')
        .backgroundColor('#F1F3F5')
        .padding(16);
      }
    }
  }
}