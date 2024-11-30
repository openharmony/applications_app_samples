/*
 * Copyright (c) 2022-2024 Huawei Device Co., Ltd.
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
import prompt from '@ohos.promptAction';
import common from '@ohos.app.ability.common';
import fileAccess from '@ohos.file.fileAccess';
import documentFileManager from './DocumentFileManager';
import DocumentDataSource from '../../data/DocumentDataSource';
import userFileManager from '@ohos.filemanagement.userFileManager';

const ONE_SECOND: number = 1000;
let rootInfos: fileAccess.RootInfo[] = [];
let fileInfos: fileAccess.FileInfo[] = [];
let context = getContext(this) as common.UIAbilityContext;
let fileAccessHelperAllServer: fileAccess.FileAccessHelper;

@Entry
@Component
struct DocumentFileList {
  @State isNoFile: boolean = true;
  @State showDeleteButton: boolean = false;
  @State fileList: DocumentDataSource = new DocumentDataSource();
  title: Resource = {} as Resource;
  itemClickFunction: (fileAsset: userFileManager.FileAsset) => void = () => {
  }

  async aboutToAppear() {
    fileAccessHelperAllServer = documentFileManager.getDeviceInfo(context, fileAccessHelperAllServer);
    await documentFileManager.getRootsDir(rootInfos, fileAccessHelperAllServer).then((result) => {
      rootInfos = result;
    });
    fileInfos = documentFileManager.iteratorDir(rootInfos);
    AppStorage.setOrCreate('fileListCount', 0);
    documentFileManager.scanFiles(fileInfos).forEach((item: fileAccess.FileInfo) => {
      this.fileList.pushData(item);
      if (this.fileList.totalCount() > 0) {
        this.isNoFile = false;
        AppStorage.setOrCreate('fileListCount', this.fileList.totalCount());
      }
    });
  }

  @Styles
  imagePressedStyles() {
    .backgroundColor($r('app.color.item_pressed'))
    .borderRadius(10)
  }

  build() {
    Column() {
      Row() {
        Image($r('app.media.back'))
          .id('backStep')
          .width(36)
          .height(36)
          .objectFit(ImageFit.Fill)
          .alignSelf(ItemAlign.Start)
          .responseRegion({
            x: 0,
            y: 0,
            width: 45,
            height: 45
          })
          .stateStyles({
            pressed: this.imagePressedStyles
          })
          .onClick(() => {
            router.back();
          })

        Text($r('app.string.document'))
          .fontSize(24)
          .margin({ left: 10 })
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.black'))

        Blank()

        Image($r('app.media.add'))
          .id('fileAdd')
          .width(36)
          .height(36)
          .objectFit(ImageFit.Fill)
          .alignSelf(ItemAlign.End)
          .responseRegion({
            x: 0,
            y: 0,
            width: 45,
            height: 45
          })
          .stateStyles({
            pressed: this.imagePressedStyles,
            normal: {
              .backgroundColor(Color.White)
            }
          })
          .onClick(async () => {
            let fileInfo: fileAccess.FileInfo | undefined = undefined;
            documentFileManager.createFile(fileAccessHelperAllServer).then((result) => {
              fileInfo = result;
              if (fileInfo) {
                this.fileList.pushData(fileInfo);
              }
            })
            this.isNoFile = false;
          })
      }
      .width('100%')
      .margin({ top: 10, bottom: 20 })

      if (this.isNoFile) {
        Column() {
          Image($r('app.media.no_file'))
            .id('no_file')
            .width(36)
            .height(36)
            .margin({ top: 50 })
            .objectFit(ImageFit.Fill)

          Text($r('app.string.no_file'))
            .fontSize(16)
            .margin({ top: 10 })
            .fontWeight(FontWeight.Bold)
            .fontColor($r('app.color.font_gray'))
        }
        .width('100%')
      } else {
        List() {
          LazyForEach(this.fileList, (listItem: fileAccess.FileInfo) => {
            ListItem() {
              FileListItemComponent({
                fileListItem: listItem,
                itemFileList: $fileList,
                itemShowDeleteButton: $showDeleteButton,
                itemIsNoFile: $isNoFile
              })
            }
          }, (listItem: fileAccess.FileInfo) => listItem.fileName)
        }
        .height('100%')
        .width('100%')
      }
    }
    .height('100%')
    .width('100%')
    .backgroundColor($r('app.color.white'))
    .padding(20)
  }
}

@Component
struct FileListItemComponent {
  @Link itemFileList: DocumentDataSource;
  @Link itemShowDeleteButton: boolean;
  @Link itemIsNoFile: boolean;
  private fileListItem: fileAccess.FileInfo = {} as fileAccess.FileInfo;
  private itemClickFunction: (fileAsset: fileAccess.FileInfo) => void = () => {
    prompt.showToast({
      duration: ONE_SECOND,
      message: $r('app.string.not_supported_tip')
    })
  }

  @Styles
  itemPressedStyles() {
    .backgroundColor($r('app.color.item_pressed'))
    .borderRadius(10)
  }

  build() {
    Column() {
      Row() {
        Image($r('app.media.default_document'))
          .objectFit(ImageFit.Fill)
          .width(40)
          .height(40)
          .margin({ left: 20 })

        Column() {
          Text(this.fileListItem.fileName)
            .maxLines(1)
            .width('75%')
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .fontSize(16)
            .fontColor($r('app.color.black'))

          Text(this.fileListItem.mtime + ' - ' + this.fileListItem.size + 'B')
            .fontSize(12)
            .margin({ top: 5 })
            .fontColor($r('app.color.font_gray'))
        }
        .margin({ left: 10 })
        .alignItems(HorizontalAlign.Start)

        Blank()

        if (this.itemShowDeleteButton) {
          Image($r('app.media.delete'))
            .id('fileListDelete')
            .width(30)
            .height(30)
            .margin({ right: 20 })
            .objectFit(ImageFit.Fill)
            .responseRegion({
              x: 0,
              y: 0,
              width: 50,
              height: 50
            })
            .stateStyles({
              pressed: this.itemPressedStyles
            })
            .onClick(() => {
              fileAccessHelperAllServer.delete(this.fileListItem.uri);
              this.itemFileList.deleteData(this.fileListItem.uri);
              this.itemShowDeleteButton = false;
              if (this.itemFileList.totalCount() === 0) {
                this.itemIsNoFile = true;
              }
            })
        }
      }
      .height(56)
      .width('100%')
      .margin({ top: 10 })
    }
    .width('100%')
    .stateStyles({
      pressed: this.itemPressedStyles,
      normal: {
        .backgroundColor(Color.White)
      }
    })
    .onClick(async () => {
      this.itemClickFunction(this.fileListItem);
    })
    .gesture(LongPressGesture({ repeat: true })
      .onAction((event?: GestureEvent) => {
        this.itemShowDeleteButton = true;
      })
    )
  }
}