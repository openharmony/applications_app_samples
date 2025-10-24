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
@Entry
@ComponentV2
struct PreventIdentification {
  @Local progress: number = 496000;  // 初始进度，秒
  @Local total: number = 27490000;   // 总时长，秒
  @Local currentWidth: string = '100%';
  @Local currentHeight: string = '100%';
  private currentPosX: number = 0;
  private currentPosY: number = 0;
  private currentFullScreenState: boolean = true;
  private normalPlayTimer: number = -1;
  private isPlaying: boolean = true;
  private fastForwardTimer: number = -1;

  aboutToAppear(): void {
    // 启动一个周期性定时器每隔一秒刷新一次进度
    this.startNormalPlayTimer();
  };

  startNormalPlayTimer(): void {
    if (this.normalPlayTimer != -1) {
      this.stopNormalPlayTimer();
    };
    this.normalPlayTimer = setInterval(() => {
      this.progress = this.progress + 1000;
    }, 1000);
  };

  stopNormalPlayTimer(): void {
    if (this.normalPlayTimer == -1) {
      return;
    };
    clearInterval(this.normalPlayTimer);
    this.normalPlayTimer = -1;
  };

  startFastForwardTimer(): void {
    if (this.fastForwardTimer != -1) {
      this.stopFastForwardTimer();
    };
    this.fastForwardTimer = setInterval(() => {
      this.progress = this.progress + 100000;
    }, 100);
  };

  stopFastForwardTimer(): void {
    if (this.fastForwardTimer == -1) {
      return;
    };
    clearInterval(this.fastForwardTimer);
    this.fastForwardTimer = -1;
  };

  showMessage(message: string): void {
    this.getUIContext().getPromptAction().showToast({ message: message, alignment: Alignment.Center });
  };

  resetPosInfo(): void {
    this.currentPosX = 0;
    this.currentPosY = 0;
  };

  toggleFullScreenState(): void {
    this.currentFullScreenState = !this.currentFullScreenState;
    if (this.currentFullScreenState) {
      this.currentWidth = '100%';
      this.currentHeight = '100%';
    } else {
      this.currentWidth = '100%';
      this.currentHeight = '50%';
    };
    this.showMessage(this.currentFullScreenState ? '全屏播放' : '取消全屏播放');
  };

  togglePlayAndPause(): void {
    this.isPlaying = !this.isPlaying;
    if (!this.isPlaying) {
      this.stopNormalPlayTimer();
    } else {
      // 重新启动
      this.startNormalPlayTimer();
    };
    this.showMessage(this.isPlaying ? '暂停播放' : '继续播放');
  };

  doFastForward(start: boolean): void {
    if (!start) { // 停止快进，恢复正常播放
      this.stopFastForwardTimer();
      this.startNormalPlayTimer();
      this.showMessage('取消快进');
      return;
    };

    this.stopNormalPlayTimer();
    this.startFastForwardTimer();
    this.showMessage('开始快进');
  };

  updateBrightness(start: boolean, event: BaseGestureEvent): void {
    let newY = event.fingerList[0].localY;
    if (start) {
      this.currentPosY = newY;
      this.showMessage('开始调整 亮度');
      return;
    };
    let offsetY = newY - this.currentPosY;
    if (Math.abs(offsetY) > 10) {
      this.showMessage((offsetY > 0) ? '降低亮度' : '提高亮度')
      this.currentPosY = newY;
    };
  };

  updateProgress(start: boolean, event: BaseGestureEvent): void {
    let newX = event.fingerList[0].localX;
    if (start) {
      this.currentPosX = newX;
      this.showMessage('开始调整 进度');
      return;
    };
    let offsetX = newX - this.currentPosX;
    this.progress = Math.floor(this.progress + offsetX * 10000);
    this.currentPosX = newX;
  };

  build() {
    Stack({ alignContent: Alignment.Center }) {
      Column() {
        Column() {
          //  $r('app.string.Playback_progress') 需要替换为开发者所需的资源文件
          Text(`$r('app.string.Playback_progress')` + this.progress)
        }
        .width('100%').height('90%')
        Flex({ alignItems: ItemAlign.Center, justifyContent: FlexAlign.SpaceBetween }) {
          Slider({
            value: this.progress,
            min: 0,
            max: this.total,
            style: SliderStyle.OutSet
          })
            .onChange((value: number, mode: SliderChangeMode) => {
              this.progress = value;
            })
            .id('progress_layer')



            // [Start DisableGestureType]
            .onTouchTestDone((event, recognizers) => {
              for (let i = 0; i < recognizers.length; i++) {
                let recognizer = recognizers[i];
                // 根据类型禁用所有滑动手势
                if (recognizer.getType() == GestureControl.GestureType.PAN_GESTURE) {
                  recognizer.preventBegin();
                };
              };
            })
            //  [End DisableGestureType]

            // [Start ComponentDisabled]
            .onTouchTestDone((event, recognizers) => {
              for (let i = 0; i < recognizers.length; i++) {
                let recognizer = recognizers[i];
                // 禁用掉标识为myID的组件上的所有手势
                if (recognizer.getEventTargetInfo().getId() == 'myID') {
                  recognizer.preventBegin();
                };
              };
            })
            //  [End ComponentDisabled]

            // [Start BuiltInGestureDisable]
            .onTouchTestDone((event, recognizers) => {
              for (let i = 0; i < recognizers.length; i++) {
                let recognizer = recognizers[i];
                // 禁用掉所有系统内置的手势
                if (recognizer.isBuiltIn()) {
                  recognizer.preventBegin();
                };
              };
            })
            //  [End BuiltInGestureDisable]

            .margin({ left: 5 })
            .trackColor(Color.Red)
            .blockColor(Color.Yellow)
            .selectedColor(Color.Orange)
            .trackThickness(2)
            .flexShrink(1)
            .flexGrow(1)
        }
        .flexGrow(1)
        .flexShrink(1)
        .id('id_progress_view')
      }
    }
    .id('video_layer')
    .backgroundColor('#E0E0E0')
    .gesture(
      GestureGroup(GestureMode.Exclusive,
        PanGesture({ direction: PanDirection.Vertical, distance: 10 })
          .tag('pan_for_brightness_control')
          .onActionStart((event) => {
            this.updateBrightness(true, event);
          })
          .onActionUpdate((event) => {
            this.updateBrightness(false, event);
          }),
        PanGesture({ direction: PanDirection.Horizontal, distance: 10 })
          .tag('pan_for_play_progress_control')
          .onActionStart((event) => {
            this.updateProgress(true, event);
          })
          .onActionUpdate((event) => {
            this.updateProgress(false, event);
          }),

        LongPressGesture()
          .tag('long_press_for_fast_forward_control')
          .onAction(() => {
            this.doFastForward(true); // 开始快进
          })
          .onActionEnd(() => {
            this.doFastForward(false); // 停止快进
          })
          .onActionCancel(() => {
            this.doFastForward(false);
          }),

        TapGesture({ count: 2 })
          .tag('double_tap_on_video')
          .onAction(() => {
            this.toggleFullScreenState();
          }),

        TapGesture()
          .tag('single_tap_on_video')
          .onAction(() => {
            this.togglePlayAndPause();
          })
      )
    )
    .width(this.currentWidth)
    .height(this.currentHeight)
  };
}