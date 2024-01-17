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

import window from '@ohos.window';
import common from '@ohos.app.ability.common';
import WindowManger from '../feature/WindowManger';
import { WindowEventId, WindowType } from "../util/WindowConst";
import Logger from '../util/Logger';

const windowAttribute: WindowType = {
  moveToWidth: 50, // 窗口移动X坐标
  moveToHeight: 250, // 窗口移动Y坐标
  setTouchable: true, // 窗口是否可触
  resetSizeWidth: 400, // 窗口宽
  resetSizeHeight: 300, // 窗口高
  setPrivacyMode: true, // 窗口是否为隐私模式
  setBrightness: 1 // 窗口亮度
};

interface Datastring {
  context: common.UIAbilityContext | null,
  launchWant: string | null,
  subWindow: window.WindowStage | null
}

@Component
export struct WindowComponent {
  @StorageLink("topHeight") topHeight: number = 0; // 窗口规避区域高
  @StorageLink("topWidth") topWidth: number = 0; // 窗口规避区域宽
  @Link videoSrc: Resource;

  build() {
    Column() {
      // 窗口顶部规避区域
      Row()
        .width(px2vp(this.topWidth))
        .height(px2vp(this.topHeight))
      // video视频
      VideoWindow({ videoSrc: $videoSrc })
    }
    .width('100%')
    .height('100%')
  }
}

@Component
struct VideoWindow {
  @State isPlaying: boolean = false;
  @Link videoSrc: Resource;
  @StorageLink('focusText') focusText: string = 'unknown';
  videoController: VideoController = new VideoController();
  private context: common.UIAbilityContext | null = null;
  private subWindow: window.WindowStage | null = null;
  private isPortrait: Boolean = true;
  private showSubWindow: Boolean = false;

  aboutToAppear() {
    this.context = getContext(this) as common.UIAbilityContext;
    let data: Datastring = {
      context: this.context,
      launchWant: ' ',
      subWindow: this.subWindow
    };
    this.context.eventHub.emit("createWindow", data);
    this.subWindow = data.subWindow;
  }

  build() {
    Column() {
      Column() {
        Video({
          src: this.videoSrc,
          currentProgressRate: PlaybackSpeed.Speed_Forward_1_00_X,
          controller: this.videoController
        })
          .id('mainVideo')
          .width(400)
          .height(250)
          .margin(5)
          .loop(false)
          .objectFit(ImageFit.Contain)
          .muted(false)
          .controls(true)
          .autoPlay(true)
          .onClick(async () => {
            Logger.info('onClick');
            if (this.showSubWindow) {
              this.videoController.start();
              let windows = await this.subWindow?.getSubWindow();
              if (windows !== undefined) {
                windows[0].destroyWindow();
                this.showSubWindow = false;
                WindowManger.destorySubWindowCallback();
              }
            } else {
              this.videoController.pause();
              WindowManger.initSubWindow(this.subWindow, windowAttribute);
              this.showSubWindow = true;
            }
            ;
          })
          .onStart(() => {
            this.isPlaying = true;
          })
          .onPause(() => {
            this.isPlaying = false;
          })

        Button($r("app.string.pages_textTwo"))
          .id('windowBtn')
          .onClick(() => {
            if (this.isPortrait) {
              this.videoController.requestFullscreen(true);
              WindowManger.changeWindowDirection(this.subWindow, window.Orientation.LANDSCAPE);
              this.isPortrait = false;
            } else {
              this.videoController.requestFullscreen(true);
              WindowManger.changeWindowDirection(this.subWindow, window.Orientation.PORTRAIT);
              this.isPortrait = true;
            }
            ;
          })
      }
      .height('75%')

      Column() {
        Text(this.focusText)
          .id('focus')
          .width(300)
          .height(150)
          .textAlign(TextAlign.Center)
          .fontSize(50)
          .fontColor(Color.Black)
      }
      .width(500)
      .height(300)
      .align(Alignment.Bottom)
    }
  }
}


