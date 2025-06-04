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

import image from '@ohos.multimedia.image';
import fileUri from '@ohos.file.fileuri';
import fs from '@ohos.file.fs';
import router from '@ohos.router';
import { common } from '@kit.AbilityKit';
import { promptAction } from '@kit.ArkUI';
// mp4parser 三方库组件
import { IFrameCallBack, ICallBack, MP4Parser } from '@ohos/mp4parser';
import CommonConstants from '../constants/Constants';

import { CustomSetServerDlg } from '../customcomponents/CustomSetServerDlg';
import { CustomLoadingProgressDlg } from '../customcomponents/CustomLoadingProgressDlg';
import { TimeUtils } from '../utils/TimeUtils';
import { logger } from '../utils/Logger';
import { getTimeStr, savePixelMap } from '../utils/FileUtil';
import { requestUpload } from '../uploadanddownload/RequestUpload';
import { urlUtils } from '../utils/UrlUtils';
import { VideoPlayListener } from '../videoplaycomponents/VideoPlayListener';
import { VideoTrimmerOption } from '../videotrimmer/VideoTrimmerOption';
import { VideoTrimListener } from '../videotrimmer/VideoTrimListener';
import { VideoLoadFramesListener } from '../videotrimmer/VideoLoadFramesListener';
import { VideoTrimmerView } from '../videotrimmer/VideoTrimmerView';
import { WorkItem } from '../model/WorkItemModel';

const TAG: string = 'videoTrimmer_upload';

@Entry
@Component
export struct VideoUpload {
  @State centerIndex: number = 0; // List显示区域内中间子组件索引值
  @State isTrimmer: boolean = false; // 是否处于剪辑状态
  private uploadTimesMax: number = 5; // 上传重试次数
  @State serverUrl: string = ''; // 服务器地址
  @State workItem: WorkItem = new WorkItem('1月3日', '15:40', '', '', '北高峰', true);
  @State mVideoPlayListener: VideoPlayListener = {
    onPrepared: () => {
    },
    onComplete() {
    },
    onPlayStatus: (isPlay: boolean) => {
    },
    onTimeUpdate(time: number) {
      this.currentTime = time;
    },
    onBitrateUpdate(bitrateList: number[]) {
    },
    onErrorUpdate(error: string) {
    },
  }
  @State mVideoTrimmerOption: VideoTrimmerOption = new VideoTrimmerOption();

  /**
   * 获取视频第一张图片
   */
  async getVideoFirstImage(videoSrc: string): Promise<void> {
    let callBack: ICallBack = {
      //  回调函数
      callBackResult: (code: number) => {
        if (code === 0) {
          let frameCallBack: IFrameCallBack = {
            callBackResult: async (data: ArrayBuffer, timeUs: number) => {
              const imageSource: image.ImageSource = image.createImageSource(data);

              let decodingOptions: image.DecodingOptions = {
                sampleSize: 1,
                editable: true,
                desiredSize: { width: CommonConstants.firstImageWidth, height: CommonConstants.firstImageHeight },
                desiredPixelFormat: image.PixelMapFormat.RGBA_8888
              };
              await imageSource.createPixelMap(decodingOptions).then(async (px: image.PixelMap) => {
                this.workItem.firstImage = px;
                imageSource.release();
              })
            }
          }
          let startTimeUs = CommonConstants.FIRST_IMAGE_START_TIME + '';
          let endTimeUs = CommonConstants.FIRST_IMAGE_END_TIME + '';
          // TODO: 知识点：传入起始时间，通过MP4Parser获取视频的首页图片
          MP4Parser.getFrameAtTimeRang(startTimeUs, endTimeUs, MP4Parser.OPTION_CLOSEST, frameCallBack);
        }
      }
    }
    // TODO: 知识点：设置MP4Parser视频源地址及回调函数
    MP4Parser.setDataSource(videoSrc, callBack);
  }

  // 配置服务器地址
  customSetServerDlg: CustomDialogController = new CustomDialogController({
    builder: CustomSetServerDlg({
      serverUrl: getContext(this)
        .resourceManager
        .getStringSync($r('app.string.video_trimmer_default_serverIP'))
    }),
    alignment: DialogAlignment.Center, // 自定义弹窗底端对齐
    autoCancel: true,
    cancel: this.onCancel, // 返回、ESC键和点击遮障层弹窗退出时回调
    customStyle: true, // 弹窗样式自定义
  })

