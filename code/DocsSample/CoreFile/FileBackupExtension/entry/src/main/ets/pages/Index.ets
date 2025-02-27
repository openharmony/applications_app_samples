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

import CreateFile from '../fileFs/CreateFile';
import Logger from '../common/Logger';
import fs from '@ohos.file.fs';
import { common } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';

let context = getContext(this) as common.UIAbilityContext;
let filesDir = context.filesDir;
let countFile = 0; // 文件数量计数初始化

@Entry
@Component
struct BackupExample {
  createFile = new CreateFile();
  baseDir: string = filesDir;
  @State filePathSize: Array<string> = [];
  @State showFilePath: Array<string> = [];

  onPageShow() {
    try {
      if (!fs.accessSync(this.baseDir)) {
        fs.mkdirSync(this.baseDir);
        // 数组初始化
        this.showFilePath[0] = '';
        this.filePathSize[0] = '';
        return;
      }
      Logger.info(`readyFileToFileFs successful`);
    } catch (e) {
      let error: BusinessError = e as BusinessError;
      Logger.error(`readyFileToFileFs has failed for: {message: ${error.message}, code: ${error.code}}`);
    }
    let filenames = fs.listFileSync(this.baseDir);
    countFile = filenames.length;
    for (let i = 0; i < filenames.length; i++) {
      Logger.info('filename:' + filenames[i]);
      this.showFilePath[i] = filenames[i];
      let filePath = this.baseDir + '/' + filenames[i];
      this.filePathSize[i] = fs.statSync(filePath).size.toString() + 'Byte';
      Logger.info('arrayFilename: ' + i + this.showFilePath[i].toString());
    }
  }

  build() {
    Column() {
      Text($r('app.string.FileData'))
        .fontSize(14)
        .fontColor($r('sys.color.font_primary'))
        .margin({ top: 8, left: 48, bottom: 8 })
        .id('fileData')
        .opacity(0.6)
        .align(Alignment.TopStart)
        .width('93%')
      List({ space: 10, initialIndex: 0 }) {
        ForEach(this.showFilePath, (item: string, index?: number) => {
          ListItem() {
            Column() {
              Row() {
                Text(' ' + item)
                  .fontSize(16)
                  .fontColor($r('sys.color.black'))
                  .width('70%')
                  .textAlign(TextAlign.Start)
                  .fontWeight(500)
                  .margin({ left: 20 })
                  .id('file' + index)
                if (index !== undefined) {
                  Text(this.filePathSize[index])
                    .fontSize(14)
                    .width('20%')
                    .textAlign(TextAlign.End)
                    .fontColor($r('sys.color.black'))
                    .fontWeight(400)
                    .margin({ right: 16 })
                    .opacity(0.6)
                    .id('size' + index)
                }
              }
              .width('100%')
              .height(56)

              if (this.showFilePath[0] !== '') {
                Divider()
                  .strokeWidth('1vp')
                  .color($r('sys.color.black'))
                  .opacity(0.05)
                  .margin({ left: 24, right: 24 })
                  .width('90%')
              }
            }
            .width('100%')
          }
        }, (item: string) => item)
      }
      .height('80%')
      .width('93%')
      .borderRadius(24)
      .backgroundColor(0xFFFFFF)
      .align(Alignment.Center)

      Row() {
        Button($r('app.string.CreateFiles'))
          .id('createFiles')
          .backgroundColor($r('sys.color.brand'))
          .margin(15)
          .width('35%')
          .borderRadius(20)
          .onClick(async () => {
            await this.createFile.createTestFiles(this.baseDir);
            this.onPageShow();
          })
        Button($r('app.string.FileDelete'))
          .backgroundColor($r('sys.color.brand'))
          .margin(15)
          .width('35%')
          .borderRadius(20)
          .onClick(async () => {
            await this.createFile.deleteTestFiles(this.baseDir);
            for (let i = 0; i < countFile; i++) {
              this.showFilePath[i] = '';
            }
          })
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F1F3F5')
  }
}