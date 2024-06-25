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
import { promptAction, router } from '@kit.ArkUI';
import { zlib } from '@kit.BasicServicesKit';
import fileio from '@ohos.fileio';
import { AddDialog } from '../common/AddDialog';
import { DeleteDialog } from '../common/DeleteDialog';
import { ZipLibSource } from '../model/DataSource';

const DOMAIN = 0xF811;
const BUNDLE = 'ZipLib_';
const TAG: string = '[CompressFilesPage]';
let fileList: preferences.Preferences;

@Entry
@Component
struct CompressFilesPage {
  @State isInserted: boolean = false;
  @State files: ZipLibSource = new ZipLibSource([]);
  @State fileName: string = '';
  @State slectFileName: string[] = [];
  @State zipFileNames: string[] = [];
  @State fileContent: string = '';
  @State fileNumber: number = 0;
  @State isSelect: boolean = false;
  private path: string = '';
  private title: Resource = $r('app.string.CompressFiles');
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
        await fileList.put('fileNames', JSON.stringify(this.files.fileData));
        await fileList.flush();
      }
    }),
    autoCancel: true,
  })
  private deleteDialogController: CustomDialogController = new CustomDialogController({
    builder: DeleteDialog({
      fileNames: this.zipFileNames,
      isInserted: this.isInserted,
      deleteFiles: async (isInserted: boolean, fileNames: Array<string>) => {
        hilog.info(DOMAIN, TAG, BUNDLE + `enter the deleteFiles`);
        if (!isInserted) {
          return;
        }
        for (let index = 0; index < this.files.fileData.length; index++) {
          for (let i = 0; i < this.zipFileNames.length; i++) {
            if (this.zipFileNames[i] == this.files.fileData[index]) {
              this.files.deleteData(index);
              await fileList.put('fileNames', JSON.stringify(this.files.fileData));
              await fileList.flush();
            }
          }
        }
      }
    }),
    autoCancel: true,
  })

  async aboutToAppear() {
    fileList = await preferences.getPreferences(getContext(this), 'fileList');
    let ctx = getContext(this) as common.Context;
    this.path = ctx.filesDir;
    let value = await fileList.get('fileNames', '');
    this.files.fileData = JSON.parse(`${value}`);
    this.files.notifyDataReload();
  }

  async zipcompressFiles(path: string, fileNames: Array<string>): Promise<void> {
    let files: string[] = [];
    for (let index = 0; index < fileNames.length; index++) {
      files[index] = `${path}/${fileNames[index]}`;
    }
    let zipFiles = Array.from(files);
    hilog.debug(DOMAIN, TAG, BUNDLE + `zipFile = ${zipFiles}`);
    let newName = `test_` + this.fileNumber + `.zip`;
    this.zipFileNames.push(newName);
    let zipOutFile = `${this.path}/${newName}`;
    hilog.debug(DOMAIN, TAG, BUNDLE + `zipOutFile = ${zipOutFile}`);

    if (this.files.fileData.includes(newName)) {
      promptAction.showToast({
        message: $r('app.string.warning_failed'),
        bottom: '11%'
      });
      return;
    }
    try {
      zlib.compressFiles(zipFiles, zipOutFile, {}).then(data => {
        zlib.getOriginalSize(zipOutFile).then((num) => {
          promptAction.showToast({
            message: $r('app.string.CompressFiles_success_size', num),
            bottom: '11%'
          });
        })
        this.files.pushData(`${newName}`);
      })
    } catch {
      promptAction.showToast({
        message: $r('app.string.CompressFiles_failure'),
        bottom: '11%'
      });
    }
    this.fileNumber = this.fileNumber + 1;
    await fileList.put('fileNames', JSON.stringify(this.files.fileData));
    await fileList.flush();
  }

  build() {
    Column() {
      Column() {
        Row() {
          Row() {
            Image($r('app.media.icon_back'))
              .size({ height: '71%' })
              .objectFit(ImageFit.Contain)
              .onClick(() => {
                router.pushUrl({
                  url: 'zlib/ZLibInterfaceListPage'
                });
              })
            Text(this.title)
              .fontSize(20)
              .margin({ left: 8 })
              .fontWeight(FontWeight.Bold)
          }

          Row() {
            Image($r('app.media.icon_delete'))
              .size({ height: '71%' })
              .id('deleteFile')
              .objectFit(ImageFit.Contain)
              .onClick(() => {
                this.deleteDialogController.open();
              })

            Image($r('app.media.add'))
              .size({ height: '71%' })
              .id('addFile')
              .margin({ left: '3%' })
              .objectFit(ImageFit.Contain)
              .onClick(() => {
                this.dialogController.open();
              })
          }
        }
        .justifyContent(FlexAlign.SpaceBetween)
        .width('91%')
        .height('9.75%')
        .backgroundColor($r('app.color.backGrounding'))

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

                Checkbox()
                  .visibility(item.includes('.zip') ? Visibility.Hidden : Visibility.Visible)
                  .width('6%')
                  .select(false)
                  .id('file_' + index)
                  .selectedColor($r('app.color.checkbox_color'))
                  .shape(CheckBoxShape.CIRCLE)
                  .onChange((value: boolean) => {
                    if (value) {
                      this.isSelect = true;
                      this.slectFileName.push(item);
                    } else {
                      this.isSelect = false;
                    }
                  })
              }
              .justifyContent(FlexAlign.SpaceBetween)
              .padding({ right: 12, left: 12 })
              .width('100%')
              .height('14.2%')
              .borderRadius(16)
              .backgroundColor($r('app.color.start_window_background'))
            }
            .margin({ bottom: 12 })
          }, (item: string) => item)
        }
        .margin({ top: 8 })
        .height('85.875%')
        .width('91%')
        .backgroundColor($r('app.color.index_bg'))
      }
      .height('80%')
      .width('100%')


      Column() {
        Text($r('app.string.tip_CompressFiles'))
          .textAlign(TextAlign.Start)
          .fontSize(12)
          .fontColor($r('app.color.tip_Gzip_backeGround'))
          .width('86.4%')
          .height('22.3%')
          .margin({ bottom: 24 })

        Row() {
          Button($r('app.string.zip'))
            .id('compress')
            .height('100%')
            .width('100%')
            .fontSize(16)
            .fontFamily('HarmonyHeiTi')
            .type(ButtonType.Capsule)
            .backgroundColor($r('app.color.button_color'))
            .fontColor($r('app.color.text_white_color'))
            .borderRadius(20)
            .onClick(() => {
              if (this.isSelect) {
                this.zipcompressFiles(this.path, this.slectFileName);
              }
            })
        }
        .margin({ bottom: 16 })
        .height('28%')
        .width('91%')
      }
      .justifyContent(FlexAlign.End)
      .alignItems(HorizontalAlign.Center)
      .height('20%')
      .width('100%')
    }
    .height('100%')
    .width('100%')
    .backgroundColor($r('app.color.index_bg'))
  }
}
