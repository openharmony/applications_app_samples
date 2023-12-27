/*
 * Copyright (c) 2023 Shenzhen Kaihong Digital Industry Development Co., Ltd.
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

import { BusinessError } from '@ohos.base';
import router from '@ohos.router';
import fs from '@ohos.file.fs';
import { Options } from '@ohos.file.fs';
import prompt from '@ohos.prompt';
import common from '@ohos.app.ability.common';
import { Logger, NewFileSystem } from '@ohos/feature-file-manager';
import { updateContextArea } from './MyPhone';

const TAG: string = 'FileEdit';
let myContext = getContext(this) as common.UIAbilityContext;

interface paramsTape {
  filePath: string,
  fileName: string,
  fileSize: string,
  fileContent: string
}

@Entry
@Component
struct OpenFile {
  private filePath: string = (router.getParams() as paramsTape).filePath;
  private showFileName: string = (router.getParams() as paramsTape).fileName;
  private newFileContent: string = '';
  private fileSize: string = (router.getParams() as paramsTape).fileSize;
  @State showFileContent: string = (router.getParams() as paramsTape).fileContent;
  @State isEdite: Boolean = false;

  scroller: Scroller = new Scroller();
  controllerArea: TextAreaController = new TextAreaController();

  saveFileContent(): Boolean {
    let fileFullName: string = this.filePath + this.showFileName;
    Logger.info(TAG, "fileFullName: " + fileFullName);
    let ret: Boolean = true;
    if (this.showFileContent != this.newFileContent) {
      let file: fs.File;
      try {
        file = fs.openSync(fileFullName, fs.OpenMode.READ_WRITE | fs.OpenMode.TRUNC);
        Logger.info(TAG, 'file fd: ' + file.fd);
      } catch (err) {
        let error: BusinessError = err as BusinessError;
        Logger.error(TAG, `open file failed. code is ${error.code}, message is ${error.message}`);
        return false;
      }

      let options: Options = {
        encoding: 'utf-8'
      };
      fs.write(file.fd, this.newFileContent, options, (err: BusinessError, writeLen: number) => {
        if (err) {
          Logger.error(TAG, "write data to file failed with error message: " + err.message + ", error code: " + err.code);
          ret = false;
        } else {
          Logger.info(TAG, "write data to file: " + fileFullName + " succeed, size is: " + writeLen);
          ret = true;
        }
        fs.closeSync(file);
      });
    } else {
      Logger.info(TAG, "file: " + fileFullName + " content not change");
      ret = true;
    }
    return ret;
  }

  async aboutToAppear() {
    Logger.info(TAG, 'Get file content');
    updateContextArea(this.filePath, myContext);
    let filePath: string = this.filePath + this.showFileName;
    try {
      this.showFileContent = await NewFileSystem.ReadFile(filePath);
    } catch (err) {
      let error: BusinessError = err as BusinessError;
      Logger.error(TAG, `Read file failed. code is ${error.code}, message is ${error.message}`);
    }
  }

  build() {
    Column() {
      Column() {
        // 标题栏
        Row() {
          // 标题栏左边
          Row() {
            if (this.isEdite) {
              // 取消编辑模式
              Image($r('app.media.ic_cancel_edit'))
                .height(24)
                .width(24)
                .objectFit(ImageFit.Fill)
                .alignSelf(ItemAlign.Auto)
                .id('switch2View')
                .onClick(() => {
                  this.isEdite = false;
                })
            } else {
              Image($r('app.media.ic_back'))
                .height(24)
                .width(24)
                .objectFit(ImageFit.Fill)
                .alignSelf(ItemAlign.Auto)
                .id('openFileBack')
                .onClick(() => {
                  router.back();
                })
            }
            Text(this.showFileName)
              .fontSize(20)
              .fontColor('#182431')
              .fontFamily('HarmonyHeiTi-Bold')
              .textAlign(TextAlign.Start)
              .id('openFileName')
              .fontWeight(700)
              .margin({ left: 16 })
          }

          // 标题栏右边
          Row() {
            // 进入编译模式, 图标改为保存图标，点击保存修改
            if (this.isEdite) {
              Image($r('app.media.ic_save'))
                .height(24)
                .width(24)
                .objectFit(ImageFit.Fill)
                .alignSelf(ItemAlign.Auto)
                .id('saveFileContent')
                .onClick(() => {
                  let ret = this.saveFileContent();
                  if (ret) {
                    this.showFileContent = this.newFileContent;
                    prompt.showToast({
                      message: (Object)($r('app.string.file_save_success')),
                      duration: 2000,
                    });
                  } else {
                    prompt.showToast({
                      message: (Object)($r('app.string.file_save_faile')),
                      duration: 2000,
                    });
                  }
                })
            } else {
              // 默认进入浏览模式，图标为编辑图标，点击进入编辑模式
              Image($r('app.media.ic_file_edit'))
                .height(24)
                .width(24)
                .objectFit(ImageFit.Fill)
                .alignSelf(ItemAlign.Auto)
                .id('switch2Edit')
                .onClick(() => {
                  this.isEdite = true;
                })
            }
          }
        }
        .width('100%')
        .height('100%')
        .align(Alignment.Center)
        .justifyContent(FlexAlign.SpaceBetween)
      }
      .width('100%')
      .height(56)

      // 文件内容
      Column() {
        Scroll(this.scroller) {
          if (this.isEdite) {
            TextArea({ text: this.showFileContent, controller: this.controllerArea })
              .id('editFileContent')
              .fontSize(16)
              .fontColor('#464646')
              .fontWeight(400)
              .fontFamily('HarmonyHeiTi')
              .backgroundColor(Color.White)
              .borderRadius(20)
              .opacity(0.6)
              .width('100%')
              .height(512)
              .align(Alignment.TopStart)
              .textAlign(TextAlign.Start)
              .enableKeyboardOnFocus(false)
              .focusable(true)
              .focusOnTouch(true)
              .defaultFocus(false)
              .onChange((value: string) => {
                this.newFileContent = value;
              })
          } else {
            Text(this.showFileContent)
              .id('openFileContent')
              .fontSize(16)
              .fontColor('#464646')
              .fontWeight(400)
              .fontFamily('HarmonyHeiTi')
              .backgroundColor('#f1f3f5')
              .opacity(0.6)
              .width('100%')
              .textAlign(TextAlign.Start)
              .align(Alignment.TopStart)
          }
        }
      }
      .width('100%')
      .padding({ top: 4 })
      .height(512)
      .alignItems(HorizontalAlign.Start)
      .justifyContent(FlexAlign.Start)
    }
    .width('100%')
    .height('100%')
    .padding({ left: 24, right: 24 })
    .backgroundColor('#f1f3f5')
  }
}
