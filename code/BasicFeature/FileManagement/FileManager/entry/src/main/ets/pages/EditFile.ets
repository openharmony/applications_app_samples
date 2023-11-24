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

import common from '@ohos.app.ability.common';
import fs from '@ohos.file.fs';
import router from '@ohos.router';
import MyWatcher from '../filemanager/fileFs/MyWatcher';
import OpenHarmonyTestRunner from '../../../ohosTest/ets/TestRunner/OpenHarmonyTestRunner';
import { Logger, sleep } from '../common/Common';
import prompt from '@ohos.prompt'

interface paramsTape {
  fileSize: number,
  fileName: string,
  fileContent: string ,
  text: string,
  data: object
}

@Entry
@Component
struct EditFile {
  @State myContext: Context = getContext(this) as common.UIAbilityContext;
  @State myFileSize: number = (router.getParams() as paramsTape).fileSize;
  @State myFileName: string = (router.getParams() as paramsTape).fileName;
  @State myFileContent: string = (router.getParams() as paramsTape).fileContent;
  @State text: string = (router.getParams() as paramsTape).text;
  @State data: object = (router.getParams() as paramsTape).data;
  @State newFileSize: number = 0;
  @State newFileName: string = '';
  @State newFileContent: string = '';
  @State showFileSize: number = this.myFileSize;
  @State showFileName: string = this.myFileName;
  @State showFileContent: string = this.myFileContent;
  @State oldFileSize: number = this.myFileSize;
  @State oldFileName: string = this.myFileName;
  @State oldFileContent: string = this.myFileContent;
  @State currentFileName: string = this.myFileName;
  @State flagBack: boolean = false;
  @State flagRightBack: boolean = false;
  @State flagModifyName: boolean = false;
  @State flagModifyContent: boolean = false;
  @State flagBackName: boolean = false;
  @State flagBackContent: boolean = false;
  myWatcher: MyWatcher = new MyWatcher();
  scroller: Scroller = new Scroller();
  public baseDir: string = AppStorage.Get<string>('sanBoxFileDir') as string;
  controllerArea: TextAreaController = new TextAreaController();
  controllerInput: TextInputController = new TextInputController()