  // 返回、ESC键和点击遮障层弹窗退出时回调
  onCancel(): void {
    this.customSetServerDlg.close();
  }

  // 校验是否配置服务器
  async checkServerAddress(): Promise<boolean> {
    // 获取服务器地址
    this.serverUrl = await urlUtils.getUrl(getContext(this) as common.UIAbilityContext);
    if (this.serverUrl === undefined || this.serverUrl === '') {
      await this.customSetServerDlg.open();
    }
    this.serverUrl = await urlUtils.getUrl(getContext(this) as common.UIAbilityContext);
    logger.info(TAG, 'serverUrl is = ' + this.serverUrl);
    if (this.serverUrl !== undefined && this.serverUrl.length > 1) {
      return true;
    } else {
      return false;
    }
  }

  //  保存首页背景图
  async saveFirstImage() {
    const url = await savePixelMap(getContext(this), this.workItem.firstImage as PixelMap, getTimeStr());
    this.workItem.firstImage = fileUri.getUriFromPath(url);
    this.workItem.date = TimeUtils.getCurrentTime();
    AppStorage.setOrCreate('addWorkItem', this.workItem);
    await this.customSetServerDlg.close();
    router.back();
  }

  // TODO: 知识点: 保存视频到服务器
  async uploadFiles(outVideoPath: string) {
    // 校验是否配置服务器
    if (!await this.checkServerAddress()) {
      logger.error(TAG, 'serverUrl is null. ');
      return;
    }

    let countdown: number = 0; // 重试计数
    let imageList: string[] = [];
    imageList.push(outVideoPath);
    await requestUpload.uploadFiles(imageList, (progress: number, isSucceed: boolean) => {
      progress = progress;
      if (progress === CommonConstants.PROGRESS_MAX && isSucceed) {
        logger.info(TAG, 'RequestUpload success. ');
        // 上传成功后删除裁剪的视频
        if (this.workItem.trimmerSrc !== '') {
          fs.unlinkSync(this.workItem.trimmerSrc);
        }
        // 视频地址替换为服务器上的视频
        this.workItem.videoSrc = this.serverUrl + this.workItem.videoSrc.split('/').pop();
        // 保存视频首页背景图
        this.saveFirstImage();
      }
      if (progress === CommonConstants.PROGRESS_MAX && isSucceed === false) {
        countdown = this.uploadTimesMax;
        let interval = setInterval(() => {
          if (countdown > 0) {
            countdown--;
          } else {
            clearInterval(interval);
          }
        }, CommonConstants.UPLOAD_INTERVAL_TIME);
        promptAction.showToast({ message: $r('app.string.video_trimmer_upload_fail') })
      }
    });
  }

  async aboutToAppear(): Promise<void> {
    const params = router.getParams() as Record<string, string>; // 获取传递过来的参数对象
    if (params) {
      this.workItem.videoSrc = params.value as string; // 获取参数value的值
      this.workItem.trimmerSrc = '';
      logger.info(TAG, 'the source video path is:' + this.workItem.videoSrc);
      // 获取视频第一张图片
      await this.getVideoFirstImage(this.workItem.videoSrc);
      // 视频剪辑参数选项
      let tempOption = new VideoTrimmerOption();
      tempOption.listener = this.initListener;
      tempOption.loadFrameListener = this.initLoadFrameListener;
      tempOption.srcFilePath = this.workItem.videoSrc;
      this.mVideoTrimmerOption = tempOption;
    }
  }

  async aboutToDisappear(): Promise<void> {
    fs.unlinkSync(this.mVideoTrimmerOption.srcFilePath);
    this.customSetServerDlg.close();
  }

  // 加载进度对话框
  dialogController: CustomDialogController = new CustomDialogController({
    builder: CustomLoadingProgressDlg({}),
    autoCancel: false,
    alignment: DialogAlignment.Center,
    offset: { dx: 0, dy: 0 },
    customStyle: false
  })
  // 视频剪辑回调接口接口
  initListener: VideoTrimListener = {
    onStartTrim: () => {
      logger.info(TAG, '开始裁剪');
      this.dialogController.open();
    },
    onFinishTrim: async (outVideoPath: string) => {
      this.dialogController.close();
      // 更新上传视频地址
      this.workItem.trimmerSrc = outVideoPath;
      await this.getVideoFirstImage(this.workItem.trimmerSrc);
      this.isTrimmer = false;
      logger.info(TAG, '裁剪成功 path=' + this.workItem.trimmerSrc)
    },
    onCancel: () => {
      logger.info(TAG, '用户取消');
      this.isTrimmer = false;
    }
  }
  // 视频帧加载回调接口
  initLoadFrameListener: VideoLoadFramesListener = {
    onStartLoad: () => {
      logger.info(TAG, '开始获取帧数据')
    },
    onFinishLoad: () => {
      logger.info(TAG, '获取帧数据结束')
    }
  }

