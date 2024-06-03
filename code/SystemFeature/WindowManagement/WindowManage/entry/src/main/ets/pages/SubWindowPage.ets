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

import emitter from '@ohos.events.emitter';
import common from '@ohos.app.ability.common';
import { BusinessError } from '@ohos.base';
import Want from '@ohos.app.ability.Want';

@Entry
@Component
struct SubWindowPage {
  SUB_WINDOW_INNER_EVENT_ID: number = 1001;
  videoController: VideoController = new VideoController();

  async startNewAbility() {
    let context = getContext(this) as common.UIAbilityContext; // UIAbilityContext
    let want: Want = {
      bundleName: 'com.samples.windowratio',
      abilityName: 'MainAbility',
    };
    try {
      context.startAbility(want)
        .then((data) => {
          console.log('startAbility succeed');
        })
        .catch((error: BusinessError) => {
          console.log('startAbility failed, error.code: ' + JSON.stringify(error.code) +
            ' error.message: ' + JSON.stringify(error.message));
        });
    } catch (paramError) {
      console.log('error.code: ' + JSON.stringify(paramError.code) +
        ' error.message: ' + JSON.stringify(paramError.message));
    }
  }

  build() {
    Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
      Button($r("app.string.startNewAbility"))
        .onClick(async () => {
          await this.startNewAbility();
        })
        .backgroundColor('#007dff')
        .id('startAbility')
        .fontSize('22px')
        .width('80%')
        .height('40px')
        .borderRadius(15)

      Video({
        src: $rawfile('video.mp4'),
        currentProgressRate: PlaybackSpeed.Speed_Forward_1_00_X,
        controller: this.videoController
      })
        .id('smallVideo')
        .width(320)
        .layoutWeight(1)
        .loop(false)
        .muted(false)
        .controls(true)
        .autoPlay(true)
        .onTouch((event: TouchEvent | undefined) => {
          if (event !== undefined) {
            let eventData: emitter.EventData = {
              data: {
                x: event.touches[0].displayX,
                y: event.touches[0].displayY,
                type: event.type
              }
            };
            let innerEvent: emitter.InnerEvent = {
              eventId: this.SUB_WINDOW_INNER_EVENT_ID,
              priority: emitter.EventPriority.HIGH
            };
            emitter.emit(innerEvent, eventData);
          }
        })
    }
    .width('100%').height('100%')
  }
}