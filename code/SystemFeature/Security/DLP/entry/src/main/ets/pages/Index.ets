/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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

import picker from '@ohos.file.picker';
import { BusinessError } from '@ohos.base';
import common from '@ohos.app.ability.common';
import { MediaFileUri, FileInfoType } from '../feature/FileManager';
import Want from '@ohos.app.ability.Want';
import Logger from '../util/Logger';
import fileuri from '@ohos.file.fileuri';
import { DlpManager, TestDlpFileInfo } from '../feature/DlpManager';
import { CustomDialogExample } from '../component/CustomDialog';
import { PreferencesManager } from '../feature/PreferencesManager';
import { getResourceString } from '../util/ResourceUtils';

let context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext;

@Entry
@Component
struct FilePicker {
  @State uri: string = '';
  // 文件名
  @State fileName: string = '';
  @State mediaFileUri: MediaFileUri = new MediaFileUri();
  // 长按开关
  @State itemShowDeleteButton: boolean = false;
  @State dlpManager: DlpManager = new DlpManager();
  // 当前权限
  @State currentPerssion: number = -1;
  @State currentSelectedFileUri: string = '';
  // 避免aboutToAppear函数重复执行的标识
  @State isFlag: boolean = false;
  // 文件集合信息
  @StorageLink('fileInfos') fileInfos: Array<FileInfoType> = [];
  // dlp文件信息
  @StorageLink('dlpFileInfos') dlpFileInfos: Array<TestDlpFileInfo> = [];
  @State preferencesManager: PreferencesManager = new PreferencesManager();
  dialogController: CustomDialogController = new CustomDialogController({
    builder: CustomDialogExample({
      currentPerssion: $currentPerssion,
      currentSelectedFileUri: $currentSelectedFileUri,
    }),
    autoCancel: true,
    offset: { dx: 0, dy: 0 },
    gridCount: 4,
    customStyle: false
  })

  async aboutToAppear() {
    Logger.info(`aboutToAppear start`);
    this.isFlag = true;
    await this.dlpManager.AccountLogin('zhangsan');
    await this.preferencesManager.getPreferences();
  }

  async onPageShow() {
    if (!this.isFlag) {
      Logger.info(`onPageShow start`);
      await this.mediaFileUri.getAllFiles(context, this.dlpFileInfos);
    }
  }

  async onPageHide() {
    Logger.info(`onPageHide start`);
    this.isFlag = false;
  }

  // 拉起picker保存文件
  async callFilePickerSaveFile(): Promise<void> {
    try {
      let DocumentSaveOptions = new picker.DocumentSaveOptions();
      DocumentSaveOptions.newFileNames = [getResourceString(context, $r('app.string.init_file_name'))];
      let documentPicker = new picker.DocumentViewPicker();
      documentPicker.save(DocumentSaveOptions).then((DocumentSaveResult) => {
        Logger.info('DocumentViewPicker.save successfully, DocumentSaveResult uri: ' + JSON.stringify(DocumentSaveResult));
        if (DocumentSaveResult !== null && DocumentSaveResult !== undefined) {
          this.uri = DocumentSaveResult[0];
          Logger.info(`save file uri: ${this.uri}`);
        }
        this.getFilenameByUri(this.uri);
      })
    } catch (err) {
      Logger.error('DocumentViewPicker failed with err: ' + err);
    }
  }

  /**
   * 拉起picker选择文件
   */
  async callFilePickerSelectFile(): Promise<void> {
    try {
      let DocumentSelectOptions = new picker.DocumentSelectOptions();
      let documentPicker = new picker.DocumentViewPicker();
      documentPicker.select(DocumentSelectOptions).then((DocumentSelectResult) => {
        Logger.info('DocumentViewPicker.select successfully, DocumentSelectResult uri: ' + JSON.stringify(DocumentSelectResult));
        let editFlag = false;
        if (DocumentSelectResult !== null && DocumentSelectResult !== undefined) {
          DocumentSelectResult.forEach((value) => {
            this.uri = value;
            editFlag = true;
            Logger.info(`select file uri: ${this.uri}`);
          })
        }
        if (editFlag) {
          this.getFilenameByUri(this.uri);
        }
      })
    } catch (err) {
      Logger.error('DocumentViewPicker failed with err: ' + JSON.stringify(err));
    }
  }

  // 获取文件名称
  async getFilenameByUri(myUri: string): Promise<void> {
    // 获取文件名称
    this.fileName = (myUri.split('/').pop()) as string;
    Logger.info('the fileName is' + this.fileName);
  }

  // 删除dlp文件
  async deleteDLPFile(fileMsg: FileInfoType) {
    this.dlpFileInfos.forEach(async (dlpFileInfoItem: TestDlpFileInfo, ind: number) => {
      let uriInfo: fileuri.FileUri = await this.mediaFileUri.getFileName(dlpFileInfoItem.plaintextPath);
      if (uriInfo.name === fileMsg.fileName) {
        await this.mediaFileUri.deleteFile(dlpFileInfoItem.ciphertextPath);
        this.dlpFileInfos.splice(ind, 1);
        await this.preferencesManager.putDlpFileInfos(this.dlpFileInfos);
        await this.mediaFileUri.getAllFiles(context, this.dlpFileInfos);
      }
    })
  }

