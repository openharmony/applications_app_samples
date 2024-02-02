/*
 * Copyright (c) 2023-2024 Shenzhen Kaihong Digital Industry Development Co., Ltd.
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

import router from '@ohos.router';
import fs from '@ohos.file.fs';
import common from '@ohos.app.ability.common';
import utdDesc from '@ohos.data.uniformTypeDescriptor';
import { BusinessError } from '@ohos.base';
import { logger } from '../util/Logger';

const TAG: string = 'SelectMediaType';
// 获取应用文件路径
let context = getContext(this) as common.UIAbilityContext;
let baseDir = context.filesDir;
let filesDir = baseDir + '/udmf_test';

let class2UTD = new Map([
  ["All", "All"],
  ["Images", "general.image"],
  ["Audios", "general.audio"],
  ["Videos", "general.video"]
]);

class FileInfo {
  filename: string;
  iconFile: string;

  constructor(fileName: string, iconFile: string) {
    this.filename = fileName;
    this.iconFile = iconFile;
  }
}

@Entry
@Component
struct selectMediaType {
  @State text: string = "Images";
  @State index: number = 1;
  @State space: number = 12;
  @State arrowPosition: ArrowPosition = ArrowPosition.END;
  @State fileNames: string[] = [];
  @State selectedFilesInfos: FileInfo[] = [];
  private routerBackUrl: string = 'pages/Index';
  private routerNextUrl: string = 'pages/displayMediaFile';

  getListFile(): string[] {
    let files = fs.listFileSync(filesDir);
    return files;
  }

  UpdateSelectedFiles(): void {
    this.fileNames = this.getListFile();
    for (let i = this.selectedFilesInfos.length - 1; i >= 0; i--) {
      this.selectedFilesInfos.pop();
    }
    this.selectedFilesInfos = [];
    logger.info(TAG, "selectText: " + this.text)
    for (let i = 0; i < this.fileNames.length; i++) {
      let fileName = this.fileNames[i];
      let index = fileName.lastIndexOf('.');
      if (index < 0) {
        logger.info(TAG, `fileNames file: ${fileName}`);
        if (this.text == "All") {
          let fileInfo = new FileInfo(fileName, "");
          this.selectedFilesInfos.push(fileInfo);
        }
        continue;
      } else {
        let fileExtension = fileName.substring(index);
        let utd = utdDesc.getUniformDataTypeByFilenameExtension(fileExtension);
        logger.info(TAG, `fileNames file: ${fileName}, extension: ${fileExtension}, utd: ${utd}`);
        try {
          if (utd != null) {
            let typeObj: utdDesc.TypeDescriptor = utdDesc.getTypeDescriptor(utd);
            if (class2UTD.get(this.text) == "All") {
              let fileInfo = new FileInfo(fileName, typeObj.iconFile);
              this.selectedFilesInfos.push(fileInfo);
              logger.info(TAG, `All type: ${fileInfo.filename}, utd: ${utd}, iconFile: ${fileInfo.iconFile}`);
            } else {
              let ret = typeObj.belongsTo(class2UTD.get(this.text));
              logger.info(TAG, `typeObj.belongsTo: ${fileName}, utd: ${class2UTD.get(this.text)}, ret: ${ret} iconFile: ${typeObj.iconFile}`);
              if (ret) {
                let fileInfo = new FileInfo(fileName, typeObj.iconFile);
                this.selectedFilesInfos.push(fileInfo);
              }
            }
          } else {
            if (class2UTD.get(this.text) == "All") {
              let fileInfo = new FileInfo(fileName, "");
              this.selectedFilesInfos.push(fileInfo);
              logger.info(TAG, `utd null All type: ${fileInfo.filename}, utd: ${utd}, iconFile: ${fileInfo.iconFile}`);
            }
          }
        }
        catch (e) {
          let error: BusinessError = e as BusinessError;
          logger.error(TAG, `belongsTo throws an exception. code is ${error.code}, message is ${error.message}`);
        }
      }
    }
    logger.info(TAG, `all files ${JSON.stringify(this.selectedFilesInfos)}}`);
  }

  aboutToAppear() {
    logger.info(TAG, 'filesDir: ' + filesDir);
    this.UpdateSelectedFiles();
  }

  aboutToDisappear() {
    for (let i = this.selectedFilesInfos.length - 1; i >= 0; i--) {
      this.selectedFilesInfos.pop();
    }
  }

  build() {
    Column() {
      Column() {
        Row() {
          Image($r('app.media.utdType_back'))
            .id('secondPageBack')
            .width(24)
            .height(24)
            .objectFit(ImageFit.Fill)
            .visibility(Visibility.Visible)
            .alignSelf(ItemAlign.Auto)
            .margin({ left: 24, right: 12 })
            .onClick(() => {
              router.pushUrl({ url: this.routerBackUrl }, router.RouterMode.Single);
            })
          Text($r('app.string.selectMediaType_title'))
            .fontStyle(FontStyle.Normal)
            .fontSize(20)
            .fontWeight(700)
            .textAlign(TextAlign.Start)
            .id('titleText')
        }
        .width('100%')
        .height(56)
        .alignItems(VerticalAlign.Center)
      }
      .width(280)
      .height(56)
      .alignItems(HorizontalAlign.Start)

      Column() {
        Select([{ value: 'All', icon: $r('app.media.ic_select_option_collection') },
          { value: 'Images', icon: $r('app.media.ic_select_option_collection') },
          { value: 'Audios', icon: $r('app.media.ic_select_option_collection') },
          { value: 'Videos', icon: $r('app.media.ic_select_option_collection') }])
          .selected(this.index)
          .value(this.text)
          .id('SelectTypeList')
          .font({ size: 16, weight: 500 })
          .fontColor('#182431')
          .selectedOptionFont({ size: 16, weight: 500 })
          .optionFont({ size: 16, weight: 500 })
          .space(this.space)
          .arrowPosition(this.arrowPosition)
          .menuAlign(MenuAlignType.START, { dx: 0, dy: 0 })
          .backgroundColor($r('app.color.background_shallow_grey'))
          .onSelect((index: number, text?: string | undefined) => {
            this.index = index;
            if (text) {
              this.text = text;
              logger.info(TAG, 'Select type:' + text);
              this.UpdateSelectedFiles();
            }
          })
      }
      .margin({ left: 12, right: 12 })
      .height(48)
      .width(160)
      .alignItems(HorizontalAlign.Start)
      .justifyContent(FlexAlign.Center)

      Column() {
        List({ space: 2, initialIndex: 0 }) {
          ForEach(this.selectedFilesInfos, (item: FileInfo, no: Number) => {
            ListItem() {
              Row() {
                Column() {
                  Text(item.filename)
                    .fontSize(16)
                    .height(46)
                    .textAlign(TextAlign.Start)
                    .margin({ left: 12, right: 12 })
                    .fontWeight(500)
                    .id("textFilename_" + no)
                    .visibility(Visibility.Visible)
                    .onClick(() => {
                      logger.info(TAG, `selected file：` + item.filename + `and clicked`);
                      try {
                        router.pushUrl({
                          url: this.routerNextUrl,
                          params: {
                            src: item.filename,
                            selectIconFile: item.iconFile
                          }
                        }, router.RouterMode.Single);
                      }
                      catch (e) {
                        let error: BusinessError = e as BusinessError;
                        logger.error(TAG, `select file and router exception. code is ${error.code}, message is ${error.message}`);
                      }
                    })
                  Divider()
                    .vertical(false)
                    .height(2)
                    .color($r('app.color.background_shallow_grey'))
                    .opacity(0.6)
                    .margin({ left: 12, right: 12 })
                }
                .width('100%')
                .height(48)
                .justifyContent(FlexAlign.Center)
                .alignItems(HorizontalAlign.Start)
              }
              .width('100%')
              .height(48)
              .alignItems(VerticalAlign.Center)
            }
            .id("listItem_" + no)
          })
        }
        .listDirection(Axis.Vertical) // 排列方向
        .scrollBar(BarState.Auto)
        .friction(0.6)
        .margin({ left: 12, right: 12 })
        .borderRadius(24)
        .edgeEffect(EdgeEffect.Spring) // 边缘效果设置为Spring
        .onScrollIndex((firstIndex: number, lastIndex: number, centerIndex: number) => {
          logger.info(TAG, 'first: ' + firstIndex);
          logger.info(TAG, 'last: ' + lastIndex);
          logger.info(TAG, 'center: ' + centerIndex);
        })
        .onScroll((scrollOffset: number, scrollState: ScrollState) => {
          logger.info(TAG, `onScroll scrollState = ScrollState` + scrollState + `, scrollOffset = ` + scrollOffset);
        })
        .backgroundColor(0xFFFFFF)
      }
      .width('100%')
      .height(680)
      .alignItems(HorizontalAlign.Start)
      .justifyContent(FlexAlign.Start)
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.background_shallow_grey'))
    .alignItems(HorizontalAlign.Start)
    .justifyContent(FlexAlign.Center)
  }
}
