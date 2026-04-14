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
 

import { inputEventClient } from '@kit.InputKit';
import { window as winApi } from '@kit.ArkUI';
import Log from '@ohos/common/src/main/ets/default/Log';
import { JSON } from '@kit.ArkTS';
import { KeyCode } from '@kit.InputKit';
import { common } from '@kit.AbilityKit';
import { display } from '@kit.ArkUI';
const TAG: string = 'FloatWindow';

interface Position {
  x: number,
  y: number
}

interface WindowSize {
  width: number,
  height: number
}

let moveX = 0
let moveY = 0

@Entry
@Component
struct Float {
  public floatWindow: winApi.Window | null = null;
  public canvasWindow: winApi.Window | null = null;
  @State isShowIndex: boolean = false
  @State isPaint: boolean = false
  @State showOpenBtn: boolean = true
  @State windowPosition: Position = { x: 100, y: 100 };
  @State windowSize: WindowSize = { width: 100, height: 100 };
  @State isExpanded: boolean = false;
  @State showUi: boolean = true
  @State displayScale:number = 1;
  // 标注是否打开的一个观察者变量
  @StorageProp('isCanvasOpenShowFlag') isCanvasOpenShowFlag: boolean = false;
  // 是否处于截图标志
  @StorageProp('isNoteCanvasPhotoCatFlag') isNoteCanvasPhotoCatFlag: boolean = false;
  private lastUpdateTime: number = 0;
  private updateInterval: number = 16;
  private buttonSize: number = 0.8;
  context = getContext() as common.UIAbilityContext
  private backKeyDown: inputEventClient.KeyEvent = {
    isPressed: true,
    keyCode: KeyCode.KEYCODE_BACK, // 应返回键
    keyDownDuration: 0,
    isIntercepted: false
  };
  private backKeyUp: inputEventClient.KeyEvent = {
    isPressed: false,
    keyCode: KeyCode.KEYCODE_BACK, // 应返回键
    keyDownDuration: 0,
    isIntercepted: false
  };
  private homeKeyDown: inputEventClient.KeyEvent = {
    isPressed: true,
    keyCode: KeyCode.KEYCODE_HOME, // HOME键
    keyDownDuration: 0,
    isIntercepted: false
  };
  private homeKeyUp: inputEventClient.KeyEvent = {
    isPressed: false,
    keyCode: KeyCode.KEYCODE_HOME, // HOME键
    keyDownDuration: 0,
    isIntercepted: false
  };
  private backTaskKeyDown: inputEventClient.KeyEvent = {
    isPressed: true,
    keyCode: KeyCode.KEYCODE_DAGGER_LONG_PRESS, // 后台任务键
    keyDownDuration: 0,
    isIntercepted: false
  };
  private backTaskKeyKeyLongUp: inputEventClient.KeyEvent = {
    isPressed: false,
    keyCode: KeyCode.KEYCODE_DAGGER_LONG_PRESS, // 后台任务键
    keyDownDuration: 0,
    isIntercepted: false
  };
  private noteModeKeyUp: inputEventClient.KeyEvent = {
    isPressed: true,
    keyCode: KeyCode.KEYCODE_1, // 标注键
    keyDownDuration: 0,
    isIntercepted: false
  };
  private noteModeKeyDown: inputEventClient.KeyEvent = {
    isPressed: false,
    keyCode: KeyCode.KEYCODE_1, // 标注键
    keyDownDuration: 0,
    isIntercepted: false
  };

  @Styles
  normalStyles(): void {
    .backgroundColor('rgba(94, 94, 102, 0.7)')
  }

  @Styles
  pressedStyles(): void {
    .backgroundColor('rgba(94, 94, 102, 0.9)')
  }

