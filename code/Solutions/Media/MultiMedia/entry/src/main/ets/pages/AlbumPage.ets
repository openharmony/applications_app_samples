/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
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

import userFileManager from '@ohos.filemanagement.userFileManager'
import fileAccess from '@ohos.file.fileAccess';
import router from '@ohos.router'
import Logger from '../model/Logger'
import MediaUtils, { FileType } from '../model/MediaUtils'
import MediaDataSource, { MediaData } from '../view/BasicDataSource'
import { MediaItem } from '../view/MediaItem'
import { RenameDialog } from '../view/RenameDialog'
import TitleBar from '../view/TitleBar'
import { BusinessError } from '@ohos.base'
import common from '@ohos.app.ability.common'

interface RouterParams {
  albumName: string;
  mediaType: number;
}

const context = getContext(this) as common.UIAbilityContext

@Entry
@Component
struct AlbumPage {
  private tag: string = 'AlbumPage'
  private albumName: string = (router.getParams() as RouterParams).albumName
  private mediaType: number = (router.getParams() as RouterParams).mediaType
  private mediaUtils: MediaUtils = MediaUtils.getInstance(getContext(this))
  @State selectMedia: MediaData = {} as MediaData
  private renameDialogController: CustomDialogController = new CustomDialogController({
    builder: RenameDialog({
      selectMedia: $selectMedia,
      action: (selectMedia: MediaData) => this.renameMedia(selectMedia)
    }),
    autoCancel: true
  });
  private mediaDataSource: MediaDataSource = new MediaDataSource()

  btnAction(operate: string, index: number, mediaItemUri: string): void {
    Logger.info(this.tag, `btnAction callback,operate: ${operate}, index: ${index}, mediaItemUri: ${mediaItemUri}`)
    let selectMediaArray = this.mediaDataSource.getDataArray().filter((item) => {
      return item.uri === mediaItemUri;
    });
    this.selectMedia = selectMediaArray[0];
    if (operate === 'delete') {
      this.deleteMedia(() => {
        this.mediaUtils.deleteFile(this.mediaType, this.selectMedia.uri, context);
        this.mediaDataSource.getDataArray().forEach((item: MediaData, index: number) => {
          if (item.uri === mediaItemUri) {
            this.mediaDataSource.deleteData(index, 1);
            this.mediaDataSource.notifyDataReload();
          }
        })
      })
    } else {
      this.renameDialogController.open()
    }
  }

  async renameMedia(selectMedia: MediaData): Promise<void> {
    Logger.info(this.tag, `renameMedia newName = ${this.selectMedia.displayName}`)
    // 重命名文件资源
    if (this.mediaType === 4) {
      let fileAccessHelper = fileAccess.createFileAccessHelper(context);
      try {
        await fileAccessHelper.rename(selectMedia.uri, selectMedia.displayName);
        Logger.info(this.tag, 'commitModify success')
        this.renameDialogController.close()
        this.refreshData()
      } catch (err) {
        Logger.info(this.tag, `commitModify,err: ${err}`)
      }
    } else {
      // 重命名图片/视频/音频资源
      let fileAssetList: userFileManager.FileAsset[] = await this.mediaUtils.getFileAssetsFromType(this.mediaType)
      let fileAsset: userFileManager.FileAsset | undefined = fileAssetList.find(item => item.uri === selectMedia.uri)
      if (fileAsset !== undefined) {
        try {
          fileAsset.set('display_name', selectMedia.displayName)
          await fileAsset.commitModify();
          Logger.info(this.tag, 'commitModify success')
          this.renameDialogController.close()
          this.refreshData()
        } catch (err) {
          Logger.info(this.tag, `commitModify,err: ${err}`)
        }
      }
    }
  }

  deleteMedia(deleteAction: () => void) {
    AlertDialog.show(
      {
        message: $r('app.string.delete_file'),
        primaryButton: {
          value: $r('app.string.yes'),
          fontColor: Color.Red,
          action: () => {
            deleteAction()
          }
        },
        secondaryButton: {
          value: $r('app.string.cancel'),
          fontColor: Color.Blue,
          action: () => {
          }
        }
      }
    )
  }

  refreshData() {
    if (this.mediaType === 4) {
      let fileInfos = this.mediaUtils.getFileAssets(context)
      fileInfos.then(fileList => {
        Logger.info(this.tag, 'getFileList callback')
        let mediaDataList: MediaData[] = fileList.map(file => {
          let mediaData: MediaData = {
            uri: file.uri,
            fileType: 4,
            displayName: file.fileName,
            duration: 0,
            dateAdded: file.mtime
          }
          return mediaData
        })
        this.mediaDataSource.setDataArray(mediaDataList)
        this.mediaDataSource.notifyDataReload()
      }).catch((err: BusinessError) => {
        Logger.error(this.tag, `getFileList err,err = ${err}`)
      })
    } else {
      let fileAsset = this.mediaUtils.getFileAssetsFromType(this.mediaType)
      fileAsset.then(fileList => {
        Logger.info(this.tag, 'getFileList callback')
        let mediaDataList: MediaData[] = fileList.map(file => {
         let mediaData: MediaData = {
            uri: file.uri,
            fileType: file.fileType as number,
            displayName: file.displayName,
            duration: file.get('duration') as number,
            dateAdded: file.get('date_added') as number
          }
          return mediaData
        })
        this.mediaDataSource.setDataArray(mediaDataList)
        this.mediaDataSource.notifyDataReload()
      }).catch((err: BusinessError) => {
        Logger.error(this.tag, `getFileList err,err = ${err}`)
      })
    }
  }

  aboutToAppear() {
    Logger.info(this.tag, `mediaType=${this.mediaType}`)
    this.refreshData()
  }

  build() {
    Column() {
      TitleBar({ title: this.albumName })
      List() {
        LazyForEach(this.mediaDataSource, (item: MediaData, index) => {
          ListItem() {
            MediaItem({
              media: item,
              index: index,
              btnAction: (operate, index, mediaItemUri) => this.btnAction(operate, index, mediaItemUri)
            })
          }
          .id(`mediaId${index}`)
          .onClick(() => {
            console.log("item.fileType："+item.fileType)
            if (item.fileType === FileType.VIDEO) {
              Logger.info(this.tag, `onClick,item.id=${item.uri}`)
              context.startAbility({
                bundleName: 'ohos.samples.videoplayer',
                abilityName: 'PlayAbility',
                deviceId: "",
                parameters: {
                  fileUri: item.uri
                }
              }, (error) => {
                Logger.info(this.tag, `error.code = ${error.code}`)
              }
              )
            }
          })
        }, (item: userFileManager.FileAsset) => JSON.stringify(item.displayName))
      }
      .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }
}