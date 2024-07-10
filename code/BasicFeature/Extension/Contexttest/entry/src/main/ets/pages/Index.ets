/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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

import buffer from '@ohos.buffer';
import common from '@ohos.app.ability.common';
import promptAction from '@ohos.promptAction';
import fs, { ReadOptions } from '@ohos.file.fs';

// 获取应用文件路径
let context = getContext(this) as common.UIAbilityContext;
let filesDir1 = context.filesDir;
let filesDir2 = context.getApplicationContext().filesDir;

@Entry
@Component
struct Index {
  @State Message: string = 'UIAbility';

  build() {
    Row() {
      Column() {
        Text(this.Message)
          .fontSize(60)
          .lineHeight(90)
          .fontWeight(700)
          .textAlign(TextAlign.Start)
          .margin({ bottom: 100 })

        Button($r('app.string.SharedFileSuccess'))
          .onClick(() => {
            let filesDir = '';
            try {
              context.getGroupDir('test1', (err, data) => {
                if (err) {
                  promptAction.showToast({
                    message: $r('app.string.CreatedFail'),
                    duration: 2000,
                    bottom: 464
                  })
                  console.error(`getGroupDir faile, err: ${JSON.stringify(err)}`);
                } else {
                  filesDir = data;
                  console.log(`getGroupDir result is: ${JSON.stringify(data)}`);
                  let file = fs.openSync(filesDir + '/groupTest1.txt', fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
                  // 写入一段内容至文件
                  let writeLen = fs.writeSync(file.fd, 'Try to write str.');
                  // 从文件读取一段内容
                  let arrayBuffer = new ArrayBuffer(1024);
                  let readOptions: ReadOptions = {
                    offset: 0,
                    length: arrayBuffer.byteLength
                  };
                  let readLen = fs.readSync(file.fd, arrayBuffer, readOptions);
                  //创建新的buffer对象
                  let buf = buffer.from(arrayBuffer, 0, readLen);
                  console.info('the content of file:' + buf.toString());
                  promptAction.showToast({
                    message: $r('app.string.CreatedSuccess'),
                    duration: 2000,
                    bottom: 530
                  })
                  // 关闭文件
                  fs.closeSync(file);
                }
              });
            } catch (e) {
              console.log(`getGroupDir err: ${JSON.stringify(e)}`);
            }
          })
          .margin({ bottom: 24 })
          .height(90)
          .fontSize(32)
          .backgroundColor('#007DFF')
          .fontFamily('HarmonyHeiTi-Medium')
          .fontWeight(500)
          .width('90%')

        Button($r('app.string.SharedFileFail'))
          .onClick(() => {
            let filesDir = '';
            try {
              context.getGroupDir('test2', (err, data) => {
                if (err) {
                  promptAction.showToast({
                    message: $r('app.string.CreatedFail'),
                    duration: 2000,
                    bottom: 530
                  })
                  console.error(`getGroupDir faile, err: ${JSON.stringify(err)}`);
                } else {
                  filesDir = data;
                  console.log(`getGroupDir result is: ${JSON.stringify(data)}`);
                  let file = fs.openSync(filesDir + '/groupTest2.txt', fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
                  // 写入一段内容至文件
                  let writeLen = fs.writeSync(file.fd, 'Try to write str.');
                  console.info('The length of str is:' + writeLen);
                  // 从文件读取一段内容
                  let arrayBuffer = new ArrayBuffer(1024);
                  let readOptions: ReadOptions = {
                    offset: 0,
                    length: arrayBuffer.byteLength
                  };
                  let readLen = fs.readSync(file.fd, arrayBuffer, readOptions);
                  let buf = buffer.from(arrayBuffer, 0, readLen);
                  console.info('the content of file:' + buf.toString());
                  promptAction.showToast({
                    message: $r('app.string.CreatedSuccess'),
                    duration: 2000,
                    bottom: 530
                  })
                  // 关闭文件
                  fs.closeSync(file);
                }
              });
            } catch (e) {
              console.log(`getGroupDir err: ${JSON.stringify(e)}`);
            }
          })
          .margin({ bottom: 24 })
          .height(90)
          .fontSize(32)
          .backgroundColor('#007DFF')
          .fontFamily('HarmonyHeiTi-Medium')
          .fontWeight(500)
          .width('90%')

        // 预期结果 无法读写
        Button($r('app.string.InterviewModuleExtension'))
          .onClick(() => {
            try {
              fs.openSync(filesDir1 + '/inputtest1.txt', fs.OpenMode.READ_WRITE);
              promptAction.showToast({
                message: $r('app.string.AccessSuccess'),
                duration: 2000,
                bottom: 530
              })
            } catch (e) {
              promptAction.showToast({
                message: $r('app.string.AccessFail'),
                duration: 2000,
                bottom: 530
              })
              console.log(`openSync err: ${JSON.stringify(e)}`);
              this.Message = 'moduleFailed';
            }
          })
          .margin({ bottom: 24 })
          .height(90)
          .fontSize(32)
          .backgroundColor('#007DFF')
          .fontFamily('HarmonyHeiTi-Medium')
          .fontWeight(500)
          .width('90%')

        // 预期结果 无法读写
        Button($r('app.string.InterviewApplyExtension'))
          .onClick(() => {
            try {
              fs.openSync(filesDir2 + '/inputtest2.txt', fs.OpenMode.READ_WRITE);
              promptAction.showToast({
                message: $r('app.string.AccessSuccess'),
                duration: 2000,
                bottom: 530
              })
            } catch (e) {
              promptAction.showToast({
                message: $r('app.string.AccessFail'),
                duration: 2000,
                bottom: 530
              })
              console.log(`openSync err: ${JSON.stringify(e)}`);
              this.Message = 'appFailed';
            }
          })
          .height(90)
          .fontSize(32)
          .backgroundColor('#007DFF')
          .fontFamily('HarmonyHeiTi-Medium')
          .fontWeight(500)
          .width('90%')
      }
      .width('100%')
    }
    .height('100%')
  }
}