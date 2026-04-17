/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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
/* eslint-disable */
/* 8k 点播应用主页 */
import { router } from '@kit.ArkUI'
import { initInfo } from '@ohos/utilslibrary'
import { inputEventClient, KeyCode } from '@kit.InputKit';
import { VideoAVPlayerClass } from '../Model/AvPlayer';
import { promptAction } from '@kit.ArkUI';
import { connection } from '@kit.NetworkKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { PointerUtil } from '../utils/PointerUtil';
import { EventUtil } from '../utils/EventUtil';
import { common } from '@kit.AbilityKit';
import { Constants } from '../const/Constants';

let log = initInfo('index.ets');

export interface Vidio {
  id: string;
  text: string;
  bgImg: Resource;
  onclick: Function
}


@Entry
@Component
struct Index {
  @State focusId: number = 0;
  @State playerType: string = '0';
  @StorageLink('screen_lpx_w') screenW: number = AppStorage.get<number>('screen_lpx_w') || 1280;
  @StorageLink('screen_lpx_h') screenH: number = AppStorage.get<number>('screen_lpx_h') || 720;
  @State orientation: number = globalThis.orientation;
  @State buts: Array<Vidio> = [
    {
      id: 'id_1',
      text: '网络视频',
      bgImg: $rawfile('ic_net_dianbo.svg'),
      onclick: () => {
        if (!this.judgeHasNet()) {
          promptAction.showToast({
            message: $r('app.string.connection_error')
          })
          return;
        }
        router.pushUrl({
          url: 'pages/HttpVideoList'
        })
      }
    },
    {
      id: 'id_2',
      text: '本地视频',
      bgImg: $rawfile('ic_local_dianbo.svg'),
      onclick: () => {
        router.pushUrl({
          url: 'pages/LocalFolderList'
        })
      }
    }
  ]

  aboutToAppear() {
    this.orientation = globalThis.orientation;
    this.tabStartClick()
    this.getUIContext().getFocusController().activate(true, false)
  }


  judgeHasNet(): boolean {
    try {
      let netHandle = connection.getDefaultNetSync();
      if (!netHandle || netHandle.netId === 0) {
        log('JudgeHasNet invalid netHandle');
        return false;
      }
      let netCapability = connection.getNetCapabilitiesSync(netHandle);
      let cap = netCapability.networkCap || [];
      if (cap.includes(connection.NetCap.NET_CAPABILITY_VALIDATED)) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      let err = e as BusinessError;
      log('JudgeHasNet e:' + JSON.stringify(err));
    }
    return false;
  }

  tabStartClick() {
    let keyDown: inputEventClient.KeyEvent = {
      isPressed: true,
      keyCode: KeyCode.KEYCODE_TAB,
      keyDownDuration: 0,
      isIntercepted: false
    };
    let keyUp: inputEventClient.KeyEvent = {
      isPressed: false,
      keyCode: KeyCode.KEYCODE_TAB,
      keyDownDuration: 0,
      isIntercepted: false
    };

    try {
      // 触发tab点击，使默认焦点组件多态样式生效
      inputEventClient.injectEvent({ KeyEvent: keyDown });
      inputEventClient.injectEvent({ KeyEvent: keyUp });
    } catch (e) {
      console.log('tab key event click false')
    }
  }

  onBackPress(): boolean | void {
    let avplayer = AppStorage.get('avPlayer') as VideoAVPlayerClass
    avplayer?.avPlayer?.release();
    (getContext(this) as common.UIAbilityContext).terminateSelf()
    return true;
  }

  aboutToDisappear() {
      this.getUIContext().getFocusController().activate(false)
  }

  onPageShow() {
  }

  build() {
    Column() {
      Text('视频播放器')
        .fontSize('40lpx')
        .fontWeight(FontWeight.Medium)
        .width('100%')
        .height('100lpx')
        .fontColor('rgba(255,255,255,0.9)')
        .padding({ left: '30lpx', bottom: '10lpx' })
        .margin({
          top: '10lpx',
          left: '20lpx'
        })

      Row({ space: '50lpx' }) {
        ForEach(this.buts, (item: Vidio, ind) => {
          Column() {
            Row() {
              Stack({ alignContent: Alignment.Center }) {
                Image(item.bgImg)
                  .borderRadius(globalThis.lpiPx(18))
                  .width('286lpx')
                  .height('156lpx')
                  .objectFit(ImageFit.Cover)
                  .clip(true)
                Text(item.text)
                  .width('300lpx')
                  .height('30lpx')
                  .fontSize('24lpx')
                  .textAlign(TextAlign.Start)
                  .fontWeight(FontWeight.Medium)
                  .fontColor('#FFFFFF')
                  .position({
                    x: '24lpx',
                    y: '24lpx'
                  })
                Text('')
                  .width('100%')
                  .height('100%')
                  .focusable(true)
                  .focusOnTouch(true)
                  .defaultFocus(ind === this.focusId)
                  .key(`${ind}`)
                  .id(`${ind}`)
                  .onFocus(() => {
                    log(`onFocus focusId:${ind}`);
                    this.focusId = ind;
                  })
                  .onKeyEvent((e) => {
                    let len = this.buts.length;

                    if (e.keyCode == KeyCode.KEYCODE_ENTER && e.type == KeyType.Up) {
                      this.buts[this.focusId].onclick();
                    }
                    if (e.keyCode == KeyCode.KEYCODE_DPAD_LEFT && e.type == KeyType.Up) {
                      if (this.focusId > 0) {
                        this.focusId--;
                      }
                    }

                    if (e.keyCode == KeyCode.KEYCODE_DPAD_RIGHT && e.type == KeyType.Up) {
                      if (this.focusId < len - 1) {
                        this.focusId++;
                      }
                    }
                    AppStorage.setOrCreate('currentClick', this.focusId)
                  })
                  .onHover(() => {
                    this.focusId = ind;
                  })
                  .onClick(() => {
                    item.onclick();
                  })
                  .zIndex(2)
              }
              .width('300lpx')
              .height('170lpx')
              .borderWidth('2lpx')
              .borderRadius(globalThis.lpiPx(22))
              .borderStyle(BorderStyle.Solid)
              .borderColor(ind == this.focusId ? '#ffffffff' : '#004f5a65')
            }
            .stateStyles({
              focused: {
                .border({
                  color: Color.Transparent
                })
              }
            })
            .height('170lpx')
            .alignItems(VerticalAlign.Center)
            .justifyContent(FlexAlign.Center)
          }
        })
      }.width('100%')
      .margin({ left: '80lpx' })
    }
    .backgroundColor('#18181A')
    .width('100%')
    .height('100%')
    .focusable(true)
    .onKeyEvent((e) => {
      if (e.keyCode == KeyCode.KEYCODE_F24) {
        return;
      }
      log(`keyCode:${e.keyCode}, keyType:${e.type}`);
    })
    .onTouch((event) => {
      if (event.sourceTool !== SourceTool.Pen && event.sourceTool !== Constants.SOURCE_TOOL_MOUSE_CLICK) {
        return;
      }
      PointerUtil.changePointStyle(event.type == TouchType.Down);
    })
  }
}