  // 文件类型判断函数
  async determineEncryption(fileMsg: FileInfoType) {
    if (this.itemShowDeleteButton) {
      this.itemShowDeleteButton = false;
    }
    if (fileMsg.isEncryption) {
      this.dlpFileInfos.forEach(async (dlpFileInfoItem: TestDlpFileInfo, ind: number) => {
        let uriInfo: fileuri.FileUri = await this.mediaFileUri.getFileName(dlpFileInfoItem.plaintextPath);
        if (uriInfo.name === fileMsg.fileName) {
          let dlpUriInfo: fileuri.FileUri = await this.mediaFileUri.getFileName(dlpFileInfoItem.ciphertextPath);
          await this.startAbility(dlpUriInfo.name, dlpFileInfoItem.ciphertextPath);
        }
      })
    } else {
      await this.startAbility(fileMsg.fileName, fileMsg.fileUri);
    }
  }

  // 打开文件编辑应用
  async startAbility(fileName: string, myUri: string) {
    let want: Want = {
      bundleName: 'com.example.fileEdit',
      abilityName: 'EntryAbility',
      parameters: {
        fileName: fileName,
        myUri: myUri,
      },
    };
    context.startAbility(want, (err: BusinessError) => {
      Logger.error(`Failed to startAbility. Code: ${err.code}, message: ${err.message}`);
    });
  }

  build() {
    Column() {
      Row() {
        Text($r('app.string.file_list'))
          .fontFamily('HarmonyHeiTi-Bold')
          .fontSize(30)
          .fontWeight(700)
          .fontColor(Color.Black)
        Row() {
          Image($r('app.media.ic_saveas'))
            .width(25)
            .height(25)
            .id('newFile')
            .onClick(() => {
              this.callFilePickerSaveFile();
            })
          Image($r('app.media.ic_folder'))
            .width(25)
            .height(25)
            .id('folder')
            .margin({ left: 30 })
            .onClick(() => {
              this.callFilePickerSelectFile();
            })
        }
      }.justifyContent(FlexAlign.SpaceBetween)
      .width('100%')

      // 文件列表
      List({ space: 12, initialIndex: 0 }) {
        ForEach(this.fileInfos, (item: FileInfoType, index: number) => {
          ListItem() {
            Row() {
              Row() {
                Image($r('app.media.ic_files_grid_txt'))
                  .width(30)
                  .height(30)
                  .margin({ left: 15, right: 19 })

                Text(item.fileName)
                  .fontSize(16)
                  .fontFamily('HarmonyHeiTi-Medium')
                  .fontColor('#182431')
                  .lineHeight(22)
                  .fontWeight(500)
                  .textAlign(TextAlign.Start)
                  .margin({ left: 0, right: 16 })
              }

              if (!this.itemShowDeleteButton) {
                Text(`Size: 0B`)
                  .fontSize(14)
                  .fontFamily('HarmonyHeiTi-Medium')
                  .lineHeight(19)
                  .fontColor('#182431')
                  .textAlign(TextAlign.End)
                  .opacity(0.6)
                  .width('20.8%')
                  .margin({ left: 0, right: 12 })
              } else {
                Row() {
                  Image($r('app.media.delete'))
                    .width(30)
                    .height(30)
                    .id('deleteBtn')
                    .margin({ left: 15, right: 19 })
                    .onClick(() => {
                      let currentIndex: number = -1;
                      this.fileInfos.forEach((fileInfoItem: FileInfoType, ind: number) => {
                        if (item.fileName === fileInfoItem.fileName) {
                          currentIndex = ind;
                        }
                      });
                      this.mediaFileUri.deleteFile(this.fileInfos[currentIndex].fileUri).then(async () => {
                        this.fileInfos.splice(currentIndex, 1);
                        this.itemShowDeleteButton = false;
                        await this.deleteDLPFile(item);
                        this.mediaFileUri.getAllFiles(context, this.dlpFileInfos);
                      })
                    })
                  Image(item.isEncryption ? $r('app.media.ic_public_unlock_filled') : $r('app.media.ic_public_lock_filled'))
                    .width(30)
                    .height(30)
                    .id('encryption')
                    .onClick(async () => {
                      if (item.isEncryption) {
                        item.isEncryption = false;
                        this.itemShowDeleteButton = false;
                        await this.deleteDLPFile(item);
                      } else {
                        this.currentSelectedFileUri = item.fileUri;
                        this.dialogController.open();
                        this.itemShowDeleteButton = false;
                      }
                    })
                }
              }

            }
            .justifyContent(FlexAlign.SpaceBetween)
            .borderRadius(24)
            .width('100%')
            .height(64)
            .padding({ right: 12 })
            .backgroundColor('#FFFFFF')
          }
          .id('fileItem')
          .onClick(async () => {
            await this.determineEncryption(item);
          })
          .gesture(LongPressGesture({ repeat: true })
            .onAction((event?: GestureEvent) => {
              this.itemShowDeleteButton = true;
            })
          )
        })
      }
      .listDirection(Axis.Vertical) // 排列方向
      .edgeEffect(EdgeEffect.Spring) // 滑动到边缘无效果
      .scrollBar(BarState.Auto)
      .alignListItem(ListItemAlign.Center)
      .margin({ top: '1%', left: 12, right: 12 })
    }.width('100%')
    .height('100%')
    .padding(12)
    .backgroundColor('#f1f3f5')
  }
}