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

import { common } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { preferences } from '@kit.ArkData';
import { promptAction } from '@kit.ArkUI';
import { zlib } from '@kit.BasicServicesKit';
import fileio from '@ohos.fileio';
import { AddDialog } from '../common/AddDialog';
import { ZipLibSource } from '../model/DataSource';
import { router } from '@kit.ArkUI';

const DOMAIN = 0xF811;
const BUNDLE = 'ZipLib_';
const TAG: string = '[ZipLibDecompressionPage]';
let fileList: preferences.Preferences;

@Entry
@Component
struct ZipLibDecompressionPage {
  @State isInserted: boolean = false;
  @State files: ZipLibSource = new ZipLibSource([]);
  @State fileName: string = '';
  @State fileContent: string = '';
  private path: string = '';
  private title: Resource = $r('app.string.MainAbility_label');
  private dialogController: CustomDialogController = new CustomDialogController({
    builder: AddDialog({
      fileName: this.fileName,
      fileContent: this.fileContent,
      isInserted: this.isInserted,
      createFile: async (isInserted: boolean, fileName: string, fileContent: string) => {
        hilog.info(DOMAIN, TAG, BUNDLE + `enter the createFile`);
        this.fileName = `${fileName}.txt`;
        let isDuplication = this.files.fileData.includes(this.fileName);
        hilog.info(DOMAIN, TAG, BUNDLE + `isInserted = ${isInserted}  isDuplication = ${isDuplication}`);
        if (!isInserted || isDuplication) {
          return;
        }
        let fd = fileio.openSync(`${this.path}/${this.fileName}`, 0o100 | 0o2, 0o666);
        let number = fileio.writeSync(fd, fileContent);
        hilog.info(DOMAIN, TAG, BUNDLE + `fd = ${fd} number = ${number}`);
        this.files.pushData(this.fileName);
        hilog.info(DOMAIN, TAG, BUNDLE + `this.files = ${JSON.stringify(this.files.fileData)}`);
        await fileList.put('fileName', JSON.stringify(this.files.fileData));
        await fileList.flush();
      }
    }),
    autoCancel: true,
    alignment: DialogAlignment.Default
  })

  async aboutToAppear() {
    fileList = await preferences.getPreferences(getContext(this), 'fileList');
    let ctx = getContext(this) as common.Context;
    this.path = ctx.filesDir;
    let value = await fileList.get('fileName', '');
    this.files.fileData = JSON.parse(`${value}`);
    this.files.notifyDataReload();
  }

  async zipHandler(path: string, fileName: string): Promise<void> {
    let zipFile = `${path}/${fileName}`;
    hilog.debug(DOMAIN, TAG, BUNDLE + `zipFile = ${zipFile}`);
    let tempName = fileName.split('.');
    let newName = `${tempName[0]}.zip`;
    let zipOutFile = `${this.path}/${newName}`;
    hilog.debug(DOMAIN, TAG, BUNDLE + `zipOutFile = ${zipOutFile}`);

    let options: zlib.Options = {
      level: zlib.CompressLevel.COMPRESS_LEVEL_DEFAULT_COMPRESSION,
      memLevel: zlib.MemLevel.MEM_LEVEL_DEFAULT,
      strategy: zlib.CompressStrategy.COMPRESS_STRATEGY_DEFAULT_STRATEGY
    }
    if (this.files.fileData.includes(newName)) {
      promptAction.showToast({
        message: $r('app.string.warning_failed'),
        bottom: '11%'
      });
      return;
    }
    try {
      zlib.compressFile(zipFile, zipOutFile, options).then(data => {
        hilog.info(DOMAIN, TAG, BUNDLE + `data = ${JSON.stringify(data)}`);
        promptAction.showToast({
          message: $r('app.string.tip_complete'),
          bottom: '11%'
        });
        this.files.pushData(`${newName}`);
      })
    } catch {
      promptAction.showToast({
        message: $r('app.string.warning_failure'),
        bottom: '11%'
      });
    }
    await fileList.put('fileName', JSON.stringify(this.files.fileData));
    await fileList.flush();
  }

