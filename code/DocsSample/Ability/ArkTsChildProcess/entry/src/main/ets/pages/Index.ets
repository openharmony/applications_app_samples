/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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
// [Start arkts_child_process_arg]
// [Start arkts_child_process_noarg_one]
// [Start arkts_child_process_noarg_two]
import { childProcessManager } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
// [StartExclude arkts_child_process_arg]
import DemoProcessNoArg from '../process/DemoProcessNoArg';
// [StartExclude arkts_child_process_noarg_one]
// [StartExclude arkts_child_process_noarg_two]
// [EndExclude arkts_child_process_arg]
import DemoProcessArg from  '../process/DemoProcessArg';
import { fileIo } from '@kit.CoreFileKit';
import { common, ChildProcessArgs, ChildProcessOptions } from '@kit.AbilityKit';
// [StartExclude arkts_child_process_arg]
@Entry
@Component
struct Index {

  build() {
    Scroll() {
      Column() {
        Text("StartArkChildProcessNoArg_Promise")
          .fontSize($r('app.float.page_text_font_size'))
          .fontWeight(FontWeight.Bold)
          .alignRules({
            center: { anchor: '__container__', align: VerticalAlign.Center },
            middle: { anchor: '__container__', align: HorizontalAlign.Center }
          })
          .onClick(() => {
            // [EndExclude arkts_child_process_noarg_one]
            try {
              DemoProcessNoArg.toString(); // 引用子进程类，防止被构建工具优化掉
              childProcessManager.startChildProcess("./ets/process/DemoProcessNoArg.ets", childProcessManager.StartMode.SELF_FORK)
                .then((pid) => {
                  console.info(`startChildProcess success, pid: ${pid}`);
                })
                .catch((err: BusinessError) => {
                  console.error(`startChildProcess error, errorCode: ${err.code}`);
                });
            } catch (err) {
              console.error(`startChildProcess error, errorCode: ${(err as BusinessError).code}`);
            }
            // [End arkts_child_process_noarg_one]
          })

        Text("StartArkChildProcessNoArg_Callback")
          .fontSize($r('app.float.page_text_font_size'))
          .fontWeight(FontWeight.Bold)
          .alignRules({
            center: { anchor: '__container__', align: VerticalAlign.Center },
            middle: { anchor: '__container__', align: HorizontalAlign.Center }
          })
          .onClick(() => {
            // [EndExclude arkts_child_process_noarg_two]
            try {
              DemoProcessNoArg.toString(); // 引用子进程类，防止被构建工具优化掉
              childProcessManager.startChildProcess("./ets/process/DemoProcessNoArg.ets", childProcessManager.StartMode.SELF_FORK, (err, data) => {
                if (data) {
                  console.info(`startChildProcess success, pid: ${data}`);
                } else {
                  console.error(`startChildProcess error, errorCode: ${err.code}`);
                }
              });
            } catch (err) {
              console.error(`startChildProcess error, errorCode: ${(err as BusinessError).code}`);
            }
            // [End arkts_child_process_noarg_two]
          })

        Text("StartArkChildProcessWithArg")
          .fontSize($r('app.float.page_text_font_size'))
          .fontWeight(FontWeight.Bold)
          .alignRules({
            center: { anchor: '__container__', align: VerticalAlign.Center },
            middle: { anchor: '__container__', align: HorizontalAlign.Center }
          })
          .onClick(() => {
            // [EndExclude arkts_child_process_arg]
            try {
              DemoProcessArg.toString(); // 引用子进程类，防止被构建工具优化掉
              let context = this.getUIContext().getHostContext() as common.UIAbilityContext;
              let path = context.filesDir + "/test.txt";
              let file = fileIo.openSync(path, fileIo.OpenMode.READ_ONLY | fileIo.OpenMode.CREATE);
              let args: ChildProcessArgs = {
                entryParams: "testParam",
                fds: {
                  "key1": file.fd
                }
              };
              let options: ChildProcessOptions = {
                isolationMode: false
              };
              childProcessManager.startArkChildProcess("module1/ets/process/DemoProcess.ets", args, options)
                .then((pid) => {
                  console.info(`startArkChildProcess success, pid: ${pid}`);
                })
                .catch((err: BusinessError) => {
                  console.error(`startArkChildProcess error, errorCode: ${err.code}, errorMsg:${err.message}`);
                });
            } catch (err) {
              console.error(`startArkChildProcess error, errorCode: ${(err as BusinessError).code}`);
            }
            // [End arkts_child_process_arg]
          })
      }
      .width('100%')
    }
    .height('100%')
  }
}