  build() {
    if (this.showUi) {
      Stack({ alignContent: Alignment.Center }) {
        Button({ type: ButtonType.Circle, stateEffect: false }) {
          Image($r('app.media.floating_button_new')).width('60%').height('60%')
        }
        .width(this.isExpanded?`${80*this.buttonSize/200* 100}%`:`${this.buttonSize * 100}%`)
        .height(this.isExpanded?`${80*this.buttonSize/200* 100}%`:`${this.buttonSize * 100}%`)
        .borderWidth('0.5%')
        .borderColor('rgba(255,255,255,0.2)')
        .visibility(this.isNoteCanvasPhotoCatFlag ? Visibility.Hidden : Visibility.Visible)
        .stateStyles({
          normal: this.normalStyles,
          pressed: this.pressedStyles,
        })
        .gesture(GestureGroup(GestureMode.Parallel,
          PanGesture({ fingers: 1, distance: 10 })
            .onActionStart((event: GestureEvent) => {

            })
            .onActionUpdate((event: GestureEvent) => {
              // 平移
              const fingerItem = event.fingerList[0]
              const distance = this.isExpanded
                ? 200 * 0.9 * this.displayScale/2 : 80 * this.displayScale * this.buttonSize/2
              Log.showInfo('平移事件', `${JSON.stringify(event)}`);
              // 设置移动边界。1、展开：不能移动出去。2、收起：要给展开预留空间
              moveX = vp2px(fingerItem?.displayX) - distance
              moveY = vp2px(fingerItem?.displayY) - distance
              const dis = display.getDefaultDisplaySync();
              if (vp2px(fingerItem?.displayX) < distance) {
                moveX = 15
              }
              if (vp2px(fingerItem?.displayY) < distance) {
                moveY = 15
              }
              if (dis.width - vp2px(fingerItem?.displayX) < distance) {
                moveX = dis.width - 2 * distance
              }
              if (dis.height - vp2px(fingerItem.displayY) < distance) {
                moveY = dis.height - 2 * distance
              }
              if (this.floatWindow) {
                this.floatWindow?.moveWindowTo(moveX, moveY)
              }

            })
            .onActionEnd((event: GestureEvent) => {

              this.windowPosition.x = moveX
              this.windowPosition.y = moveY

            }),
        ))
        .onClick(() => {
          Log.showInfo(TAG, '按下悬浮球')
          Log.showInfo(TAG, `this.isExpanded:${this.isExpanded}`)


          const dis = display.getDefaultDisplaySync();

          if (!this.isExpanded) {
            this.isExpanded = !this.isExpanded;
            const distance = this.isExpanded
              ? 200 * 0.9 * this.displayScale / 2
              : 80 * this.displayScale * this.buttonSize / 2
            this.windowPosition.x = this.windowPosition.x - 60*this.displayScale;
            this.windowPosition.y = this.windowPosition.y - 60*this.displayScale;
            this.windowSize = { width: 200*this.displayScale, height: 200*this.displayScale }; // 放大
            if (this.windowPosition.x < 15) {
              this.windowPosition.x = 15
            }
            if (this.windowPosition.y < 15) {
              this.windowPosition.y = 15
            }
            if (dis.width - this.windowPosition.x < 2 *distance) {
              this.windowPosition.x = dis.width - 2 * distance
            }
            if (dis.height - this.windowPosition.y < 2 *distance) {
              this.windowPosition.y = dis.height - 2 * distance
            }

            if (this.floatWindow) {
              this.showUi = false
              setTimeout(() => {
                this.floatWindow?.resize(this.windowSize.width, this.windowSize.height, (err, data) => {
                  if (err && err.code != 0) {
                    return;
                  }
                  this.floatWindow?.moveWindowTo(this.windowPosition.x, this.windowPosition.y, (err1, data1) => {
                    if (err1 && err1.code != 0) {
                      return;
                    }
                    Log.showInfo(TAG, '窗口位置和尺寸更新完成');

                    this.floatWindow?.hide()
                    this.showUi = true;
                  })
                })
              }, 100)
            }
          } else {
            this.isExpanded = !this.isExpanded;
            this.windowPosition.x = this.windowPosition.x + 60*this.displayScale;
            this.windowPosition.y = this.windowPosition.y + 60*this.displayScale;
            this.windowSize = { width: 80*this.displayScale, height: 80*this.displayScale }; // 缩小
            if (this.floatWindow) {
              this.showUi = false
              setTimeout(() => {
                this.floatWindow?.resize(this.windowSize.width, this.windowSize.height, (err, data) => {
                  if (err && err.code != 0) {
                    return;
                  }
                  this.floatWindow?.moveWindowTo(this.windowPosition.x, this.windowPosition.y, (err1, data1) => {
                    if (err1 && err1.code != 0) {
                      return;
                    }
                    this.floatWindow?.hide()
                    this.showUi = true
                    Log.showInfo(TAG, '窗口位置和尺寸更新完成');
                  })
                })
              }, 100)


            }
          }
        })

        Button({ type: ButtonType.Circle, stateEffect: false }) {
          Image($r('app.media.img_back_new')).width('50%').height('50%')
        }
        .width('25%')
        .height('25%')
        .borderWidth('0.5%')
        .borderColor('rgba(255,255,255,0.2)')
        .stateStyles({
          normal: this.normalStyles,
          pressed: this.pressedStyles,
        })
        .position({ x: '37.5%', y: '5%' })
        .visibility((this.isExpanded && !this.isNoteCanvasPhotoCatFlag) ? Visibility.Visible : Visibility.Hidden)
        .onClick(() => {
          Log.showInfo(TAG, '按下上一页')

          try {
            inputEventClient.injectEvent({ KeyEvent: this.backKeyDown });

            inputEventClient.injectEvent({ KeyEvent: this.backKeyUp });
            Log.showInfo(TAG, `Succeed to inject KeyEventback`);
          } catch (error) {
            Log.showError(TAG,
              `Failed to inject KeyEvent, error: ${JSON.stringify(error, [`code`, `message`])}`);
          }
        })


        Button({ type: ButtonType.Circle, stateEffect: false }) {
          Image($r('app.media.img_home_new')).width('50%').height('50%')
        }
        .width('25%')
        .height('25%')
        .borderWidth('0.5%')
        .borderColor('rgba(255,255,255,0.2)')
        .stateStyles({
          normal: this.normalStyles,
          pressed: this.pressedStyles,
        })
        .position({ x: '37.5%', y: '70%' })
        .visibility((this.isExpanded && !this.isNoteCanvasPhotoCatFlag) ? Visibility.Visible : Visibility.Hidden)
        .onClick(() => {
          Log.showInfo(TAG, '按下返回主页')
          try {
            console.log('Ttest', JSON.stringify(this.homeKeyDown))
            console.log('Ttest', JSON.stringify(this.homeKeyUp))

            inputEventClient.injectEvent({ KeyEvent: this.homeKeyDown });

            inputEventClient.injectEvent({ KeyEvent: this.homeKeyUp });
            Log.showInfo(TAG,
              `Succeed to inject KeyEventhome`);
          } catch (error) {
            Log.showError(TAG,
              `Failed to inject KeyEvent, error: ${JSON.stringify(error, [`code`, `message`])}`);
          }
        })

        Button({ type: ButtonType.Circle, stateEffect: false }) {
          Image($r('app.media.img_delete_tasks')).width('50%').height('50%')
        }
        .width('25%')
        .height('25%')
        .borderWidth('0.5%')
        .borderColor('rgba(255,255,255,0.2)')
        .stateStyles({
          normal: this.normalStyles,
          pressed: this.pressedStyles,
        })
        .position({ x: '5%', y: '37.5%' })

        .visibility((this.isExpanded && !this.isNoteCanvasPhotoCatFlag) ? Visibility.Visible : Visibility.Hidden)
        .onClick(() => {
          Log.showInfo(TAG, 'call Task Mission')
          try {
            inputEventClient.injectEvent({ KeyEvent: this.backTaskKeyDown });
            inputEventClient.injectEvent({ KeyEvent: this.backTaskKeyKeyLongUp });
            Log.showInfo(TAG, `Succeed to inject KeyCode.KEYCODE_BTN_9`);
          } catch (error) {
            Log.showError(TAG,
              `Failed to inject KeyEvent KeyCode.KEYCODE_BTN_9, error: ${JSON.stringify(error, [`code`, `message`])}`);
          }
        })


        Button({ type: ButtonType.Circle, stateEffect: false }) {
          Image($r('app.media.setting'))
            .width('50%').height('50%')
        }
        .width('25%')
        .height('25%')
        .borderWidth('0.5%')
        .borderColor('rgba(255,255,255,0.2)')
        .stateStyles({
          normal: this.normalStyles,
          pressed: this.pressedStyles,
        })
        .position({ x: '70%', y: '37.5%' })
        .visibility((this.isExpanded && !this.isNoteCanvasPhotoCatFlag) ? Visibility.Visible : Visibility.Hidden)
        .onClick(() => {
          this.context.startAbility({
            bundleName: 'com.ohos.settings',
            abilityName: 'com.ohos.settings.MainAbility'
          }).catch((e: string) => {
            Log.showInfo(TAG, `拉起设置失败 ${e}`)
          })

        })
      }
      .width('100%')
      .height('100%')
      .backgroundColor(Color.Transparent)
      .onAttach(() => {
        this.floatWindow?.show()
        console.log('onAttach')
      })
      .onDetach(() => {
        this.floatWindow?.show()
        console.log('onDetach')
      })

    }
  }

  aboutToAppear() {
    Log.showInfo(TAG, 'aboutToAppear');
    this.floatWindow = winApi.findWindow('SystemUi_FloatBall')
    let dis = display.getDefaultDisplaySync();
    this.displayScale = dis.width / 1920;
  };

  aboutToDisappear() {
    console.log('aboutToDisappear')
  };
}