  async unzipHandler(path: string, fileName: string): Promise<void> {
    let zipFile = `${path}/${fileName}`;
    hilog.info(DOMAIN, TAG, BUNDLE + `zipFile = ${zipFile}`);
    let tempName = fileName.split('.');
    let newName = tempName[0];
    let zipOutFile = `${this.path}/${newName}`;
    hilog.info(DOMAIN, TAG, BUNDLE + `zipOutFile = ${zipOutFile}`);
    if (this.files.fileData.includes(newName)) {
      promptAction.showToast({
        message: $r('app.string.warning_failed'),
        bottom: '11%'
      });
      return;
    }
    let options: zlib.Options = {
      level: zlib.CompressLevel.COMPRESS_LEVEL_DEFAULT_COMPRESSION,
      memLevel: zlib.MemLevel.MEM_LEVEL_DEFAULT,
      strategy: zlib.CompressStrategy.COMPRESS_STRATEGY_DEFAULT_STRATEGY
    }

    zlib.decompressFile(zipFile, zipOutFile, options).then(data => {
      hilog.info(DOMAIN, TAG, BUNDLE + `data = ${JSON.stringify(data)}`);
    })
    promptAction.showToast({
      message: $r('app.string.tip_complete'),
      bottom: '11%'
    });
    this.files.pushData(`${newName}`);
    await fileList.put('fileName', JSON.stringify(this.files.fileData));
    await fileList.flush();
  }

  build() {
    Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center }) {
      Column() {
        Row() {
          Row() {
            Image($r('app.media.icon_back'))
              .size({ height: '71%' })
              .objectFit(ImageFit.Contain)
              .onClick(() => {
                router.pushUrl({
                  url: 'pages/Index'
                });
              })
            Text(this.title)
              .fontSize(20)
              .margin({ left: 8 })
              .fontWeight(FontWeight.Bold)
          }

          Image($r('app.media.add'))
            .size({ height: '71%' })
            .id('addFileBtn')
            .objectFit(ImageFit.Contain)
            .onClick(() => {
              this.dialogController.open();
            })
        }
        .justifyContent(FlexAlign.SpaceBetween)
        .width('91%')
        .height('7.8%')
        .backgroundColor($r('app.color.backGrounding'))

        Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center }) {
          List({ initialIndex: 0 }) {
            LazyForEach(this.files, (item: string, index: number) => {
              ListItem() {
                Row() {
                  Row() {
                    Image(item.includes('.zip') ? $r('app.media.zip') : $r('app.media.file'))
                      .size({ height: '66.7%' })
                      .objectFit(ImageFit.Contain)
                    Column() {
                      Text(item)
                        .width('50%')
                        .fontSize(16)
                        .margin({ left: 16 })
                    }
                  }

                  Row() {
                    Button(item.includes('.zip') ? $r('app.string.unzip') : $r('app.string.zip'))
                      .fontSize(12)
                      .fontFamily('HarmonyHeiTi')
                      .fontWeight(500)
                      .fontColor($r('app.color.text_white_color'))
                      .width('100%')
                      .height('100%')
                      .onClick(() => {
                        item.includes('.zip') ? this.unzipHandler(this.path, item) : this.zipHandler(this.path, item);
                      })
                      .id('compress_' + index)
                      .borderRadius(14)
                      .backgroundColor($r('app.color.button_color'))
                  }
                  .width('22%')
                  .height('50%')
                }
                .justifyContent(FlexAlign.SpaceBetween)
                .padding({ right: 12, left: 12 })
                .width('100%')
                .height('14.2%')
                .borderRadius(20)
                .backgroundColor($r('app.color.start_window_background'))
              }
              .margin({ bottom: 12 })
            }, (item: string) => item)
          }
          .margin({ top: 8 })
          .height('68.7%')
          .width('91%')
          .backgroundColor($r('app.color.index_bg'))
        }
        .height('100%')
        .width('100%')
      }
      .height('100%')
      .width('100%')
      .backgroundColor($r('app.color.index_bg'))
    }
  }
}
