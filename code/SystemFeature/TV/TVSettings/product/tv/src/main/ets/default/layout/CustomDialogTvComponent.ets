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

import LogUtil from '../../../../../../../common/utils/src/main/ets/default/baseUtil/LogUtil';
import ConfigData from '../../../../../../../common/utils/src/main/ets/default/baseUtil/ConfigData';
import lpx from '../../common/Lpx';
import { KeyCode } from '../../common/constants/KeyCode';
import InputMethod from '@ohos.inputMethod';
import {
  CustomDialogButtonStyle,
  CustomDialogContentStyle,
  SourcetoolConstants,
  StyleConstants
} from '../../common/constants/StyleConstants'
import promptAction from '@ohos.promptAction';
import { inputEventClient } from '@kit.InputKit';
import { i18n } from '@kit.LocalizationKit';
import { ColorMetrics } from '@kit.ArkUI';
import { EventUtil } from '../../common/EventUtil';

const TAG = 'CustomDialogTvComponent';

class InjectedKeyEventPayload {
}

@CustomDialog
export struct CustomDialogTvComponent {
  content: DialogContent = new DialogContent('标题', '内容', '取消', '确认', 0, 0)
  controller: CustomDialogController
  buttonStyle: CustomDialogButtonStyle = CustomDialogButtonStyle.default
  contentStyle: CustomDialogContentStyle = CustomDialogContentStyle.default
  @State focusIndex: number = -1
  @State userInputs: string = '';
  @State userCustomTime: number = 0
  @State selectDate: Date = new Date()
  @State is24TimeFormat: boolean = false
  private dateFormat = new Intl.DateTimeFormat('zh-Cn', {
    dateStyle: 'full'
  })
  private timeFormat = new Intl.DateTimeFormat('zh-Cn', {
    hour: '2-digit',
    minute: '2-digit',
    hour12: !this.is24TimeFormat
  })
  cancel: Function = () => {
  }
  confirm: Function = () => {
  }

  onPageShow(): void {
    this.tabClick();
  }

  tabClick() {
    let keyDownOpt: inputEventClient.KeyEvent = {
      isPressed: true,
      keyCode: KeyCode.KEYCODE_TAB,
      keyDownDuration: 0,
      isIntercepted: false
    };
    let keyUpOpt: inputEventClient.KeyEvent = {
      isPressed: false,
      keyCode: KeyCode.KEYCODE_TAB,
      keyDownDuration: 0,
      isIntercepted: false
    };
    let eventDown: InjectedKeyEventPayload = new InjectedKeyEventPayload()
    Reflect.set(eventDown, 'KeyEvent', keyDownOpt)
    let eventUp: InjectedKeyEventPayload = new InjectedKeyEventPayload()
    Reflect.set(eventUp, 'KeyEvent', keyUpOpt)

    try {
      inputEventClient.injectEvent(eventDown as never);
      inputEventClient.injectEvent(eventUp as never);
      console.log('手动触发tab点击成功')
    } catch (e) {
      console.log('手动触发tab点击失败')
    }
  }

  get24HourFormat() {
    this.is24TimeFormat = i18n.System.is24HourClock()
  }

  aboutToAppear() {
    LogUtil.info(TAG + 'aboutToAppear' + '宽度' + this.content.dialogWidth + '高度' + this.content.dialogHeight)
    this.get24HourFormat()
    this.userCustomTime = this.selectDate.getTime()
    if (this.content.content === '此操作将会连接当前wifi') {
      this.tabClick();
    }
  }

