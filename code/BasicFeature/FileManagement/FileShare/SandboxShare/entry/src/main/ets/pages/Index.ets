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

import fs from '@ohos.file.fs';
import router from '@ohos.router';
import fileUri from '@ohos.file.fileuri';
import Logger from '../common/Logger';
import fileFs from '../fileFs/fileFs';

const TAG = 'ShareIndex: ';

@Entry
@Component
struct Index {
  fileFs: fileFs = new fileFs();
  scroller: Scroller = new Scroller();
  @State uri: string = '';
  @State fileSizeList: Array<number> = [];
  @State fileNameList: Array<string> = [];
  @State fileUriList: Array<string> = [];
  @State fileInfoList: Array<string> = [];
  @State filePathDir: string = '';
  @State dirFlag: boolean = false;
  @StorageLink('filesDir') filesDir: string = '';
  @State listPosition: number = 0; // 0 indicates scrolling to the top of the list, 1 indicates scrolling to the middle of the list, and 2 indicates scrolling to the bottom of the list.

  aboutToAppear() {
    this.fileFs.readyFilesToTestDir(this.filesDir);
    this.fileFs.readyFilesToCurDir(this.filesDir);
  }

  onPageShow() {
    if (this.filePathDir !== '') {
      this.getFileList(this.filePathDir);
    } else {
      this.getFileList();
    }
  }

  getFileList(filesDir: string = this.filesDir) {
    let options = {
      'recursion': false,
      'listNum': 0,
      'filter': {
        'suffix': ['.txt'],
      }
    };
    let filenames = fs.listFileSync(filesDir, options);
    Logger.info(TAG, 'listFile succeed');
    for (let i = 0; i < filenames.length; i++) {
      Logger.info(TAG, 'filename: %s', filenames[i]);
      let filename = filenames[i];
      this.fileNameList[i] = filename;

      let filePath = filesDir + '/' + filename;
      this.filePathDir = filesDir;
      if (filename.indexOf('.') != -1) {
        let sta = fs.statSync(filePath);
        this.fileSizeList[i] = sta.size;
        this.fileInfoList[i] = JSON.stringify(sta.size) + 'B';
      } else {
        let subFilenames = fs.listFileSync(filePath, options);
        let subFileStr = AppStorage.Get('subFilenames');
        this.fileInfoList[i] = JSON.stringify(subFilenames.length) + subFileStr;
      }
    }
  }

  build() {
    Flex() {
      Scroll(this.scroller) {
        Row() {
          Column() {
            Row() {
              Column() {
                Text($r('app.string.sandboxFile'))
                  .fontSize(30)
                  .fontFamily('HarmonyHeiTi-Bold')
                  .fontColor('#182431')
                  .textAlign(TextAlign.Start)
                  .lineHeight(41)
                  .fontWeight(700)
              }
            }
            .padding({ left: '6.7%', right: '6.7%', top: '0.9%', bottom: '1%' })
            .height('7.2%')
            .width('100%')
            .backgroundColor('#f1f3f5')

            Flex({ direction: FlexDirection.Column }) {
              // list
              Column() {
                List({ space: 12, initialIndex: 0 }) {
                  ForEach(this.fileNameList, (item, index) => {
                    ListItem() {
                      Row() {
                        Image($r('app.media.ic_docs'))
                          .width('5%')
                          .height(22)
                          .margin({ left: '3%', right: 0 })

                        Text('item' + item)
                          .fontSize(16)
                          .fontFamily('HarmonyHeiTi-Medium')
                          .fontColor('#182431')
                          .lineHeight(22)
                          .fontWeight(500)
                          .textAlign(TextAlign.Start)
                          .width('60%')
                          .margin({ left: 19, right: 0 })

                        Text(this.fileInfoList[index])
                          .fontSize(14)
                          .fontFamily('HarmonyHeiTi-Medium')
                          .lineHeight(19)
                          .fontColor('#182431')
                          .textAlign(TextAlign.End)
                          .opacity(0.6)
                          .width('22%')
                          .margin({ left: '12%', right: 0 })
                      }
                      .padding({right: '3%' })
                      .borderRadius(24)
                      .width('100%')
                      .height(64)
                      .backgroundColor('#FFFFFF')
                    }
                    .onClick(() => {
                      let filePath = this.filesDir + '/' + item;
                      let index = filePath.indexOf('.');
                      if (index <= 0) {
                        // 分享目录处理逻辑
                        Logger.info(TAG, 'getFileList Dir existed :' + filePath);
                        this.getFileList(filePath);
                        this.dirFlag = true;
                      } else {
                        let fileTestDirPath = this.filePathDir + '/' + item;
                        let content = '';
                        let myUri = '';
                        if (fs.accessSync(fileTestDirPath) && this.dirFlag) {
                          content = this.fileFs.getFileContent(fileTestDirPath);
                          myUri = fileUri.getUriFromPath(fileTestDirPath);
                          router.pushUrl({
                            url: 'pages/Show',
                            params: {
                              fileName: item,
                              fileContent: content,
                              path: fileTestDirPath
                            }
                          }, router.RouterMode.Standard);
                        } else {
                          content = this.fileFs.getFileContent(filePath);
                          myUri = fileUri.getUriFromPath(filePath);
                          router.pushUrl({
                            url: 'pages/Show',
                            params: {
                              fileName: item,
                              fileContent: content,
                              path: filePath
                            }
                          }, router.RouterMode.Standard);
                        }
                      }
                    })
                  }, item => item)
                }
                .margin({ top: '1%', left: 12, right: 12 })
                .listDirection(Axis.Vertical) // 排列方向
                .id('sandboxFileList')
                .edgeEffect(EdgeEffect.Spring) // 滑动到边缘无效果
                .scrollBar(BarState.Auto)
                .alignListItem(ListItemAlign.Center)
              }
              .height('100%')
              .width('100%')
            }
            .height('90%')
            .width('100%')
          }
          .height('100%')
          .width('100%')
          .justifyContent(FlexAlign.Start)
        }
        .height('100%')
        .backgroundColor('#f1f3f5')
      }
    }
    .width("100%").height("100%")
  }
}