  build() {
    Scroll(this.scroller) {
      Row() {
        Column() {
          Row() {
            Row() {
              Image($r('app.media.ic_back'))
                .width(24)
                .height(24)
                .align(Alignment.Start)
                .id('backWatcherFile')
                .onClick(() => {
                  router.back();
                })
            }
            .width('70%')

            Row() {
              Image($r('app.media.ic_backward'))
                .width(24)
                .height(24)
                .margin({ right: 28.24 })
                .id('backward')
                .onClick(() => {
                  if (this.flagBack) {
                    if (this.flagModifyName && !this.flagModifyContent) {
                      this.showFileName = this.oldFileName;
                      let oldFileName = this.showFileName + '.txt';
                      let newFileName = this.newFileName + '.txt';
                      let filePath = this.baseDir + '/watcherDir/' + newFileName;
                      try {
                        let res = fs.accessSync(filePath);
                        if (res) {
                          Logger.info('file exists');
                        }
                      } catch (err) {
                        Logger.info('accessSync failed with error message: ' + err.message + ', error code:' + err.code);
                      }
                      this.oldFileName = this.newFileName;
                      this.myWatcher.modifyFileNameToWatcher(newFileName, oldFileName);
                      this.newFileName = this.showFileName;
                      this.flagBack = false;
                      this.flagRightBack = true;
                      let len = this.showFileName.length;
                      this.controllerInput.caretPosition(len);
                      this.flagModifyName = false;
                      this.flagModifyContent = false;
                      this.flagBackName = true;
                      this.flagBackContent = false;
                      prompt.showToast({
                        message: 'cancel name modification success!',
                        duration: 2000,
                      });
                    } else if (!this.flagModifyName && this.flagModifyContent) {
                      this.showFileContent = this.oldFileContent;
                      this.showFileSize = this.oldFileSize;
                      let oldFileName = this.showFileName + '.txt';
                      let newFileName = this.newFileName + '.txt';
                      let filePath = this.baseDir + '/watcherDir/' + this.showFileName;
                      try {
                        let res = fs.accessSync(filePath);
                        if (res) {
                          Logger.info('file exists');
                        }
                      } catch (err) {
                        Logger.info('accessSync failed with error message: ' + err.message + ', error code:' + err.code);
                      }
                      this.oldFileSize = this.newFileSize;
                      this.oldFileContent = this.newFileContent;
                      this.newFileSize = this.myWatcher.modifyFileToWatcher(newFileName, oldFileName, this.showFileContent);
                      this.showFileSize = this.newFileSize;
                      this.newFileContent = this.showFileContent;
                      this.flagBack = false;
                      this.flagRightBack = true;
                      let len = this.showFileContent.length;
                      this.controllerArea.caretPosition(len);
                      this.flagModifyName = false;
                      this.flagModifyContent = false;
                      this.flagBackName = false;
                      this.flagBackContent = true;
                      prompt.showToast({
                        message: 'cancel content modification success!',
                        duration: 2000,
                      });
                    } else if (this.flagModifyName && this.flagModifyContent) {
                      this.showFileName = this.oldFileName;
                      this.showFileContent = this.oldFileContent;
                      this.showFileSize = this.oldFileSize;
                      let oldFileName = this.showFileName + '.txt';
                      let newFileName = this.newFileName + '.txt';
                      let filePath = this.baseDir + '/watcherDir/' + newFileName;
                      try {
                        let res = fs.accessSync(filePath);
                        if (res) {
                          Logger.info('file exists');
                        }
                      } catch (err) {
                        Logger.info('accessSync failed with error message: ' + err.message + ', error code:' + err.code);
                      }
                      this.oldFileName = this.newFileName;
                      this.oldFileSize = this.newFileSize;
                      this.oldFileContent = this.newFileContent;
                      this.newFileSize = this.myWatcher.modifyFileToWatcher(newFileName, oldFileName, this.showFileContent);
                      this.showFileSize = this.newFileSize;
                      this.newFileName = this.showFileName;
                      this.newFileContent = this.showFileContent;
                      this.flagBack = false;
                      this.flagRightBack = true;
                      let len = this.showFileContent.length;
                      this.controllerArea.caretPosition(len);
                      this.flagModifyName = false;
                      this.flagModifyContent = false;
                      this.flagBackName = true;
                      this.flagBackContent = true;
                      prompt.showToast({
                        message: 'cancel name and content modification success!',
                        duration: 2000,
                      });
                    }
                  }
                })
              Image($r('app.media.ic_backward_right'))
                .width(24)
                .height(24)
                .margin({ right: 28.24 })
                .id('backward_right')
                .onClick(() => {
                  if (this.flagRightBack) {
                    if (this.flagBackName && !this.flagBackContent) {
                      this.showFileName = this.oldFileName;
                      this.oldFileName = this.newFileName;
                      let newFileName = this.showFileName + '.txt';
                      let oldFileName = this.newFileName + '.txt';
                      this.myWatcher.modifyFileNameToWatcher(oldFileName, newFileName);
                      this.newFileName = this.showFileName;
                      this.flagRightBack = false;
                      this.flagBack = true;
                      this.flagBackName = false;
                      this.flagBackContent = false;
                      this.flagModifyName = true;
                      this.flagModifyContent = false;
                      let len = this.showFileName.length;
                      this.controllerInput.caretPosition(len);
                      prompt.showToast({
                        message: 'restore content modification success!',
                        duration: 2000,
                      });
                    } else if (!this.flagBackName && this.flagBackContent) {
                      this.showFileContent = this.oldFileContent;
                      this.showFileSize = this.oldFileSize;
                      this.oldFileSize = this.newFileSize;
                      this.oldFileContent = this.newFileContent;
                      let newFileName = this.showFileName + '.txt';
                      let oldFileName = this.newFileName + '.txt';
                      this.newFileSize = this.myWatcher.modifyFileToWatcher(oldFileName, newFileName, this.showFileContent);
                      this.showFileSize = this.newFileSize;
                      this.newFileContent = this.showFileContent;
                      this.flagRightBack = false;
                      this.flagBack = true;
                      this.flagBackName = false;
                      this.flagBackContent = false;
                      this.flagModifyName = false;
                      this.flagModifyContent = true;
                      let len = this.showFileContent.length;
                      this.controllerArea.caretPosition(len);
                      prompt.showToast({
                        message: 'restore content modification success!',
                        duration: 2000,
                      });
                    } else if (this.flagBackName && this.flagBackContent) {
                      this.showFileName = this.oldFileName;
                      this.showFileContent = this.oldFileContent;
                      this.showFileSize = this.oldFileSize;
                      this.oldFileName = this.newFileName;
                      this.oldFileSize = this.newFileSize;
                      this.oldFileContent = this.newFileContent;
                      let newFileName = this.showFileName + '.txt';
                      let oldFileName = this.newFileName + '.txt';
                      this.newFileSize = this.myWatcher.modifyFileToWatcher(oldFileName, newFileName, this.showFileContent);
                      this.showFileSize = this.newFileSize;
                      this.newFileName = this.showFileName;
                      this.newFileContent = this.showFileContent;
                      this.flagRightBack = false;
                      this.flagBack = true;
                      this.flagBackName = false;
                      this.flagBackContent = false;
                      this.flagModifyName = true;
                      this.flagModifyContent = true;
                      let len = this.showFileContent.length;
                      this.controllerArea.caretPosition(len);
                      prompt.showToast({
                        message: 'restore name and content modification success!',
                        duration: 2000,
                      });
                    }
                  }
                })
              Image($r('app.media.ic_ok'))
                .width(24)
                .height(24)
                .id('save')
                .onClick(async () => {
                  let flagName = false;
                  let flagContent = false;
                  if (this.showFileName !== this.newFileName && this.showFileContent === this.newFileContent) {
                    let srcFileName = this.showFileName + '.txt';
                    let dstFileName = this.newFileName + '.txt';
                    Logger.info('saveOk modifyFileNameToWatcher srcFileName = ' + srcFileName);
                    Logger.info('saveOk modifyFileNameToWatcher dstFileName = ' + dstFileName);
                    flagName = this.myWatcher.modifyFileNameToWatcher(srcFileName, dstFileName);
                    this.currentFileName = this.newFileName;
                    this.showFileName = this.newFileName;
                    this.flagModifyName = true;
                    this.flagModifyContent = false;
                  }
                  if (this.showFileContent !== this.newFileContent && this.showFileName === this.newFileName) {
                    let fileName = this.showFileName + '.txt';
                    flagContent = this.myWatcher.modifyFileContentToWatcher(fileName, this.newFileContent);
                    let filePath = this.baseDir + '/watcherDir/' + fileName;
                    this.newFileSize = fs.statSync(filePath).size;
                    this.showFileSize = this.newFileSize;
                    this.showFileContent = this.newFileContent;
                    this.flagModifyName = false;
                    this.flagModifyContent = true;
                  }
                  if (this.showFileContent !== this.newFileContent && this.showFileName !== this.newFileName) {
                    let srcFileName = this.showFileName + '.txt';
                    let dstFileName = this.newFileName + '.txt';
                    this.myWatcher.modifyFileToWatcher(srcFileName, dstFileName, this.newFileContent);
                    flagContent = true;
                    flagName = true;
                    let filePath = this.baseDir + '/watcherDir/' + dstFileName;
                    this.newFileSize = fs.statSync(filePath).size;
                    this.showFileName = this.newFileName;
                    this.showFileSize = this.newFileSize;
                    this.showFileContent = this.newFileContent;
                    this.flagModifyName = true;
                    this.flagModifyContent = true;
                  }
                  this.flagBack = true;
                  this.flagRightBack = false;
                  if (flagName && flagContent) {
                    prompt.showToast({
                      message: 'modify file name and content success!',
                      duration: 2000,
                    });
                  } else if (flagName && !flagContent) {
                    prompt.showToast({
                      message: 'modify file name success!',
                      duration: 2000,
                    });
                  } else if (!flagName && flagContent) {
                    prompt.showToast({
                      message: 'modify file content success!',
                      duration: 2000,
                    });
                  }
                })
            }
            .align(Alignment.End)
            .width('30%')
          }
          .height(26)
          .margin({ top: 19, left: 26, right: 24 })
          .align(Alignment.Center)

          Column() {
            Row() {
              TextInput({ text: this.showFileName, controller: this.controllerInput })
                .fontSize(30)
                .fontColor('#182431')
                .textAlign(TextAlign.Start)
                .id('fileName')
                .borderRadius(0)
                .fontWeight(500)
                .margin({ left: 8, right: 8 })
                .backgroundColor('#f1f3f5')
                .maxLength(30)
                .onChange((value: string) => {
                  this.newFileName = value;
                })
            }
            .width('100%')
            .align(Alignment.Start)
            .margin({ top: 8 })

            Row() {
              Text('size: ' + JSON.stringify(this.showFileSize) + 'B')
                .fontSize(12)
                .id('fileSize')
                .fontColor('#182431')
                .textAlign(TextAlign.Start)
                .lineHeight(19)
                .fontWeight(400)
                .opacity(0.6)
                .width('100%')
            }
            .margin({ top: 2, bottom: 11, left: 24, right: 24 })
            .align(Alignment.Start)
          }
          .margin({ top: 11 })
          .height(81)

          Row() {
            TextArea({ text: this.showFileContent, controller: this.controllerArea })
              .fontSize(16)
              .fontColor('#182431')
              .height(384)
              .id('fileContent')
              .borderRadius(0)
              .fontWeight(400)
              .align(Alignment.TopStart)
              .backgroundColor('#f1f3f5')
              .opacity(0.6)
              .margin({ left: 8, right: 8 })
              .onChange((value: string) => {
                this.newFileContent = value;
                Logger.info('EditFile write data to file succeed and newFileContent is:' + this.newFileContent);
              })
          }
          .margin({ top: 11 })
        }
        .width('100%')
        .height('100%')
      }
      .height('100%')
      .width('100%')
      .backgroundColor('#f1f3f5')
    }
  }
}