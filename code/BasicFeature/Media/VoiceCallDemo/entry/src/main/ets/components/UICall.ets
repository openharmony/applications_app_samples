/*
 * Copyright (c) 2023 Hunan OpenValley Digital Industry Development Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *  http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import Caller from '../bean/Caller';
import IndexController from '../controller/IndexController';
import ComponentVoiceBg from '../components/ComponentVoiceBg';
import ComponentOption from '../components/ComponentOption';

/**
 * 被呼叫页
 * 提示语不同，头像相同
 * 按钮group： mic操作按钮，挂断，扬声器操作按钮
 */
@Component
export default struct UICall {
  private controller: IndexController | null = null;
  @Link mRemote: Caller;
  @State use: boolean = true;
  @State useMic: boolean = true;
  @State useSpeaker: boolean = false;
  private tips: string | Resource = "";

  async changeMic(open: boolean): Promise<void> {
    if (this.controller == null) {
      return;
    }
    this.controller.setMicrophoneMute(!open);
  }

  async changeSpeaker(use: boolean): Promise<void> {
    if (this.controller == null) {
      return;
    }
    this.controller.setSpeaker(use);
  }

  aboutToAppear() {
    if (this.controller == null) {
      return;
    }
    this.controller.isSpeakerActive().then(result => {
      this.useSpeaker = result;
    });

    this.controller.isMicrophoneMute().then(result => {
      this.useMic = !result;
    });

    this.tips = $r('app.string.tips_call');
  }

  build() {
    Column() {
      ComponentVoiceBg({ showTimer: false, tips: this.tips, mPerson: $mRemote }) {
        Row() {
          //麦克风
          ComponentOption({
            use: $useMic,
            useResource: $r('app.media.icon_openvalley_mic'),
            unUseResource: $r('app.media.icon_openvalley_mic_white'),
            canChange: () => {
              return true;
            },
            callback: (use: boolean) => {
              this.changeMic(use);
            }
          })
          //挂断
          ComponentOption({
            use: $use,
            useBgColorResource: $r('app.color.color_red'),
            useResource: $r('app.media.icon_openvalley_hangup'),
            unUseResource: $r('app.media.icon_openvalley_hangup'),
            canChange: () => {
              return false;
            },
            callback: (use: boolean) => {
              if (this.controller == null) {
                return;
              }
              this.controller.hangUp();
            }
          })
          //扬声器
          ComponentOption({
            use: $useSpeaker,
            useResource: $r('app.media.icon_openvalley_speaker'),
            unUseResource: $r('app.media.icon_openvalley_speaker_white'),
            canChange: () => {
              return true;
            },
            callback: (use: boolean) => {
              this.changeSpeaker(use);
            }
          })
        }
        .justifyContent(FlexAlign.SpaceEvenly)
        .width('100%')
      }
    }
    .width('100%')
    .height('100%')
  }
}