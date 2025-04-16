/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

/**
 * 分享组件
 */

import fs from '@ohos.file.fs';
import promptAction from '@ohos.promptAction';
import { buffer } from '@kit.ArkTS';
import { common } from '@kit.AbilityKit';
import { fileUri } from '@kit.CoreFileKit';
import { photoAccessHelper } from '@kit.MediaLibraryKit';

import { logger } from '../utils/Logger';
import { requestDownload } from '../uploadanddownload/RequestDownload';
import { ShareInfo } from '../model/ShareInfo';

const ROW_SPACE: number = 20;
const COLUMN_SPACE: number = 12;
const DURATION: number = 3000;
const DOWNLOAD_FINISH: number = 100;

const TAG: string = 'videoTrimmer_share';

@CustomDialog
export struct CustomShareDlg {
  private videoSrc: string = ''; // 视频地址
  @State isDownload: boolean = false; // 是否处于下载中
  private context = getContext(this) as common.UIAbilityContext;
  controller: CustomDialogController; // 自定义弹窗
  cancel: () => void = () => {
  };
  // 分享对象
  private sharePlant: ShareInfo[] = [
    {
      isDownloadType: false,
      image: $r('app.media.video_trimmer_app_logo1'),
      title: getContext(this)
        .resourceManager
        .getStringSync($r('app.string.video_trimmer_plats')),
      onClick: () => {
        this.onPlatClick();
      }
    },
    {
      isDownloadType: false,
      image: $r('app.media.video_trimmer_app_logo2'),
      title: getContext(this)
        .resourceManager
        .getStringSync($r('app.string.video_trimmer_spaces')),
      onClick: () => {
        this.onPlatClick();
      }
    },
    {
      isDownloadType: false,
      image: $r('app.media.video_trimmer_app_logo3'),
      title: getContext(this)
        .resourceManager
        .getStringSync($r('app.string.video_trimmer_myHome')),
      onClick: () => {
        this.onPlatClick();
      }
    },
    {
      isDownloadType: false,
      image: $r('app.media.video_trimmer_app_logo1'),
      title: getContext(this)
        .resourceManager
        .getStringSync($r('app.string.video_trimmer_garden')),
      onClick: () => {
        this.onPlatClick();
      }
    },
    {
      isDownloadType: false,
      image: $r('app.media.video_trimmer_app_logo2'),
      title: getContext(this)
        .resourceManager
        .getStringSync($r('app.string.video_trimmer_friends')),
      onClick: () => {
        this.onPlatClick();
      }
    }];
  // 操作对象
  private shareOperate: ShareInfo[] = [
    {
      isDownloadType: true, // 下载
      image: $r('app.media.video_trimmer_download'),
      title: getContext(this)
        .resourceManager
        .getStringSync($r('app.string.video_trimmer_download')),
      onClick: () => {
        this.onDownLoadClick();
      }
    },
    {
      isDownloadType: false,
      image: $r('app.media.video_trimmer_delete'),
      title: getContext(this)
        .resourceManager
        .getStringSync($r('app.string.video_trimmer_delete')),
      onClick: () => {
        this.onPlatClick();
      }
    }
  ];

  // 点击分享平台事件
  onPlatClick() {
    promptAction.showToast({ message: $r('app.string.video_trimmer_toast_tips') });
  };

  // 点击下载事件
  onDownLoadClick() {
    this.isDownload = true;
    requestDownload.downloadFile('', this.videoSrc, this.downloadFileCallback);
  };

  // 下载回调函数
  downloadFileCallback = (progress: number, isSuccess: boolean, localPath: string) => {
    logger.info(TAG, `downloadFileCallback = ${progress}, localPath = ${localPath}`);
    if (progress === DOWNLOAD_FINISH) {
      this.onDownloadFinish(isSuccess, localPath);
    }
  }

  /**
   * 下载完成后事件
   */
  onDownloadFinish(isSuccess: boolean, filePath: string) {
    logger.info(TAG, 'downloadFinish, localPath is：' + filePath);
    let srcFileUris: string[] = [
      this.context.cacheDir + filePath
    ];
    this.saveVideo(srcFileUris);
  }

