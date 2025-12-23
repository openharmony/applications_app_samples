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

import { display, window } from '@kit.ArkUI';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { VideoPlayView } from '../view/VideoPlayView';
import { AVDataSource } from '../model/AVDataSource';
import { CommonConstants as Const } from '../common/CommonConstants';

const TAG = '[Index]';

@Entry
@Component
struct Index {
  @State curIndex: number = 0;
  @State firstFlag: boolean = true;
  @State isPageShow: boolean = false;
  @State foldStatus: number = 0;
  @Provide isFirstAVPlayer: boolean = true;
  private swiperController: SwiperController = new SwiperController();

  async aboutToAppear(): Promise<void> {
    try {
      let context = this.getUIContext().getHostContext()!;
      let windowClass = await window.getLastWindow(context);
      await windowClass.setWindowKeepScreenOn(true);
      display.on('foldStatusChange', (foldStatus: display.FoldStatus) => {
        this.foldStatus = foldStatus;
        hilog.info(0x0000, TAG, `FoldStatusChange:${this.foldStatus}.`);
      })
    } catch (error) {
      hilog.error(0x0000, TAG, `aboutToAppear catch error, code: ${error.code}, message: ${error.message}`);
      return;
    }
  }

  onPageHide(): void {
    hilog.info(0x0000, TAG, `onPageHide curIndex: ${this.curIndex}, isPageShow: ${this.isPageShow}.`);
    this.isPageShow = false;
  }

  onPageShow(): void {
    hilog.info(0x0000, TAG, `onPageShow curIndex: ${this.curIndex}, isPageShow: ${this.isPageShow}.`);
    this.isPageShow = true;
  }

  build() {
    // [Start swiper_controller]
    Swiper(this.swiperController) {
      // Key point: Use LazyForEach to create an independent SurfaceID in the VideoPlayView component. (The AVPlayer is created in the VideoPlayView and does not share the AVPlayer.)
      LazyForEach(new AVDataSource(Const.VIDEO_SOURCE), (item: string, index: number) => {
        VideoPlayView({
          curSource: item,
          curIndex: this.curIndex,
          index: index,
          firstFlag: this.firstFlag,
          isPageShow: this.isPageShow,
          foldStatus: this.foldStatus
        })
      }, (item: string, index: number) => JSON.stringify(item) + index)
    }
    // Key point: Set cachedCount to implement preloading.
    .cachedCount(this.firstFlag ? 0 : 2)
    .width('100%')
    .height('100%')
    .vertical(true)
    .loop(true)
    // Key point: Change the spring curve to Curve.Ease.
    .curve(Curve.Ease)
    .duration(300)
    .indicator(false)
    .backgroundColor(Color.Black)
    .onGestureSwipe((index: number, extraInfo: SwiperAnimationEvent) => {
      hilog.info(0x0000, TAG, `onGestureSwipe index: ${index}, extraInfo: ${extraInfo}.`);
    })
    .onAnimationStart((index: number, targetIndex: number, extraInfo: SwiperAnimationEvent) => {
      hilog.info(0x0000, TAG,
        `onAnimationStart index: ${index}, targetIndex: ${targetIndex}, extraInfo: ${extraInfo}.`);
      // Key point: The curIndex is updated at AnimationStart and the next video starts to be played.
      this.curIndex = targetIndex;
    })
    // [End swiper_controller]
    .onAnimationEnd((index: number, extraInfo: SwiperAnimationEvent) => {
      hilog.info(0x0000, TAG, `onAnimationEnd index: ${index}, extraInfo: ${extraInfo}.`);
    })
  }
}