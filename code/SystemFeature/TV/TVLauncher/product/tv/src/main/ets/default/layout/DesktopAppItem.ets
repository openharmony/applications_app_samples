/**
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

import { launcherAbilityManager, Log } from '@ohos/common';
import { AppItemInfo } from '../../common/bean/AppItemInfo';
import { KeyCode } from '../../common/constants/KeyCode';
import iEventPublisher from '../model/EventPublisher';
import { emitter } from '@kit.BasicServicesKit';
import { PointerUtil } from '../../common/utils/PointerUtil';
import { EventUtil } from '../../common/utils/EventUtil';
import { LengthMetrics } from '@kit.ArkUI';
import { display } from '@kit.ArkUI';

const TAG = 'DesktopAppItem';
const SOURCE_TOOL_SEVEN = 7;
const SWIPE_THRESHOLD: number = 15;

@Component
export default struct DesktopAppItem {
  startDis: number = 0
  endDis: number = 10
  @ObjectLink app: AppItemInfo;
  private idx: number = 0;
  @Watch('watchIsEdit')
  @Link isEdit: boolean
  private scroller: Scroller = new Scroller();
  @Link focusIdx: number
  @Link focusNumber: number
  @State arrowRightXPos: number = 0
  @State arrowLeftXPos: number = 0
  @State duration: number = 1000
  @State removeShortCutsFocusAble: boolean = false; // ???????????????? ?????????button??????
  @State removeShortCutsFocused: boolean = false; // ????????????????
  @State removeShortCutsVisibleInEdit: boolean = false; // ?????????????????? ????
  @State lastIds:string ='1'
  @State isMouseMovedOut: boolean = false;
  @State pressX: number = 0;
  @Link itemEnable:boolean;
  @State itemWidth: number = 310;  // ???????
  @State fontSize: string = '36lpx';  // ???????
  @State buttonHeight: string = '80lpx';  // ???????
  @State buttonWidth: string = '450lpx';  // ???????
  @State iconSize: string = '80lpx';  // ???????
  @State focusedContainerWidth: string = '266lpx';  // ????????
  @State normalContainerWidth: string = '248lpx';  // ?????????
  @State focusedContainerHeight: string = '158lpx';  // ????????
  @State normalContainerHeight: string = '140lpx';  // ?????????
  @State mainContainerWidth: string = '286lpx';  // ??????
  @State mainContainerHeight: string = '178lpx';  // ??????
  @State textFontSizeFocused: string = '40lpx';  // ??????????
  @State textFontSizeNormal: string = '36lpx';  // ???????????
  @State buttonMarginLeft: string = '-155lpx';  // ??????
  @State arrowContainerWidth: string = '350lpx';  // ??????
  @State textMarginTop: string = '36lpx';  // ??????????
  @State textMarginTopNormal: string = '24lpx';  // ??????????
  @State focusBoxStrokeWidth: number = 6;  // ????????
  @State focusBoxMargin: number = 20;  // ??????
  @State touchStartX: number = 0;          // ???X??
  @State touchStartY: number = 0;          // ???Y??
  @State isSwiping: boolean = false;       // ??????
  repeatTime: number = -1
  isMoving: boolean = false
  moveToLeft: () => void = () => {
  }
  moveToRight: () => void = () => {
  }
  pressBack: () => void = () => {
  }

  aboutToAppear(): void {
    console.log(TAG, `aboutToAppear ${this.app.appName + '_' + this.idx}`);
    PointerUtil.changePointStyle(false)

    try {
      // ?????????
      this.itemWidth = AppStorage.get('iconWidth') as number || 310;
      // ??????????????
      let dis = display.getDefaultDisplaySync()

      if (dis.width >= 3840) { // 4K????
        console.log(TAG, '4K????');
        this.fontSize = '42lpx'; // 4K????????1.17??
        this.buttonHeight = '94lpx';
        this.buttonWidth = '280lpx'; // 4K??????????????
        this.iconSize = '110lpx'; // 4K??????????35lpx????10lpx
        this.focusedContainerWidth = '280lpx'; // 4K??????????????????
        this.normalContainerWidth = '260lpx'; // 4K??????????
        this.focusedContainerHeight = '170lpx'; // 4K????????
        this.normalContainerHeight = '150lpx'; // 4K??????????
        this.mainContainerWidth = '300lpx'; // 4K??????????ListItem??800lpx
        this.mainContainerHeight = '190lpx'; // 4K??????
        this.textFontSizeFocused = '46lpx'; // 4K??????????????.15??
        this.textFontSizeNormal = '42lpx';
        this.buttonMarginLeft = '-100lpx'; // 4K???????????????
        this.arrowContainerWidth = '364lpx'; // 4K????????????????
        this.textMarginTop = '5lpx';
        this.textMarginTopNormal = '2lpx';
        this.focusBoxStrokeWidth = 8; // 4K??????????
        this.focusBoxMargin = 30; // 4K????????
      } else { // 1080P????
        console.log(TAG, '2K????');
        this.fontSize = '36lpx';
        this.buttonHeight = '80lpx';
        this.buttonWidth = '450lpx';
        this.iconSize = '80lpx';
        this.focusedContainerWidth = '266lpx';
        this.normalContainerWidth = '248lpx';
        this.focusedContainerHeight = '158lpx';
        this.normalContainerHeight = '140lpx';
        this.mainContainerWidth = '286lpx';
        this.mainContainerHeight = '178lpx';
        this.textFontSizeFocused = '40lpx';
        this.textFontSizeNormal = '36lpx';
        this.buttonMarginLeft = '-155lpx';
        this.arrowContainerWidth = '350lpx';
        this.textMarginTop = '36lpx';
        this.textMarginTopNormal = '24lpx';
        this.focusBoxStrokeWidth = 6;
        this.focusBoxMargin = 20;
      }
    } catch (error) {
      console.error(TAG, `aboutToAppear error: ${error.message}`);
    }
  }

  watchIsEdit() {
    if (this.isEdit && this.app.isFocus) {
      this.removeShortCutsVisibleInEdit = true;
    } else {
      this.removeShortCutsVisibleInEdit = false;
    }
  }

  isShowArrow(index: number, isLeft: boolean): boolean {
    if (this.isEdit && this.app.isFocus) {
      if (isLeft) {
        if (index === 2) { // ?????????app????????????  ??????????
          return false
        }
        return true
      } else {
        if (index === globalThis.appListLength - 1) {
          return false
        }
        return true
      }
    }
    return false
  }

  build() {
    Stack({ alignContent: Alignment.Center }) {
      Column() {
        Button('??????', { type: ButtonType.Normal, stateEffect: true })
          .fontColor(this.removeShortCutsFocused ? 0x666666 : 0xffffff)
          .backgroundColor(this.removeShortCutsFocused ? 0xffffff : 0x999999)//.width('50%')
          .borderRadius(8)
          .fontSize(this.fontSize)  // ?????????
          .height(this.buttonHeight)  // ?????????
          .width(this.buttonWidth)  // ?????????
          .key(`${this.app.appName}_${this.idx}_shortcut`)
          .focusBox({
            strokeWidth: LengthMetrics.px(0)
          })
          .onClick(() => {
            emitter.emit('removeShortcuts', { data: this.app.bundleName })
          })
          .onHover((isHover: boolean) => {
            this.removeShortCutsFocused = isHover;
          })
          .onFocus(() => {
            this.removeShortCutsFocused = true;
          })
          .onBlur(() => {
            this.removeShortCutsFocused = false;
          })
          .onKeyEvent((event) =>{
            if (event.keyCode === KeyCode.KEY_DPAD_DOWN && event.type === KeyType.Down) {
              if(this.removeShortCutsFocusAble) {
                focusControl.requestFocus(`${this.app.appName}_${this.idx}`)
              }
            }
          })
          .focusable(this.isEdit && this.removeShortCutsFocusAble)
          .margin({ left: this.buttonMarginLeft, bottom: '10lpx' })  // ???????
          .visibility((this.isEdit && this.app.canRemove && this.app.isFocus && this.removeShortCutsVisibleInEdit) ?
          Visibility.Visible :
          Visibility.Hidden)

        Stack({ alignContent: Alignment.Center }) {
          Column() {
            Column() {
              Image(this.app.isFocus ? this.app.onFocusIcon : this.app.icon)
                .width(this.iconSize)  // ?????????
                .height(this.iconSize)  // ?????????
                .syncLoad(true)
                .objectFit(ImageFit.Contain)
                .zIndex(1)
            }.width(this.app.isFocus ? this.focusedContainerWidth : this.normalContainerWidth)
            .height(this.app.isFocus ? this.focusedContainerHeight : this.normalContainerHeight)
            .justifyContent(FlexAlign.Center)
            .alignItems(HorizontalAlign.Center)
            .backgroundColor(this.app.isFocus ? Color.White : '#33F1F3F5')
            .borderRadius('12lpx')
          }
          .justifyContent(FlexAlign.Center)
          .alignItems(HorizontalAlign.Center)
          .width(this.mainContainerWidth)  // ?????????
          .height(this.mainContainerHeight)  // ?????????
          .backgroundImage(this.app.isFocus ? $r('app.media.item_bg') : '')
          .backgroundImageSize(ImageSize.Contain)
          .backgroundImagePosition(Alignment.Center)

          Row() {
            if (this.isShowArrow(this.idx, true) && !this.isMoving) {
              Image($r('app.media.left'))
                .width('25lpx')
                .height('50lpx')
                .onAppear(() => {
                  animateTo({
                    playMode: PlayMode.Alternate,
                    iterations: this.repeatTime
                  }, () => {
                    this.arrowLeftXPos = this.endDis
                  })
                })
                .onDisAppear(() => {
                  this.arrowLeftXPos = this.startDis
                })
                .translate({ x: `${this.arrowLeftXPos}lpx` })
            }
            if (this.isShowArrow(this.idx, false) && !this.isMoving) {
              Image($r('app.media.right'))
                .width('25lpx')
                .height('50lpx')
                .onAppear(() => {
                  animateTo({
                    playMode: PlayMode.Alternate,
                    iterations: this.repeatTime
                  }, () => {
                    this.arrowRightXPos = this.endDis
                  })
                })
                .onDisAppear(() => {
                  this.arrowRightXPos = this.startDis
                })
                .translate({ x: `-${this.arrowRightXPos}lpx` })
            }
          }.width(this.arrowContainerWidth)  // ???????????
          .justifyContent(this.isShowArrow(this.idx, true) && this.isShowArrow(this.idx, false) ? FlexAlign.SpaceBetween
            : this.isShowArrow(this.idx, true) ? FlexAlign.Start : FlexAlign.End)
        }

        Row() {
          Text(this.app.appName)
            .textAlign(TextAlign.Center)
            .fontColor(this.app.isFocus ? 'rgba(255,255,255,0.86)' : 'rgba(255,255,255,0.6)')
            .fontWeight(this.app.isFocus ? FontWeight.Medium : FontWeight.Regular)
            .margin({ top: this.app.isFocus ? this.textMarginTop : this.textMarginTopNormal })  // ?????????
            .fontSize(this.app.isFocus ? this.textFontSizeFocused : this.textFontSizeNormal)  // ???????????
            .width('100%')
              .key(`${this.app.appName}_${this.idx}`)
              .focusable(true)
              .focusBox({
                strokeWidth: LengthMetrics.px(0)
              })
            .onFocus(() => {
              this.removeShortCutsFocusAble = true;
            })
        }.justifyContent(FlexAlign.Center)
        .width('100%')
      }
      .width('100%')
      .height('100%')
      .alignItems(HorizontalAlign.Center)
      .justifyContent(FlexAlign.Start)  // ??FlexAlign.Start???????????
      .focusable(true)
      .onFocus(() => {
        Log.showInfo(TAG, `??onFocuse start item: ${this.app.appName}, index: ${this.idx}`)
        this.app.isFocus = true;
        if(!this.itemEnable) {
          return
        }
        //??????????
        this.focusNumber++
        if (this.focusNumber === 1) {
          getContext(globalThis.desktopContext).eventHub.emit('subscribeListener')
        }
        //????
        this.changeBackgroundImage(this.app!);
        if (!this.isEdit) {
          console.log(`Current idx:${this.idx}, lastIdx:${this.lastIds}`);
          // ?????????
          const scrollThreshold = 5; // ????????
          const animationDuration = 1000; // ????????
          // ??????
          let xOffset = 0;
          let shouldScroll = false;
          if (this.idx > scrollThreshold && this.lastIds == '1') {
            // ??????
            console.log('Scrolling right');
            xOffset = (this.idx - scrollThreshold) * this.itemWidth;
            shouldScroll = true;
          } else if (this.idx <= 0) {
            // ??????
            console.log('Scrolling left');
            xOffset = (this.idx - 1) * this.itemWidth;
            shouldScroll = true;
            this.lastIds = '0'
          }
          // ????????????
          if (shouldScroll) {
            this.scroller.scrollTo({
              xOffset: `${xOffset}lpx`,
              yOffset: 0,
              animation: { duration: animationDuration }
            });
          } else {
            // ????????????
            console.log('No scroll needed');
          }
        }
        AppStorage.setOrCreate('focusIdx', this.idx);
        Log.showInfo(TAG, `??onFocuse end item: ${this.app.appName}, index: ${this.idx}`)
      })
      .onBlur(() => {
        if(!this.itemEnable) {
          return
        }
        getContext(globalThis.desktopContext).eventHub.emit('unSubscribeListener')
        Log.showInfo(TAG, `??onBlur item: ${this.app.appName}, index: ${this.idx}`)
        this.app.isFocus = false;
        this.removeShortCutsFocusAble = false;
      })
      .onKeyEvent((event) => {
        if (this.isEdit) {
          event.stopPropagation()
        }
        Log.showInfo(TAG, `onKeyEvent event keyCode: ${JSON.stringify(event)}`)
        if (this.isEdit) {
          if (event.keyCode === KeyCode.KEY_DPAD_LEFT && event.type === KeyType.Down) {
            if (this.moveToLeft) {
              this.isMoving = true
              this.moveToLeft()
              this.isMoving = false
              this.removeShortCutsVisibleInEdit = false;
              this.removeShortCutsFocused = false
            }
          }
          if (event.keyCode === KeyCode.KEY_DPAD_RIGHT && event.type === KeyType.Down) {
            if (this.moveToRight) {
              this.removeShortCutsVisibleInEdit = false;
              this.removeShortCutsFocused = false
              this.isMoving = true
              this.moveToRight()
              this.isMoving = false
            }
          }
          if (event.keyCode === KeyCode.KEY_DPAD_UP && event.type === KeyType.Down) {
            if(this.removeShortCutsFocusAble) {
              focusControl.requestFocus(`${this.app.appName}_${this.idx}_shortcut`)
            }
          }
          //?? 2  w 2039
          if ((event.keyCode === 2039 || event.keyCode === 2 || event.keyCode == KeyCode.KEY_ENTER) &&
            event.type === KeyType.Down) {
            if (this.pressBack) {
              this.pressBack()
            }
          }
           //??????????????
          if ((event.keyCode == KeyCode.KEYCODE_TV_Ray || event.keyCode == KeyCode.KEYCODE_TV ||
            event.keyCode == KeyCode.KEYCODE_TAPE || event.keyCode == KeyCode.KEYCODE_SETUP) &&
            event.type === KeyType.Up) {
            if (this.pressBack) {
              console.log('DesktopAppItem==' + event.keyCode);
              this.pressBack()
            }
          }
        } else {
          if (event.keyCode == 2033 && event.type == KeyType.Down) {
            this.isEdit = true
          }
          if (event.keyCode == KeyCode.KEY_ENTER && event.type == KeyType.Down) {
            if (this.app.appName == '????') {
              emitter.emit('startAllApp');
            } else {
              const abilityName = this.app.abilityName ?? '';
              const bundleName = this.app.bundleName ?? '';
              launcherAbilityManager.startLauncherAbility(abilityName, bundleName, '');
            }
          }
          if (event.keyCode == KeyCode.KEY_DPAD_LEFT && event.type == KeyType.Down) {
            this.focusIdx--
          }
          if (event.keyCode == KeyCode.KEY_DPAD_RIGHT && event.type == KeyType.Down) {
            this.focusIdx++
          }
        }
      })
      .onTouch((event) => {
        if (this.isEdit) {
          return;
        }
        if (event.sourceTool == SourceTool.Pen) {
          PointerUtil.changePointStyle(event.type == TouchType.Down);
        }
        if (event.sourceTool !== SourceTool.Pen && event.sourceTool !== SOURCE_TOOL_SEVEN &&
          event.sourceTool !== SourceTool.Finger) {
          return;
        }
        if (event.type === TouchType.Down) {
          this.touchStartX = event.touches[0].x;
          this.touchStartY = event.touches[0].y;
          this.isSwiping = false;
          Log.showDebug(TAG, `onTouch down x: ${this.touchStartX}, y: ${this.touchStartY}`);
        } else if (event.type === TouchType.Move) {
          // ???????????????????
          if (!this.isSwiping && this.touchStartX !== 0) {
            const dx = Math.abs(event.touches[0].x - this.touchStartX);
            const dy = Math.abs(event.touches[0].y - this.touchStartY);
            Log.showDebug(TAG, `onTouch move dx: ${dx}, y: ${dy}`);
            if (dx > SWIPE_THRESHOLD || dy > SWIPE_THRESHOLD) {
              this.isSwiping = true;
            }
          }
        } else if (event.type === TouchType.Up) {
          Log.showDebug(TAG, `onTouch up isSwiping : ${this.isSwiping}`);
          // ????????????????????
          if (!this.isSwiping) {
            focusControl.requestFocus(`${this.app.appName}_${this.idx}`);
            if (this.app.appName == '????') {
              emitter.emit('startAllApp');
            } else {
              const abilityName = this.app.abilityName ?? '';
              const bundleName = this.app.bundleName ?? '';
              launcherAbilityManager.startLauncherAbility(abilityName, bundleName, '');
            }
          }
          // ????????
          this.touchStartX = 0;
          this.touchStartY = 0;
          this.isSwiping = false;
        }
      })
      .onHover(() => {
        if (this.isEdit) {
          return
        }
        focusControl.requestFocus(`${this.app.appName}_${this.idx}`)
      })
    }
    .width('100%')
    .height('100%')
  }

  /**
   * ??????????launcher??
   * @param appName ????
   */
  changeBackgroundImage(app: AppItemInfo) {
    iEventPublisher.emit('APP_CHANGE', app);
  }
}