  // TODO: 知识点: 保存视频文件到图库
  async saveVideo(srcFileUris: Array<string>) {
    logger.info(TAG, 'saveVideo, src is：' + srcFileUris[0]);
    let phAccessHelper = photoAccessHelper.getPhotoAccessHelper(this.context);
    try {
      let photoCreationConfigs: photoAccessHelper.PhotoCreationConfig[] = [
        {
          title: 'videoDoanload',
          fileNameExtension: 'mp4',
          photoType: photoAccessHelper.PhotoType.VIDEO,
          subtype: photoAccessHelper.PhotoSubtype.DEFAULT,
        }
      ];
      // TODO: 知识点: 拉起授予权限的弹窗，获取将视频保存到图库的权限
      let desFileUris: string[] = await phAccessHelper.showAssetsCreationDialog(srcFileUris, photoCreationConfigs);
      logger.info(TAG, 'saveVideo des is：' + desFileUris[0]);
      // 转换为uri
      let uri: string = fileUri.getUriFromPath(srcFileUris[0]);
      // 打开沙箱路径下视频
      const file: fs.File = fs.openSync(uri, fs.OpenMode.READ_WRITE);
      // 将沙箱视频内容写入buffer
      const videoSize: number = fs.statSync(file.fd).size;
      let arrayBuffer: ArrayBuffer = new ArrayBuffer(videoSize);
      let readLength: number = fs.readSync(file.fd, arrayBuffer);
      let videoBuffer: ArrayBuffer = buffer.from(arrayBuffer, 0, readLength).buffer;
      try {
        // 打开图库视频保存的路径
        let fileInAlbum = fs.openSync(desFileUris[0], fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
        // 写入图库
        await fs.write(fileInAlbum.fd, videoBuffer);
        // 关闭文件
        await fs.close(file.fd);
        await fs.close(fileInAlbum.fd);
        logger.info(TAG, 'saveVideo success');
        // 视频保存成功后，删掉沙箱路径下视频
        fs.unlinkSync(srcFileUris[0]);
        promptAction.showToast({
          message: $r('app.string.video_trimmer_save_success'),
          duration: DURATION
        });
        this.controller.close();
      } catch (error) {
        logger.error(TAG, `saveVideo failed, code is: ${error.code}, message is: ${error.message}`);
      }
    } catch (err) {
      logger.error(TAG, `showAssetsCreationDialog failed, errCode is: ${err.code}, message is: ${err.message}`);
    }
    this.isDownload = false;
  }

  // 自定义日历选取器内容
  build() {
    Column({ space: COLUMN_SPACE }) {
      Text($r('app.string.video_trimmer_share'))
        .fontColor(Color.White)
        .fontSize($r('app.integer.video_trimmer_component_video_loading_text_font_size'))
        .margin({
          top: $r('app.integer.video_trimmer_share_margin_10'),
          bottom: $r('app.integer.video_trimmer_share_margin_10')
        })
      Row({ space: ROW_SPACE }) {
        ForEach(this.sharePlant, (item: ShareInfo) => {
          Column() {
            Image(item.image)
              .width($r('app.integer.video_trimmer_share_image_width'))
              .borderRadius($r('app.integer.video_trimmer_share_borderRadius'))
            Text(item.title)
              .fontSize($r('app.integer.video_trimmer_video_item_news_performer_font_size'))
              .margin({ top: $r('app.float.video_trimmer_tab_title_margin') })
              .fontColor(Color.White)
          }
          .onClick(() => {
            if (item.onClick) {
              item.onClick();
            }
          })
        }, (item: ShareInfo) => item.title)
      }

      Row({ space: ROW_SPACE }) {
        ForEach(this.shareOperate, (item: ShareInfo) => {
          Column() {
            Image(item.image)
              .width($r('app.integer.video_trimmer_share_image_width'))
              .borderRadius($r('app.integer.video_trimmer_share_borderRadius'))
            Text((item.isDownloadType && this.isDownload) ? $r('app.string.video_trimmer_download_status') : item.title)
              .fontSize($r('app.integer.video_trimmer_video_item_news_performer_font_size'))
              .margin({ top: $r('app.float.video_trimmer_tab_title_margin') })
              .fontColor(Color.White)
          }
          .enabled(this.isDownload ? false : true)
          .onClick(() => {
            if (item.onClick) {
              item.onClick();
            }
          })
        }, (item: ShareInfo) => item.title)
      }
      .padding({
        left: $r('app.integer.video_trimmer_share_oprate_padding'),
        bottom: $r('app.integer.video_trimmer_share_margin_10')
      })
      .width($r('app.string.video_trimmer_full_size'))
      .justifyContent(FlexAlign.Start).alignItems(VerticalAlign.Top)
    }
    .margin({ bottom: $r('app.integer.video_trimmer_share_margin_bottom') })
    .backgroundColor($r('app.color.video_trimmer_list_detail_color'))
    .width($r('app.string.video_trimmer_full_size'))
  }
}