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

import router from '@ohos.router';
import FileDataSource from '../../data/FileDataSource';
import userFileManager from '@ohos.filemanagement.userFileManager';
import { Logger, FileManager, ThumbnailImage } from '@ohos/feature-file-manager';

const SIZE_M: number = 1024 * 1024;
const ONE_SECOND: number = 1000;
const context = getContext(this);
let sanBoxFileDir: string = AppStorage.get('sanBoxFileDir') as string;

@Preview
@Component
export struct FileList {
  @State fileList: FileDataSource = new FileDataSource();
  @State isNoFile: boolean = true;
  @State showDeleteButton: boolean = false;
  title: Resource = {} as Resource;
  mediaType: userFileManager.FileType = userFileManager.FileType.AUDIO;
  itemClickFunction: (fileAsset: userFileManager.FileAsset) => void = () => {
  }

  async aboutToAppear() {
    let files = await FileManager.getFileAssets(getContext(), this.mediaType);
    if (files == undefined) {
      Logger.error('files undefined');
      return;
    }
    if (files.getCount() > 0) {
      Logger.debug('show list');
      this.isNoFile = false;
    }
    for (let i = 0; i < files.getCount(); i++) {
      let fileAsset: userFileManager.FileAsset = await files.getNextObject();
      if (fileAsset == undefined) {
        continue;
      }
      this.fileList.pushData(fileAsset);
    }
  }

  @Styles imagePressedStyles() {
    .backgroundColor($r('app.color.item_pressed'))
    .borderRadius(10)
  }

  build() {
    Column() {
      Row() {
        Image($r('app.media.back'))
          .id('back')
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
            router.back()
          })

        Text(this.title)
          .fontSize(24)
          .margin({ left: 10 })
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.black'))

        Blank()
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
          LazyForEach(this.fileList, (listItem: userFileManager.FileAsset) => {
            ListItem() {
              FileListItemComponent({
                itemFileList: $fileList,
                fileListItem: listItem,
                itemClickFunction: this.itemClickFunction,
                uri: listItem.uri,
                itemShowDeleteButton: $showDeleteButton,
                itemIsNoFile: $isNoFile
              })
            }
          }, (listItem: userFileManager.FileAsset) => JSON.stringify(listItem.displayName))
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
  @Link itemFileList: FileDataSource
  @Link itemShowDeleteButton: boolean
  @Link itemIsNoFile: boolean
  private fileListItem: userFileManager.FileAsset = {} as userFileManager.FileAsset;
  private itemClickFunction: (fileAsset: userFileManager.FileAsset) => void = () => {
  }
  private uri: string = '';

  @Styles itemPressedStyles() {
    .backgroundColor($r('app.color.item_pressed'))
    .borderRadius(10)
  }

  build() {
    Column() {
      Row() {
        ThumbnailImage({ fileAsset: this.fileListItem })
          .width(40)
          .height(40)
          .margin({ left: 20 })

        Column() {
          Text(this.fileListItem.displayName)
            .maxLines(1)
            .width('75%')
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .fontSize(16)
            .fontColor($r('app.color.black'))

          Text(new Date(FileManager.getFileState(sanBoxFileDir)
            .crtime * ONE_SECOND).toLocaleDateString() + ' - ' +
          Math.ceil(FileManager.getFileState(sanBoxFileDir).size / SIZE_M) + 'M')
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
              FileManager.deleteFileAsset(context, this.fileListItem);
              this.itemFileList.deleteData(this.uri);
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
      this.itemClickFunction(this.fileListItem)
    })
    .gesture(LongPressGesture({ repeat: true })
      .onAction((event?: GestureEvent) => {
        this.itemShowDeleteButton = true;
      })
    )
  }
}