  build() {
    Column() {
      if (!this.isTrimmer) {
        this.VideoUpdateInfo();
      } else {
        // TODO: 知识点: 视频剪辑组件VideoTrimmerView。 videoTrimmerOption：视频剪辑相关参数
        VideoTrimmerView({ videoTrimmerOption: this.mVideoTrimmerOption!! })
      }
    }
    .backgroundColor(Color.Black)
    .width($r('app.string.video_trimmer_full_size'))
    .height($r('app.string.video_trimmer_full_size'))
  }

  /**
   * 视频上传信息
   */
  @Builder
  VideoUpdateInfo() {
    Row() {
      // 左边取消按钮
      Text($r('app.string.video_trimmer_cancel'))
        .height($r('app.integer.video_trimmer_upload_info_height'))
        .fontColor(Color.White)
        .margin({
          left: $r('app.integer.video_trimmer_component_video_playing_image_margin_left')
        })
        .id('upload_cancel')
        .alignSelf(ItemAlign.Center)
        .onClick(() => {
          promptAction.showDialog({
            alignment: DialogAlignment.Center,
            isModal: false,
            message: $r('app.string.video_trimmer_cancel_confirm'),
            buttons: [
              {
                text: $r('app.string.video_trimmer_cancel'),
                color: $r('app.color.video_trimmer_cancel')
              },
              {
                text: $r('app.string.video_trimmer_ok'),
                color: $r('app.color.video_trimmer_confirm')
              }
            ]
          }, async (err, data) => {
            if (err) {
              logger.error(TAG, 'showDialog err: ' + err);
              return;
            }
            if (data.index === 1) {
              // 确认上传视频
              router.back();
            }
          });
        })
      Blank()
      // 右边保存按钮
      Text($r('app.string.video_trimmer_save'))
        .id('upload_save')
        .width($r('app.integer.video_trimmer_update_save_width'))
        .height($r('app.integer.video_trimmer_upload_info_height'))
        .fontColor(Color.White)
        .backgroundColor($r('app.color.video_trimmer_save_background'))
        .margin({
          right: $r('app.integer.video_trimmer_component_video_playing_image_margin_left')
        })
        .textAlign(TextAlign.Center)
        .borderRadius($r('app.integer.video_trimmer_share_borderRadius'))
        .onClick(async () => {
          this.workItem.date = TimeUtils.getCurrentTime();
          // 剪辑成功后上传剪辑的视频，否则上传原视频
          if (this.workItem.trimmerSrc != '') {
            this.uploadFiles(this.workItem.trimmerSrc);
          } else {
            this.uploadFiles(this.workItem.videoSrc);
          }
        })
    }
    .alignItems(VerticalAlign.Center)
    .height($r('app.integer.video_trimmer_upload_top_height'))
    .width($r('app.string.video_trimmer_full_size'))

    // 背景图
    Stack({ alignContent: Alignment.Center }) {
      Image(this.workItem.firstImage)
        .id('image_to_trimmer')
        .height($r('app.integer.video_trimmer_upload_video_height'))
        .onClick(() => {
          if (this.workItem.trimmerSrc !== '') {
            fs.unlinkSync(this.workItem.trimmerSrc);
            this.workItem.trimmerSrc = '';
          }
          this.isTrimmer = true;
        })
      // 播放按钮
      Image($r('app.media.video_trimmer_icon_pause'))
        .width($r('app.integer.video_trimmer_component_video_playing_image_width'))
        .height($r('app.integer.video_trimmer_component_video_playing_image_width'))
        .onClick(() => {
          this.isTrimmer = true;
        })
    }
    .margin({
      left: $r('app.integer.video_trimmer_upload_video_left_margin'),
      right: $r('app.integer.video_trimmer_upload_video_left_margin'),
      top: $r('app.integer.video_trimmer_upload_video_top_margin')
    })

    Row() {
      Text($r('app.string.video_trimmer_labels'))
        .id('txtLabels')
        .width($r('app.integer.video_trimmer_update_button_width'))
        .textAlign(TextAlign.Center)
        .fontColor(Color.White)
        .borderRadius($r('app.integer.video_trimmer_upload_label_radius'))
        .height($r('app.integer.video_trimmer_upload_info_height'))
        .backgroundColor($r('app.color.video_trimmer_label_color'))
      Text($r('app.string.video_trimmer_btn_label'))
        .width($r('app.integer.video_trimmer_update_button_width'))
        .textAlign(TextAlign.Center)
        .fontColor(Color.White)
        .margin({ left: $r('app.integer.video_trimmer_upload_label_margin') })
        .height($r('app.integer.video_trimmer_upload_info_height'))
        .borderRadius($r('app.integer.video_trimmer_upload_label_radius'))
        .backgroundColor(Color.Gray)
        .onClick(() => {
          promptAction.showToast({ message: $r('app.string.video_trimmer_toast_tips') });
        })
    }.height($r('app.integer.video_trimmer_upload_label_row_height'))
    .margin({
      left: $r('app.integer.video_trimmer_lazy_foreach_list_page_list_item_margin_bottom'),
      top: $r('app.integer.video_trimmer_upload_label_padding_top'),
    })
    .alignSelf(ItemAlign.Start)
    .align(Alignment.Start)

    Row() {
      Image($r('app.media.video_trimmer_address'))
        .backgroundColor(Color.Black)
        .width($r('app.integer.video_trimmer_update_icon_size'))
        .height($r('app.integer.video_trimmer_update_icon_size'))
      Text($r('app.string.video_trimmer_user_address'))
        .id('txtAddress')
        .padding({ left: $r('app.integer.video_trimmer_detail_ack_button_left_padding') })
        .fontColor(Color.White)
        .textAlign(TextAlign.Center)
        .onClick(() => {
          promptAction.showToast({ message: $r('app.string.video_trimmer_toast_tips') });
        })
    }
    .height($r('app.integer.video_trimmer_update_item_height'))
    .width($r('app.string.video_trimmer_full_size'))
    .padding({ left: $r('app.integer.video_trimmer_upload_detail_left_padding') })

    Row() {
      Image($r('app.media.video_trimmer_user_lock'))
        .width($r('app.integer.video_trimmer_update_icon_size'))
        .height($r('app.integer.video_trimmer_update_icon_size'))
        .backgroundColor(Color.Black)
      Text($r('app.string.video_trimmer_who_can_see'))
        .padding({ left: $r('app.integer.video_trimmer_detail_ack_button_left_padding') })
        .textAlign(TextAlign.Center)
        .fontColor(Color.White)
      Blank()
      Text($r('app.string.video_trimmer_all_user'))
        .id('txtUserCanView')
        .textAlign(TextAlign.Center)
        .fontColor(Color.White)
        .margin({ right: $r('app.integer.video_trimmer_detail_back_margin') })
        .align(Alignment.End)
        .onClick(() => {
          promptAction.showToast({ message: $r('app.string.video_trimmer_toast_tips') });
        })
    }
    .height($r('app.integer.video_trimmer_update_item_height'))
    .width($r('app.string.video_trimmer_full_size'))
    .padding({ left: $r('app.integer.video_trimmer_upload_detail_left_padding') })

    Row() {
      Image($r('app.media.video_trimmer_record_time'))
        .backgroundColor(Color.Black)
        .width($r('app.integer.video_trimmer_update_icon_size'))
        .height($r('app.integer.video_trimmer_update_icon_size'))
        .alignSelf(ItemAlign.Center)
        .align(Alignment.Center)
      Text($r('app.string.video_trimmer_record_time'))
        .padding({ left: $r('app.integer.video_trimmer_detail_ack_button_left_padding') })
        .textAlign(TextAlign.Center)
        .fontColor(Color.White)
      Blank()
      Text(TimeUtils.getCurrentTime() + ' >')
        .id('txtRecordTime')
        .margin({ right: $r('app.integer.video_trimmer_detail_back_margin') })
        .textAlign(TextAlign.Center)
        .fontColor(Color.White)
        .align(Alignment.End)
    }
    .height($r('app.integer.video_trimmer_update_item_height'))
    .width($r('app.string.video_trimmer_full_size'))
    .padding({ left: $r('app.integer.video_trimmer_upload_detail_left_padding') })
    .margin({ bottom: $r('app.integer.video_trimmer_upload_detail_bottom_margin') })
  }
}