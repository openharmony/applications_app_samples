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

import { logger } from '../utils/Logger';

@Component
export struct VideoPage {
  @StorageLink('video_path') videoPath: string = '';
  @StorageLink('video_complete') videoComplete: boolean = false;
  @State controls: boolean = false;
  @State isFull: boolean = false;
  @State isPause: boolean = true;
  @State isPlayClick: boolean = true;
  @State firstClick: boolean = true;
  @State isHidden: boolean = true;
  @State previewImg: string = '';
  @State updateTime: number = 0;
  @Link isStart: boolean;
  private videoController: VideoController = new VideoController();

  aboutToAppear() {
    logger.info(`video_path: ${this.videoPath}`);
  }

  build() {
    Column() {
      Stack() {
        Video({
          src: this.videoPath,
          controller: this.videoController
        })
          .width('100%')
          .aspectRatio(1.12)
          .controls(this.controls)
          .objectFit(ImageFit.Contain)
          .backgroundColor(this.isHidden ? Color.White : Color.Black)
          .onUpdate((e) => {
            this.updateTime = e.time;
            AppStorage.SetOrCreate('updateTime', e.time);
          })
          .onPrepared((e) => {
            console.info('VideoPage_onPrepared:' + e.duration);
          })
          .onClick(() => {
            if (this.isPlayClick) { // 判断play按钮是否用过，没有用过，进入这层
              if (this.firstClick) { // 第一次点击视频开始播放，再次点击进入全屏
                this.videoController.start();
                this.isHidden = !this.isHidden;
                this.isStart = true;
                this.firstClick = !this.firstClick;
              } else {
                AppStorage.SetOrCreate('updateTime', this.updateTime);
              }
            } else {
              AppStorage.SetOrCreate('updateTime', this.updateTime);
            }
          })
          .onFinish(() => {
            this.isHidden = true;
            this.isStart = false;
          })

        // 空白层预览
        if (this.isHidden) {
          Column() {
            Image(this.previewImg)
              .objectFit(ImageFit.Contain)
          }
          .width('100%')
          .aspectRatio(1.12)
          .backgroundColor($r('app.color.white'))
        }

        // 视频上的play图标
        if (this.isHidden && this.videoComplete) {
          Column() {
            Image($r('app.media.play'))
              .width(76).height(76)
              .onClick(() => {
                this.videoController.start();
                this.isHidden = !this.isHidden;
                this.isStart = true;
                this.isPlayClick = false;
              })
          }
        }

        if (!this.videoComplete) {
          LoadingProgress()
            .width(80)
            .color(Color.White)
        }
      }
    }
    .width('100%')
  }
}