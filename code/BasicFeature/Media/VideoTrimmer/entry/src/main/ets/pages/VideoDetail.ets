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

import router from '@ohos.router';
import CommonConstants from '../constants/Constants';
import { CustomShareDlg } from '../customcomponents/CustomShareDlg';
import { logger } from '../utils/Logger';
import { TimeUtils } from '../utils/TimeUtils';
import { VideoPlayListener } from '../videoplaycomponents/VideoPlayListener';
import { VideoPlayController } from '../videoplaycomponents/VideoPlayController';
import { WorkItem } from '../model/WorkItemModel';
import { XComponentVideo } from '../videoplaycomponents/XComponentVideo';

const TAG: string = 'videoTrimmer_Detail';
const DETAIL_OPACITY: number = 0.6; // 搜索框透明度

@Entry
@Component
export struct VideoDetail {
  @State centerIndex: number = 0; // List显示区域内中间子组件索引值
  @State workItem: WorkItem = new WorkItem('', '', '', '', ''); // 一条作品信息
  @State isPlaying: boolean = true; // 是否播放状态
  @State currentTime: number = 0; // 当前播放时间
  @State totalDuration: number = 0; // 视频总时长
  private videoPlayController: VideoPlayController = new VideoPlayController(); // 视频播放控制接口
  // 视频播放回调接口
  @State mVideoPlayListener: VideoPlayListener = {
    onPrepared: (duration: number) => {
      this.totalDuration = duration;
    },
    onPlayStatus: (isPlay: boolean) => {
      logger.info(TAG, 'onPlayStatus isPlat = ' + isPlay);
      this.isPlaying = isPlay;
    },
    onComplete() {
    },
    onTimeUpdate: (time: number) => {
      this.currentTime = time;
    },
    onBitrateUpdate(bitrateList: number[]) {
    },
    onErrorUpdate(error: string) {
    },
  }
  // 自定义弹窗实现分享、下载功能
  customShareDlg: CustomDialogController = new CustomDialogController({
    builder: CustomShareDlg({
      videoSrc: this.workItem.videoSrc
    }),
    autoCancel: true,
    cancel: this.onCancel, // 返回、ESC键和点击遮障层弹窗退出时回调
    alignment: DialogAlignment.Bottom, // 自定义弹窗底端对齐
    customStyle: true, // 弹窗样式自定义
  })

  // 返回、ESC键和点击遮障层弹窗退出时回调
  onCancel(): void {
    this.customShareDlg.close();
  }

  aboutToAppear(): void {
    const params = router.getParams() as Record<string, string>; // 获取传递过来的参数对象
    if (params) {
      // 获取播放地址
      this.workItem.videoSrc = params.value as string; // 获取参数value的值
    }
  }

  async aboutToDisappear(): Promise<void> {
    this.customShareDlg.close();
  }

  build() {
    RelativeContainer() {
      // 视频播放区域
      Row() {
        // 视频播放组件
        XComponentVideo({
          centerIndex: this.centerIndex,
          work: this.workItem,
          index: 0,
          videoPlayController: this.videoPlayController,
          videoPlayListener: this.mVideoPlayListener
        })
      }
      .width($r('app.string.video_trimmer_full_size'))
      .height($r('app.string.video_trimmer_full_size'))
      .justifyContent(FlexAlign.Center)
      .alignItems(VerticalAlign.Center)
      .backgroundColor(Color.Black)
      .alignRules({
        top: { anchor: '__container__', align: VerticalAlign.Top },
        left: { anchor: '__container__', align: HorizontalAlign.Start }
      })

      // 左边返回按钮
      Image($r('app.media.video_trimmer_back'))
        .id('image_video_back')
        .width($r('app.integer.video_trimmer_detail_back_width'))
        .height($r('app.integer.video_trimmer_detail_back_height'))
        .alignRules({
          top: { anchor: '__container__', align: VerticalAlign.Top },
          left: { anchor: '__container__', align: HorizontalAlign.Start }
        })
        .padding({
          left: $r('app.integer.video_trimmer_detail_ack_button_left_padding'),
          top: $r('app.integer.video_trimmer_detail_ack_button_top_padding'),
          bottom: $r('app.integer.video_trimmer_detail_ack_button_top_padding'),
        })
        .margin({
          left: $r('app.integer.video_trimmer_detail_back_margin')
        })
        .onClick(() => {
          router.back();
        })
      // 右边更多按钮
      Image($r('app.media.video_trimmer_more'))
        .id('image_video_more')
        .backgroundColor(Color.Black)
        .width($r('app.integer.video_trimmer_detail_back_width'))
        .height($r('app.integer.video_trimmer_detail_back_height'))
        .alignRules({
          top: { anchor: '__container__', align: VerticalAlign.Top },
          right: { anchor: '__container__', align: HorizontalAlign.End }
        })
        .padding({
          right: $r('app.integer.video_trimmer_detail_ack_button_left_padding'),
          top: $r('app.integer.video_trimmer_detail_ack_button_top_padding'),
          bottom: $r('app.integer.video_trimmer_detail_ack_button_top_padding'),
        })
        .margin({
          right: $r('app.integer.video_trimmer_detail_back_margin')
        })
        .onClick(() => {
          this.customShareDlg.open();
        })

      Row() {
        // 播放按钮
        Image(this.isPlaying ? $r('app.media.video_trimmer_icon_play') :
        $r('app.media.video_trimmer_icon_pause'))
          .width($r('app.integer.video_trimmer_component_video_playing_image_width'))
          .height($r('app.integer.video_trimmer_component_video_playing_image_width'))
          .margin({
            left: $r('app.integer.video_trimmer_detail_ack_button_left_padding'),
            right: $r('app.integer.video_trimmer_detail_ack_button_left_padding'),
          })
          .onClick(() => {
            if (this.isPlaying) {
              this.videoPlayController.pause();
            } else {
              this.videoPlayController.play();
            }
          })

        // 播放进度条
        Row() {
          // 当前时间
          Text(TimeUtils.getTimeString(this.currentTime))
            .fontSize($r('app.integer.video_trimmer_component_video_loading_text_font_size'))
            .fontColor(Color.White)
            .opacity(DETAIL_OPACITY)

          Slider({
            value: Math.round(this.currentTime / this.totalDuration * CommonConstants.PROGRESS_MAX)
          })
            .selectedColor(Color.White)
            .layoutWeight(1)
            .trackColor(Color.Gray)
            .onChange((value: number) => {
              this.currentTime = this.totalDuration * value / CommonConstants.PROGRESS_MAX;
              this.videoPlayController.seek(this.currentTime);
            })

          // 视频总时长
          Text(TimeUtils.getTimeString(this.totalDuration))
            .fontSize($r('app.integer.video_trimmer_component_video_loading_text_font_size'))
            .fontColor(Color.White)
            .opacity(DETAIL_OPACITY)
        }
        .layoutWeight(1)
        .height($r('app.integer.video_trimmer_detail_video_loading_height'))
      }.alignRules({
        bottom: { anchor: '__container__', align: VerticalAlign.Bottom },
        left: { anchor: '__container__', align: HorizontalAlign.Start }
      })
      .offset({
        y: $r('app.integer.video_trimmer_detail_video_loading_offset')
      })
      .width($r('app.string.video_trimmer_full_size'))
      .padding({
        left: $r('app.integer.video_trimmer_detail_video_loading_padding'),
        right: $r('app.integer.video_trimmer_detail_video_loading_padding'),
      })
    }
    .width($r('app.string.video_trimmer_full_size'))
    .height($r('app.string.video_trimmer_full_size'))
  }
}
