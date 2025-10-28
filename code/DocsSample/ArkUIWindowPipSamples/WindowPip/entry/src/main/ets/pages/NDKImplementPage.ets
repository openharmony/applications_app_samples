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

// [Start ndk_implement_index_page]
// NDKImplementIndexPage.ets
// 画中画功能演示界面
import testNapi, {PiPConfig} from 'libentry.so';
import { PiPWindow } from '@kit.ArkUI';
import { AVPlayer } from '../model/NDKAVPlayer';
import { Logger } from '../util/LogUtil';

const TAG = 'PipMain';
export enum PiPControlGroup {
  VIDEO_PLAY_VIDEO_PREVIOUS_NEXT = 101,
  VIDEO_PLAY_FAST_FORWARD_BACKWARD = 102,
  VIDEO_CALL_MICROPHONE_SWITCH = 201,
  VIDEO_CALL_HANG_UP_BUTTON = 202,
  VIDEO_CALL_CAMERA_SWITCH = 203,
  VIDEO_CALL_MUTE_SWITCH = 204,
  VIDEO_MEETING_HANG_UP_BUTTON = 301,
  VIDEO_MEETING_CAMERA_SWITCH = 302,
  VIDEO_MEETING_MUTE_SWITCH = 303,
  VIDEO_MEETING_MICROPHONE_SWITCH = 304,
  VIDEO_LIVE_VIDEO_PLAY_PAUSE = 401,
  VIDEO_LIVE_MUTE_SWITCH = 402,
}

@Entry
@Component
struct NDKImplementIndexPage {
  @State message: string = 'Hello World';
  mXComponentController: XComponentController | null = new XComponentController();
  private controllerId: number = -1;
  private contentWidth: number = 1920;
  private contentHeight: number = 1080;
  private pipType: PiPWindow.PiPTemplateType = PiPWindow.PiPTemplateType.VIDEO_PLAY;
  private pipControlGroups: Array<PiPControlGroup> = [];
  player?: AVPlayer;
  surfaceId = '';

  changeSurface = (surfaceId: string) => {
    if(this.player) {
      this.player.setSurfaceId(surfaceId);
      return;
    }
    Logger.info(`[${TAG}] change surface failed`);
  }

  private onStateChange = (state: PiPWindow.PiPState) => {
    switch(state) {
      case PiPWindow.PiPState.ABOUT_TO_START:
        Logger.info(`[${TAG}] ABOUT_TO_START`);
        break;
      case PiPWindow.PiPState.STARTED:
        Logger.info(`[${TAG}] STARTED`);
        break;
      case PiPWindow.PiPState.ABOUT_TO_STOP:
        Logger.info(`[${TAG}] ABOUT_TO_STOP`);
        break;
      case PiPWindow.PiPState.STOPPED:
        if (this.mXComponentController) {
          this.changeSurface(this.mXComponentController?.getXComponentSurfaceId());
        }
        Logger.info(`[${TAG}] STOPPED`);
        break;
      case PiPWindow.PiPState.ABOUT_TO_RESTORE:
        this.changeSurface(this.surfaceId);
        Logger.info(`[${TAG}] ABOUT_TO_RESTORE`);
        break;
      case PiPWindow.PiPState.ERROR:
        Logger.info(`[${TAG}] ERROR`);
        break;
      default:
        break;
    }
  }


  build() {
    RelativeContainer() {
      Row({ space: 20 }) {

        Button('更换模板')
          .bindMenu([
            {
              value: '视频',
              action: () => {
                this.pipType = PiPWindow.PiPTemplateType.VIDEO_PLAY;
                this.pipControlGroups = [PiPControlGroup.VIDEO_PLAY_VIDEO_PREVIOUS_NEXT];
              }
            },
            {
              value: '通话',
              action: () => {
                this.pipType = PiPWindow.PiPTemplateType.VIDEO_CALL;
                this.pipControlGroups = [PiPControlGroup.VIDEO_CALL_HANG_UP_BUTTON,
                  PiPControlGroup.VIDEO_CALL_CAMERA_SWITCH, PiPControlGroup.VIDEO_CALL_MICROPHONE_SWITCH];
              }
            },
            {
              value: '会议',
              action: () => {
                this.pipType = PiPWindow.PiPTemplateType.VIDEO_MEETING;
                this.pipControlGroups = [PiPControlGroup.VIDEO_MEETING_MICROPHONE_SWITCH,
                  PiPControlGroup.VIDEO_MEETING_HANG_UP_BUTTON,
                  PiPControlGroup.VIDEO_MEETING_CAMERA_SWITCH];
              }
            },
            {
              value: '直播',
              action: () => {
                this.pipType = PiPWindow.PiPTemplateType.VIDEO_LIVE;
                this.pipControlGroups = [PiPControlGroup.VIDEO_LIVE_VIDEO_PLAY_PAUSE,
                  PiPControlGroup.VIDEO_LIVE_MUTE_SWITCH];
              }
            }
          ])
      }
      .size({ width: '100%', height: 60 })
      .backgroundColor('#DDDDDD')
      .justifyContent(FlexAlign.SpaceAround)
      .alignRules({
        top: { anchor: '__container__', align: VerticalAlign.Top },
        middle: { anchor: '__container__', align: HorizontalAlign.Center }
      })
      .id('pip_type_control')
      XComponent({
        type: XComponentType.SURFACE,
        controller: this.mXComponentController
      })
        .onLoad(() => {
          if (this.mXComponentController) {
            this.surfaceId = this.mXComponentController.getXComponentSurfaceId();
          }
          this.player = new AVPlayer(this.surfaceId, 1);
          this.player.avPlayerFdSrc();
        })
        .onDestroy(() => {
          Logger.info(`[${TAG}] XComponent onDestroy`);
        })
        .size({ width: '100%', height: '800px' })
        .margin({ top: 10 })
        .backgroundColor('#888888')
        .alignRules({
          bottom: { anchor: '__container__', align: VerticalAlign.Center },
          middle: { anchor: '__container__', align: HorizontalAlign.Center }
        })
        .id('x_component')
        .size({ width: '100%', height: '800px' })
      Row({ space: 0 }) {
        Button('创建画中画')
          .onClick(() => {
            let windowId: number | undefined = AppStorage.get('windowId');
            let config: PiPConfig = {
              mainWindowId: windowId as number,
              pipTemplateType: this.pipType,
              width: this.contentWidth,
              height: this.contentHeight,
              controlGroup: this.pipControlGroups
            }
            this.controllerId = testNapi.createPip(config);
            testNapi.registerStartPip(this.controllerId, this.changeSurface);
            testNapi.registerLifecycleListener(this.controllerId, this.onStateChange);
          })
        Button('开启画中画')
          .onClick(() => {
            testNapi.startPip(this.controllerId);
          })
      }
      .size({ width: '100%', height: 60 })
      .alignRules({
        top: { anchor: 'x_component', align: VerticalAlign.Bottom },
        left: { anchor: '__container__', align: HorizontalAlign.Start }
      })
      .id('pip_control')
      Row({ space: 0 }) {
        Button('关闭画中画')
          .onClick(() => {
            testNapi.stopPip(this.controllerId);
          })
        Button('删除控制器')
          .onClick(() => {
            testNapi.deletePip(this.controllerId);
          })
      }
      .size({ width: '100%', height: 60 })
      .alignRules({
        top: { anchor: 'pip_control', align: VerticalAlign.Bottom },
        left: { anchor: '__container__', align: HorizontalAlign.Start }
      })
    }
    .size({ width: '100%', height: '100%' })
  }
}
// [End ndk_implement_index_page]