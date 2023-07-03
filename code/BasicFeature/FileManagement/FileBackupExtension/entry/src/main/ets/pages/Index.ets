/*
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
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

@Entry
@Component
struct BackupExample {
  CreateFile = new CreateFile();
  TAG: string = "[Pages].[MyFile]";
  baseDir: string = AppStorage.Get('sanBoxFileDir') + '/TextDir';
  listStyle: string = '文件数据';
  buttonString: string = '生成文件数据';
  placeholderText: string = '文件列表等待生成中...';
  @State filePathSize: Array<string> = [];
  @State showFilePath: Array<string> = [];

  onPageShow() {
    try {
      if (!fs.accessSync(this.baseDir)) {
        fs.mkdirSync(this.baseDir);
        this.showFilePath[0] = this.placeholderText;
        this.filePathSize[0] = '';
        return;
      }
      Logger.info(this.TAG, `readyFileToFileFs successful`);
    } catch (e) {
      Logger.error(this.TAG, `readyFileToFileFs has failed for: {message: ${e.message}, code: ${e.code}}`);
    }
    let filenames = fs.listFileSync(this.baseDir);
    for (let i = 0; i < filenames.length; i++) {
      Logger.info(this.TAG, "filename:" + filenames[i]);
      this.showFilePath[i] = filenames[i];
      let filePath = this.baseDir + '/' + filenames[i]
      this.filePathSize[i] = fs.statSync(filePath).size.toString() + 'Byte';
      Logger.info(this.TAG, "arrayfilename: " + i + this.showFilePath[i].toString());
    }
  }

  build() {
    Column() {

      Text(this.listStyle)
        .fontSize(14)
        .fontColor('#182431')
        .margin({ top: 8, left: 48, bottom: 8 })
        .id('filedata')
        .opacity(0.6)
        .align(Alignment.TopStart)
        .width('93.3%')

      List({ space: 10, initialIndex: 0 }) {
        ForEach(this.showFilePath, (item, index) => {
          ListItem() {
            Row() {
              Text(' ' + item)
                .fontSize(16)
                .fontColor('#182431')
                .width('70%')
                .textAlign(TextAlign.Start)
                .fontWeight(500)
                .margin({ left: 20 })
                .id('file' + index)
              // .backgroundColor(0xFFFFFF)
              Text(this.filePathSize[index])
                .fontSize(14)
                .width('30%')
                .textAlign(TextAlign.End)
                .fontColor('#182431')
                .fontWeight(400)
                .margin({ right: 6 })
                .opacity(0.6)
              // .backgroundColor(0xFFFFFF)
            }
            .width('90%')
            .height(56)
          }
        }, item => item)
      }
      .divider({ strokeWidth: 1, color: '#182431', startMargin: 24, endMargin: 24 })
      .height('79.5%')
      .width('93.3%')
      .borderRadius(24)
      .backgroundColor(0xFFFFFF)
      .align(Alignment.Center)
      //      .margin({ left: 12 })

      Button(this.buttonString)
        .id('createFiles')
        .backgroundColor('#007DFF')
        .margin(15)
        .width('86.7%')
        .borderRadius(20)
        .onClick(async () => {
          await this.CreateFile.createTestFiles();
          this.onPageShow();
        })
        .align(Alignment.Center)
    }.width('100%').height('100%').backgroundColor('#F1F3F5')
  }
}