  build() {
    Column() {
      Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center }) {
        if (this.contentStyle === CustomDialogContentStyle.titleInput ||
          this.contentStyle === CustomDialogContentStyle.titleContent) {
          Text(this.content.title)
            .textAlign(TextAlign.Center)
            .fontColor(Color.White)
            .fontSize(lpx(40))
            .margin({
              bottom: lpx(48)
            })
        }

        if (this.contentStyle === CustomDialogContentStyle.default ||
          this.contentStyle === CustomDialogContentStyle.titleContent) {
          Text(this.content.content)
            .textAlign(TextAlign.Center)
            .fontColor(Color.White)
            .fontSize(lpx(24))
            .margin({
              bottom: lpx(48)
            })
        }

        if (this.contentStyle === CustomDialogContentStyle.titleInput ||
          this.contentStyle === CustomDialogContentStyle.input) {
          TextInput({ placeholder: this.content.content, text: this.userInputs })
            .width('90%')
            .height(lpx(90))
            .backgroundColor('#434343')
            .fontSize(lpx(36))
            .margin({
              bottom: lpx(48)
            })
            .maxLength(30)
            .fontColor(Color.White)
            .placeholderColor('#80ffffff')
            .placeholderFont({ size: lpx(36) })
            .caretColor(Color.White)
            .defaultFocus(true)
            .border({
              width: this.focusIndex === 0 ? 2 + 'lpx' : 0,
              radius: globalThis.screenHeight * 0.05 + 'lpx',
              color: Color.White,
              style: BorderStyle.Solid
            })
            .key('textInput')
            .enableKeyboardOnFocus(true)
            .focusable(true)
            .onFocus(() => {
              this.focusIndex = 0;
              LogUtil.info(TAG + 'textInput:' + this.focusIndex);
            })
            .onBlur(() => {
              this.focusIndex = -1;
            })
            .onKeyEvent((event?: KeyEvent) => {
              if (!event) {
                return;
              }
              if (event.keyCode === KeyCode.KEY_DPAD_UP || event.keyCode === KeyCode.KEY_DPAD_LEFT ||
                event.keyCode === KeyCode.KEY_DPAD_RIGHT) {
                event.stopPropagation?.();
              }

              switch (event.keyCode) {
                case KeyCode.KEY_0:
                case KeyCode.KEY_1:
                case KeyCode.KEY_2:
                case KeyCode.KEY_3:
                case KeyCode.KEY_4:
                case KeyCode.KEY_5:
                case KeyCode.KEY_6:
                case KeyCode.KEY_7:
                case KeyCode.KEY_8:
                case KeyCode.KEY_9:
                  if (event.type === KeyType.Up) {
                    this.userInputs += event.keyCode % 2000;
                    LogUtil.info(TAG + ':input value:' + this.userInputs);
                    if (this.userInputs.length > 30) {
                      this.userInputs.substring(0, 30);
                      promptAction.showToast({
                        message: '自定义名称超长',
                        duration: 2000,
                        bottom: globalThis.screenHeight / 4
                      })
                      return;
                    }
                  }
                  break;
                case KeyCode.KEY_ENTER:
                  focusControl.requestFocus('textInput')
                  break;
                case KeyCode.KEY_DPAD_DOWN:
                  focusControl.requestFocus('confirm')
                  event.stopPropagation?.()
                  break;
              }
            })
            .onChange((value) => {
              this.userInputs = value.trim();
            })
            .onSubmit((enterKey) => {
              InputMethod.getInputMethodController().stopInput()
                .then((ret) => {
                  LogUtil.debug(`${ConfigData.TAG}, enterType: ${enterKey}, stopInput: ${ret}`);
                });
            })
        }

        //自定义日期选择弹窗
        if (this.contentStyle === CustomDialogContentStyle.DatePicker) {
          Column() {
            Text(this.dateFormat.format(this.selectDate))
              .fontColor(('rgb(255, 255, 255)'))
              .fontSize(lpx(40))
            DatePicker({ selected: this.selectDate })
              .disappearTextStyle({ color: ('rgba(255, 255, 255, 0.50)'), font: { size: lpx(30) } })
              .textStyle({ color: ('rgba(255, 255, 255, 0.70)'), font: { size: lpx(30) } })
              .selectedTextStyle({ color: ('rgb(255, 255, 255)'), font: { size: lpx(36) } })
              .width('100%')
              .layoutWeight(1)
              .onDateChange((date: Date) => {
                this.selectDate = new Date(date.getTime())
                this.userCustomTime = date.getTime()
                LogUtil.info(TAG + '--日期选择器onchange-result：' + date as string)
                console.log(TAG + 'date change数据' + this.selectDate)
              })
              .focusable(true)
              .onFocus(() => {
                this.focusIndex = 0;
                LogUtil.info(TAG + 'textInput:' + this.focusIndex);
              })
              .onKeyEvent((event?: KeyEvent) => {
                if (!event) {
                  return;
                }
                if (event.keyCode === KeyCode.KEY_ENTER && event.type === KeyType.Up) {
                  focusControl.requestFocus('confirm')
                  event.stopPropagation?.()
                }
              })
              .onHover(() => {
                focusControl.requestFocus('Cancel')
              })
              .onTouch((event?: TouchEvent) => {
                if (!event) {
                  return;
                }
                if (!EventUtil.isTouchEvent(event)) {
                  return;
                }
              })
          }
          .width('100%')
          .justifyContent(FlexAlign.Start)
          .alignItems(HorizontalAlign.Center)
          .backgroundColor('rgb(64, 64, 64)')
          .borderRadius(lpx(24))
        }

        //自定义时间选择弹窗
        if (this.contentStyle === CustomDialogContentStyle.TimePicker) {

          Column() {
            Text(this.dateFormat.format(new Date()))
              .fontColor(('rgb(255, 255, 255)'))
              .fontSize(lpx(40))
            TimePicker()
              .useMilitaryTime(this.is24TimeFormat)
              .disappearTextStyle({ color: ('rgba(255, 255, 255, 0.50)'), font: { size: lpx(30) } })
              .textStyle({ color: ('rgba(255, 255, 255, 0.70)'), font: { size: lpx(28) } })
              .selectedTextStyle({
                color: ('rgb(255, 255, 255)'),
                font: { size: lpx(32) }
              })
              .width('100%')
              .layoutWeight(1)
              .loop(true)
              .onChange((result) => {
                LogUtil.info(TAG + '滑动时间')
                let currentTime = new Date()
                let time =
                  new Date(currentTime.getFullYear(), currentTime.getMonth(), currentTime.getDay(), result.hour,
                    result.minute, result.second)
                currentTime.setHours(result.hour, result.minute)
                this.selectDate = new Date()
                this.userCustomTime = currentTime.getTime()
                LogUtil.info(TAG + '--时间选择器onchange-result：' + JSON.stringify(result) + '--' + time.toString())
              })
              .focusable(true)
              .onFocus(() => {
                this.focusIndex = 0;
                LogUtil.info(TAG + 'textInput:' + this.focusIndex);
              })
              .onKeyEvent((event?: KeyEvent) => {
                if (!event) {
                  return;
                }
                if (event.keyCode === KeyCode.KEY_ENTER && event.type === KeyType.Up) {
                  focusControl.requestFocus('confirm')
                  event.stopPropagation?.()
                }
              })
          }
          .width('100%')
          .justifyContent(FlexAlign.Start)
          .alignItems(HorizontalAlign.Center)
          .backgroundColor('rgb(64, 64, 64)')
          .borderRadius(lpx(24))

        }

        //按钮
        Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center, justifyContent: FlexAlign.SpaceEvenly }) {
          if (this.buttonStyle === CustomDialogButtonStyle.default) {
            Column() {
              Text(this.content.firstValue)
                .width(lpx(248))
                .height(lpx(72))
                .textAlign(TextAlign.Center)
                .fontColor(this.focusIndex === 1 ? Color.Black : Color.White)
                .fontSize(lpx(36))
                .borderRadius(lpx(200))
                .backgroundColor(this.focusIndex === 1 ? Color.White : '#666666')
                .key('Cancel')
                .defaultFocus(true)
                .focusable(true)
                .stateStyles({
                  focused: {
                    .border({
                      color: Color.Transparent
                    })
                  }
                })
                .onFocus(() => {
                  this.focusIndex = 1;
                })
                .onBlur(() => {
                  this.focusIndex = -1
                })
                .onKeyEvent((event?: KeyEvent) => {
                  if (!event) {
                    return;
                  }
                  if (event.keyCode === KeyCode.KEY_DPAD_LEFT || event.keyCode === KeyCode.KEY_DPAD_DOWN ||
                    (event.keyCode === KeyCode.KEY_DPAD_UP &&
                      (this.contentStyle === CustomDialogContentStyle.titleContent ||
                        this.contentStyle === CustomDialogContentStyle.default))) {
                    event.stopPropagation?.();
                  }
                })
                .onHover(() => {
                  this.focusIndex = 1;
                })
                .onClick(()=>{
                  this.cancel();
                })
                .onTouch((event?: TouchEvent) => {
                  if (!event) {
                    return;
                  }
                  if (!EventUtil.isTouchEvent(event)) {
                    return;
                  }
                  if (event.sourceTool !== SourceTool.Pen &&
                    event.sourceTool !== SourcetoolConstants.SOURCE_TOOL_MOUSE_CLICK) {
                    return;
                  }
                  this.cancel();
                })
            }
            .width(this.focusIndex === 1 ? lpx(266) : lpx(248))
            .height(this.focusIndex === 1 ? lpx(90) : lpx(72))
            .border({
              width: this.focusIndex === 1 ? lpx(2) : 0,
              radius: lpx(200),
              color: Color.White,
              style: BorderStyle.Solid
            })
            .justifyContent(FlexAlign.Center)
          }

          Column() {
            Text(this.content.secondValue)
              .width(lpx(248))
              .height(lpx(72))
              .textAlign(TextAlign.Center)
              .borderRadius(lpx(200))
              .key('confirm')
              .fontColor(this.focusIndex === 2 ? Color.Black : Color.White)
              .fontSize(lpx(36))
              .backgroundColor(this.focusIndex === 2 ? Color.White : '#666666')
              .focusable(true)
              .stateStyles({
                focused: {
                  .border({
                    color: Color.Transparent
                  })
                }
              })
              .onFocus(() => {
                this.focusIndex = 2;
              })
              .onBlur(() => {
                this.focusIndex = -1
              })
              .onKeyEvent((event?: KeyEvent) => {
                if (!event) {
                  return;
                }
                if (event.keyCode === KeyCode.KEY_DPAD_RIGHT || event.keyCode === KeyCode.KEY_DPAD_DOWN ||
                  (event.keyCode === KeyCode.KEY_DPAD_UP &&
                    (this.contentStyle === CustomDialogContentStyle.titleContent ||
                      this.contentStyle === CustomDialogContentStyle.default))) {
                  event.stopPropagation?.();
                }
              })
              .onClick(()=>{
                this.content.setTextInputValue(this.userInputs);
                this.content.setCustomTime(this.userCustomTime)
                this.confirm();
              })
              .onHover(() => {
                this.focusIndex = 2;
              })
              .onTouch((event?: TouchEvent) => {
                if (!event) {
                  return;
                }
                if (!EventUtil.isTouchEvent(event)) {
                  return;
                }
                if (event.sourceTool !== SourceTool.Pen &&
                  event.sourceTool !== SourcetoolConstants.SOURCE_TOOL_MOUSE_CLICK) {
                  return;
                }

                this.content.setTextInputValue(this.userInputs);
                this.content.setCustomTime(this.userCustomTime)
                this.confirm();
              })
          }
          .width(this.focusIndex === 2 ? lpx(266) : lpx(248))
          .height(this.focusIndex === 2 ? lpx(90) : lpx(72))
          .border({
            width: this.focusIndex === 2 ? lpx(2) : 0,
            radius: lpx(200),
            color: Color.White,
            style: BorderStyle.Solid
          })
          .justifyContent(FlexAlign.Center)
        }
        .height(lpx(90))
        .onAppear(() => {
          focusControl.requestFocus('Cancel')
        })

      }
      .padding({
        top: lpx(48),
        bottom: lpx(48)
      })
      .height(this.content.dialogHeight)
      .width(this.content.dialogWidth)
      .backgroundColor(StyleConstants.DEFAULT_SETTING)
      .borderRadius(lpx(24))
      .onAppear(() => {
        if (!(this.contentStyle === CustomDialogContentStyle.input ||
          this.contentStyle === CustomDialogContentStyle.titleInput ||
          this.contentStyle === CustomDialogContentStyle.DatePicker ||
          this.contentStyle === CustomDialogContentStyle.TimePicker)) {
          focusControl.requestFocus('Cancel');
        }
      })

    }
    .height('100%')
    .width('100%')
    .backgroundColor('#b3000000')
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)

  }
}

export class DialogContent {
  public title: string;
  public content: string;
  public textInputValue: string = '';
  public firstValue: string;
  public secondValue: string;
  public dialogWidth: Length;
  public dialogHeight: Length
  public customTime: number = 0;

  constructor(title: string, content: string, firstValue: string, secondValue: string, dialogWidth: Length,
    dialogHeight: Length) {
    this.title = title;
    this.content = content;
    this.firstValue = firstValue === '' ? '取消' : firstValue;
    this.secondValue = secondValue === '' ? '确认' : secondValue;
    this.dialogWidth = dialogWidth as number === 0 ? lpx(globalThis.screenWidth / 2) : lpx(Number(dialogWidth));
    this.dialogHeight = dialogHeight as number === 0 ? lpx(globalThis.screenHeight / 2) : lpx(Number(dialogHeight));
  }

  setTextInputValue(value: string) {
    this.textInputValue = value;
  }

  getTextInputValue() {
    return this.textInputValue;
  }

  setCustomTime(value: number) {
    this.customTime = value
  }

  getCustomTime() {
    return this.customTime
  }
}
